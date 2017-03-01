class Fusionbox
    def Fusionbox.configure(config, settings)
        ENV['VAGRANT_DEFAULT_PROVIDER'] = "virtualbox"

        # Configure local variable to access scripts from remote location
        scriptDir = File.dirname(__FILE__)

        # Prevent TTY errors
        config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

        # Allow SSH agent forward from the box
        config.ssh.forward_agent = true

        # Configure the box
        config.vm.box = "fusion/box"
        config.vm.hostname = "fusionbox"

        # Configure a private network IP
        config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.80"

        if settings.has_key?("networks")
            settings["networks"].each do |network|
                config.vm.network network["type"], ip: network["ip"], bridge: network["bridge"] ||= nil
            end
        end

        # Configure a few Virtualbox settings
        config.vm.provider "virtualbox" do |vb|
            vb.name = settings["name"] ||= "fusionbox"
            vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
            vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
            vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", settings["natdnshostresolver"] ||= "on"]

            if settings.has_key?("gui") && settings["gui"]
                vb.gui = true
            end
        end

        # Standardize port naming schema
        if (settings.has_key?("ports"))
            settings["ports"].each do |port|
                port["guest"] ||= port["to"]
                port["host"] ||= port["send"]
                port["protocol"] ||= "tcp"
            end
        else
            settings["ports"] = []
        end

        # Default port forwarding
        default_ports = {
            80   => 8080,
            443  => 44380,
            3306 => 33080,
            5432 => 54328,
            22   => 2280
        }

        # Use default port forwardning unless overridden
        unless settings.has_key?("default_ports") && settings["default_ports"] == false
            default_ports.each do |guest, host|
                unless settings["ports"].any? { |mapping| mapping["guest"] == guest }
                    config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
                end
            end
        end

        # Add custom ports from configuration
        if settings.has_key?("ports")
            settings["ports"].each do |port|
                config.vm.network "forwarded_port", guest: port["guest"], host: port["host"], protocol: port["protocol"], auto_correct: true
            end
        end

        # Register all of the configured shared folders
        if settings.include? 'folders'
            settings["folders"].each do |folder|
                if File.exists? File.expand_path(folder["map"])
                    mount_opts = ["dmode=777", "fmode=666"]

                    if (folder["type"] == "nfs")
                        mount_opts = folder["mount_options"] ? folder["mount_options"] : ['actimeo=1', 'nolock']
                    end

                    options = (folder["options"] || {}).merge({ mount_options: mount_opts })

                    options.keys.each{|k| options[k.to_sym] = options.delete(k) }

                    config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil, **options

                    if Vagrant.has_plugin?("vagrant-bindfs")
                        config.bindfs.bind_folder folder["to"], folder["to"]
                    end
                else
                    config.vm.provision "shell" do |s|
                        s.inline = ">&2 echo \"Unable to mount one of your folders. Please check your folders in the Fusionbox config file.\""
                    end
                end
            end
        end

        # Clear all of the configured apache sites
        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/reset-vhost.sh"
        end

        # Register all of the configured apache sites
        if settings.include? 'sites'
            settings["sites"].each do |site|
                config.vm.provision "shell" do |s|
                    s.path = scriptDir + "/create-vhost.sh"
                    s.args = [site["map"], site["to"]]
                end
            end

            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/restart-httpd.sh"
            end
        end

        # Configure all of the supervisor sites
        if settings.has_key?("supervise")
            settings["supervise"].each do |job|
                config.vm.provision "shell" do |s|
                    s.path = scriptDir + "/create-supervisor.sh"
                    s.args = [job["name"], job["command"], job["directory"], job["log"]]
                end
            end
        end

        # Configure all of the configured databases
        if settings.has_key?("databases")
            settings["databases"].each do |db|
                config.vm.provision "shell" do |s|
                    s.path = scriptDir + "/create-database.sh"
                    s.args = [db]
                end
            end
        end
    end
end

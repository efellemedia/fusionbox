class Fusionbox
    def Fusionbox.configure(config, settings)
        ENV['VAGRANT_DEFAULT_PROVIDER'] = "virtualbox"

        # Configure local variable to access scripts from remote location
        scriptDir = File.dirname(__FILE__)

        # Configure the box
        config.vm.box = "fusion/box"
        config.vm.box.version = ">= 1.0.0"
        config.vm.hostname = "fusionbox"

        # Configure a private network IP
        config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.80"

        # Configure a few Virtualbox settings
        config.vm.provider "virtualbox" do |vb|
            vb.name = settings["name"] ||= "fusionbox"
            vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
            vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
        end

        # Register all of the configured shared folders
        if settings.include? 'folders'
            settings["folders"].each do |folder|
                config.vm.synced_folder folder["map"], folder["to"]
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
                    s.args = [site["map"], site[""]]
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

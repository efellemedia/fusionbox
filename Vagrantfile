VAGRANTFILE_API_VERSION = "2"

require 'yaml'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Configure the box
    config.vm.box = "fusion/box"
    config.vm.hostname = "fusionbox"

    # Read the folder/site settings
    settings = YAML::load(File.read('./Fusionbox.yaml'))

    # Configure some virtualbox settings
    config.vm.network "private_network", ip: "192.168.33.80"

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
    end

    # Register all of the configured shared folders
    settings["folders"].each do |folder|
        config.vm.synced_folder folder["map"], folder["to"]
    end
end

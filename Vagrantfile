require 'yaml'

VAGRANTFILE_API_VERSION = "2"

confDir = $confDir ||= File.expand_path("~/.fusionbox")
fusionboxPath = confDir + "/Fusionbox.yaml"

require File.expand_path(File.dirname(__FILE__) + '/scripts/fusionbox.rb')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    if File.exists? fusionboxPath then
        Homestead.configure(config, YAML::load(File.read(fusionboxPath)))
    end
end

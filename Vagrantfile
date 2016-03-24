# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.box = "fusion/box"
    config.vm.network "private_network", ip: "192.168.33.80"
    config.vm.hostname = "fusionbox"
    config.vm.synced_folder "./public", "/var/www", :mount_options => ["dmode=777", "fmode=666"]

end

# Fusionbox
Fusionbox is a preconfigured Vagrant Box that matches our Rackspace CentOS server setup, allowing you the ability to easily run FusionCMS v4 locally in no time. It provides you with everything without requiring you to install PHP, Apache, or any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!

Fusionbox runs on any Windows, Mac, or Linux system, and includes the Apache web server, PHP 5.3, MySQL, and all of the other goodies you need to develop amazing v4 projects.

## Included Software
- CentOS 6
- PHP 5.5.34
 - GD
 - PDO
 - mbstring
 - Soap
 - xml
- MySQL

## First Steps
Before launching your Fusionbox environment, you must install [VirtualBox 5.x](https://www.virtualbox.org) as well as [Vagrant](https://www.vagrantup.com). Both of these software packages provide easy-to-use visual installers for all popular operating systems.

### Installing the Fusionbox Vagrant Box
Once VirtualBox and Vagrant have been installed, you should add the `fusion/box` box to your Vagrant installation using the following command in your terminal. It will take a few minutes to download the box, depending on your internet connection speed:

```
vagrant box add fusion/box
```

If this command fails, make sure your Vagrant installation is up to date.

### Installing Fusionbox
You may install Fusionbox by simply running the following command.

```
sh -c "$(curl -fsSL "https://raw.githubusercontent.com/efellemedia/fusionbox/master/src/bin/install")"
```

## Configuring Fusionbox
You may configure your Fusionbox instance by using the `fusionbox config` command from your terminal.

### Configuring Shared Folders
The `folders` property of the Fusionbox configuration file lists all the folders you wish to share with your Fusionbox environment. As files within these folders are changed, they will be kept in sync between your local machine and the Fusionbox environment. You may configure as many shared folders as necessary:

```
folders:
    - map: ~/Code
      to: /var/www
```

To enable [NFS](https://www.vagrantup.com/docs/synced-folders/nfs.html), just add a simple flag to your synced folder configuration. Enabling NFS will significantly speed up page load speeds for most users.

```
folders:
    - map: ~/Code
      to: /var/www
      type: "nfs"
```

### Configuring Apache Sites
Not familiar with Apache? No problem. The `sites` property allows you to easily map a "domain" to a folder on your Fusionbox environment. A sample site configuration is included in the Fusionbox configuration file. Again, you may add as many sites to your Fusionbox environment as necessary. Fusionbox can serve as a convenient, virtualized environment for every v4 project you are working on (including the CMS itself):

```
sites:
    - map: hometikibar.dev
      to: /var/www/hometiki/trunk
```

If you change the `sites` property after provisioning the Fusionbox environment, you should re-run `fusionbox reload --provision` to update the virtual host configuration on the virtual machine.

### The Hosts File
You must add the "domains" for your Apache sites to the `hosts` file on your machine. The `hosts` file will redirect requests for your Fusionbox sites in your Fusionbox machine. On Mac and Linux, this file is located at `/etc/hosts`. On Windows, it is located at `C:\Windows\System32\drivers\etc\hosts`. The lines you add to this file will look like the following:

```
192.168.10.80 hometikibar.dev
```

Make sure the IP address listed in the one set in your Fusionbox configuration file. Once you have added your domain to your `hosts` file, you can access the site via your web browser:

```
http://hometikibar.dev
```

## Launching the Fusionbox Environment
Once you have edited the `fusionbox.yaml` file to your liking, run the `vagrant up` command from your Fusionbox directory. Vagrant will boot the virtual machine and automatically configure your shared folders and Apache sites.

To destroy the machine, you may use the `fusionbox destroy --force` command.

## Daily Usage

### Connecting via SSH
You can SSH into your virtual machine by running the `fusionbox ssh` terminal command.

### Connecting to Databases
To connect to your MySQL database from your host machine via Navicat or Sequel Pro, you should connect to `127.0.0.1` and port `33060`. The username and password is `root` / *blank*.

> **Note:** You should only use this non-standard port when connecting to the databases from your host machine. You will use the default 3306 port in your v5 constants file since your v4 project is running *within* the virtual machine.

### Adding Additional Sites
Once your Fusionbox environment is provisioned and running, you may want to add additional Apache sites for your v4 projects. You can run as many v4 projects as you wish on a single Fusionbox environment. To add an additional site, simply add the site to your Fusionbox configuration file (`fusionbox config`) and then run the `fusionbox provision` terminal command.

## Ports
By default, the following ports are forwarded to your Fusionbox environment:

- **SSH:** 2222 → Forwards to 22
- **HTTP:** 8000 → Forwards to 80
- **MySQL:** 33060 → Forwards to 3306

### Forwarding Additional Ports
If you wish, you may forward additional ports to the Vagrant box, as well as specify their protocol:

```
ports:
    - send: 93000
      to: 9300
    - send: 7777
      to: 777
      protocol: udp
```

## Updating Fusionbox
You can update Fusionbox in two simple steps. First, you should update the Vagrant box using the `fusionbox box update` command:

```
fusionbox box update
```

Next, you need to update the Fusionbox source code. Simply `cd` to `~/.fusionbox` and run `git pull origin master`.

```
cd ~/.fusionbox
git pull origin master
```

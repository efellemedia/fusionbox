# Fusion Box
Fusion Box is a preconfigured Vagrant Box that matches our Rackspace CentOS server setup, allowing the ability to easily run FusionCMS v4 locally in no time. It provides you with everything  without requiring you to install PHP, Apache, or any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!

Fusionbox runs on any Windows, Mac, or Linux system, and includes the Apache web server, PHP 5.3, MySQL, and all of the other goodies you need to develop amazing v4 projects.

## Included Software

- CentOS 6
- PHP 5.3
 - GD
 - PDO
 - mbstring
 - Soap
 - xml
- MySQL

## First Steps
Before launching your Fusionbox environment, you must install [VirtualBox 5.x]() as well as [Vagrant](). Both of these software packages provide easy-to-use visual installers for all popular operating systems.

### Installing the Fusionbox Vagrant Box
Once VirtualBox and Vagrant have been installed, you should add the `fusion/box` box to your Vagrant installation using the following command in your terminal. It will take a few minutes to download the box, depending on your internet connection speed:

```
vagrant box add fusion/box
```

If this command fails, make sure your Vagrant installation is up to date.

### Installing Fusionbox
You may install Fusionbox by simply cloning the repository. Consider cloning the repository into a `Fusionbox` folder within your "home" directory, as Fusionbox will serve as the host to all of your v4 projects.

```
cd ~

git clone git@github.com:efellemedia/fusion-box.git
```

Once you have cloned the Fusionbox repository, run the `bash init.sh` command from the Fusionbox directory to create the `Fusionbox.yaml` configuration file. The `Fusionbox.yaml` file will be placed in the `~/.fusionbox` hidden directory:

```
bash init.sh
```

## Configuring Fusionbox

### Configuring Shared Folders
The `folders` property of the `Fusionbox.yaml` file lists all the folders you wish to share with your Fusionbox environment. As files within these folders are changed, they will be kept in sync between your local machine and the Fusionbox environment. You may configure as many shared folders as necessary:

```
folders:
    - map: ~/Code
      to: /var/www
```

### Configuring Apache Sites
Not familiar with Apache? No problem. The `sites` property allows you to easily map a "domain" to a folder on your Fusionbox environment. A sample site configuration is included in the `Fusionbox.yaml` file. Again, you may add as many sites to your Fusionbox environment as necessary. Fusionbox can serve as a convenient, virtualized environment for every v4 project you are working on (including the CMS itself):

```
sites:
    - map: hometikibar.dev
      to: /var/www/hometiki/trunk
```

If you change the `sites` property after provisioning the Fusionbox environment, you should re-run `vagrant reload --provision` to update the virtual host configuration on the virtual machine.

### The Hosts File
You must add the "domains" for your Apache sites to the `hosts` file on your machine. The `hosts` file will redirect requests for your Fusionbox sites in your Fusionbox machine. On Mac and Linux, this file is located at `/etc/hosts`. On Windows, it is located at `C:\Windows\System32\drivers\etc\hosts`. The lines you add to this file will look like the following:

```
192.168.10.80 hometikibar.dev
```

Make sure the IP address listed in the one set in your `~/.fusionbox/Fusionbox.yaml` file. Once you have added your domain to your `hosts` file, you can access the site via your web browser:

```
http://hometikibar.dev
```

## Launching the Fusionbox Environment
Once you have edited the `Fusionbox.yaml` file to your liking, run the `vagrant up` command from your Fusionbox diretory. Vagrant will boot the virtual machine and automatically configure your shared folders and Apache sites.

To destroy the machine, you may use the `vagrant destroy --force` command.

## Daily Usage

### Accessing Fusionbox Globally
Sometimes you may want to `vagrant up` your Fusionbox machine from anywhere on your filesystem. You can do this by adding a simple Bash alias to your Bash profile. This alias will allow you to run any Vagrant command from anywhere on your system and will automatically point that command to your Fusionbox installation:

```
alias fusionbox='function __fusionbox() { (cd ~/Fusionbox && vagrant $*); unset -f __fusionbox; }; __fusionbox'
```

Make sure to tweak the `~/Fusionbox` path in the alias to the location of your actual Fusionbox installation. Once the alias is installed, you may run commands like `fusionbox up` or `fusionbox ssh` from anywhere on your system.

### Connecting via SSH
You can SSH into your virtual machine by issuing the `vagrant ssh` terminal command from your Fusionbox directory.

But, since you will probably need to SSH into your Fusionbox machine frequently, consider adding the "alias" described above to your host machine to quickly SSH into the Fusionbox environment.

### Connecting to Databases
To connect to your MySQL database from your host machine via Navicat or Sequel Pro, you should connect to `127.0.0.1` and port `33060`. The username and password is `root` / `secret`.

> **Note:** You should only use this non-standard port when connecting to the databases from your host machine. You will use the default 3306 port in your v5 constants file since your v4 project is running *within* the virtual machine.

### Adding Additional Sites
Once your Fusionbox environment is provisioned and running, you may want to add additional Apache sites for your v4 projects. You can run as many v4 projects as you wish on a single Fusionbox environment. To add an additional site, simply add the site to your `~/.fusionbox/Fusionbox.yaml` file and then run the `vagrant provision` terminal command from your Fusionbox directory.

## Ports
By default, the following ports are forwarded to your Fusionbox environment:

- **SSH:** 2222 → Forwards to 22
- **HTTP:** 8000 → Forwards to 80
- **MySQL:** 33060 → Forwards to 3306

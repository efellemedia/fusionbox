# Fusion Box
Fusion Box is a preconfigured Vagrant Box that matches our Rackspace CentOS server setup, allowing the ability to easily run FusionCMS v4 locally in no time.

## First Steps
Before launching your Fusionbox environment, you must install [VirtualBox 5.x]() as well as [Vagrant](). Both of these software packages provide easy-to-use visual installers for all popular operating systems.

### Installing the Fusionbox Vagrant Box
Once VirtualBox and Vagrant have been installed, you should add the `fusion/box` box to your Vagrant installation using the following command in your terminal. It will take a few minutes to download the box, depending on your internet connection speed:

```
vagrant box add fusion/box
```

If this command fails, make sure your Vagrant installation is up to date.

### Installing Fusionbox
You may install Fusionbox by simply cloning the repository. Consider cloning the repository into a `Fusiobox` folder within your "home" directory, as Fusionbox will serve as the host to all of your v4 projects.

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
      to: /home/vagrant/Code
```

### Configuring Apache Sites
Not familiar with Apache? No problem. The `sites` property allows you to easily map a "domain" to a folder on your Fusionbox environment. A sample site configuration is included in the `Fusionbox.yaml` file. Again, you may add as many sites to your Fusionbox environment as necessary. Fusionbox can serve as a convenient, virtualized environment for every v4 project you are working on (including the CMS itself):

```
sites:
    - map: hometikibar.dev
      to: /home/vagrant/Code/hometiki/trunk
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


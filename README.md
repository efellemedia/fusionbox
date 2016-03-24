# Fusion Box
Fusion Box is a preconfigured Vagrant Box that matches our Rackspace CentOS server setup, allowing the ability to easily run FusionCMS v4 locally in no time.

## Get Started
1. Download and install [VirtualBox]().
2. Download and install [Vagrant]().
3. Clone the Fusion Box GitHub repository
4. Run `vagrant up`
5. Access your project at http://192.168.33.80

## Basic Vagrant Commands
These commands should be ran from your terminal within the location where you cloned Fusion Box.

### Start or Resume Your Server
```
vagrant up
```

### Pause Your Server
```
vagrant suspend
```

### Delete Your Server
```
vagrant destroy
```

### SSH Into Your Server
```
vagrant ssh
```

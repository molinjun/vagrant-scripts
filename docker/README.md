# Docker Engine
Set up a ubuntu host with docker engine installed.
- Linux Host: Ubuntu 22.04
- Docker Engine: 24.0.6

## Dependencies
Make sure you have already installed [Vagrant](https://developer.hashicorp.com/vagrant/downloads) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) on your workstation.

```bash
$ vagrant version
Installed Version: 2.3.7
Latest Version: 2.3.7

$ virtualbox --help
Oracle VM VirtualBox VM Selector v7.0.8
Copyright (C) 2005-2023 Oracle and/or its affiliates
```
## Quick Start
Clone this repo first.
```bash
$ git@github.com:molinjun/vagrant-scripts.git
$ cd vagrant-scripts
```
cd to specific folder and just `vagrant up` to setup up.
```bash
# Such as Docker
$ cd docker
$ vagrant up
```

## Access Host 
You can access the host with vagrant ssh.
```bash
$ vagrant ssh
```
If you want to ssh to host directly on your workstation, please add the ssh config into your workstation.
```bash
$ vagrant ssh-config >> ~/.ssh/config
$ ssh docker-server
```
## Access Docker API
We have already expose the docker api with `127.0.0.1:12375`.
```bash
$ curl 127.0.01:12375/images/json
```
## Clean up
If you want to clean up the environment, just `vagrant destroy`.
```bash
$ vagrant destroy -f
```


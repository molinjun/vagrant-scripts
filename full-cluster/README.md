# Full Server 
Set up a local server with full features. 
- Linux Host: Ubuntu 22.04
- Docker Engine: 24.0.6
- Prometheus & Grafana & Node-Exporter & CAdvisor & Nginx 

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
$ cd vagrant-scripts/full-cluster
```
cd to specific folder and just `vagrant up` to setup up.
```bash
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
$ ssh LOCAL-SERVER-01 
```
## Access Grafana Dashboard 
Add hosts in your `/etc/hosts` file.
```
10.12.0.101 grafana.dennis.io
```
Open `http://grafana.dennis.io` in your browser.
## Clean up
If you want to clean up the environment, just `vagrant destroy`.
```bash
$ vagrant destroy -f
```


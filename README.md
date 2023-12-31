# Vagrant Scripts
A collection of vagrant scripts to set up local development environments.


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
If you want to clean up the environment, just `vagrant destroy`.
```bash
$ vagrant destroy -f
```

## Table Content
- [x] [Docker](./docker/README.md)
- [x] [K8s Cluster](./k8s-cluster/README.md)
- [x] [Local Server](./full-server/README.md)
    - [x] Prometheus
    - [x] Grafana
    - [x] Node-Exporter
    - [x] CAdvisor
    - [x] Nginx
    - [ ] Zookeeper Cluster
    - [ ] Kafaka Cluster 
    - [ ] Redis Cluster


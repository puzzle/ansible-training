---
title: "Fedora/CentOS/RHEL Vagrant Setup"
type : "docs"
description: "Vagrant installation on Fedora/CentOS/RHEL Linux"
weight: 3
---

To participate in the lab you can use any 3 Linux servers
of your choice.  The labs are tailored for setup with
CentOS/RHEL hosts. Below are instructions on how to setup
the 3 required host with [Vagrant][vagrant] on Linux.
Follow the step by step guide to bootstrap the techlab
environment on your OS of choice.

{{% alert title="Warning" color="warning" %}}
The following passwords are not secure and intended only to
be used with local virtual machines not reachable from outside
of the virtualization host.
{{% /alert %}}

### Connectivity Details

With the Linux Vagrant setup provided the three local
Rockylinux virtual machines running under KVM have the
following IP addresses and credentials.

```yaml
control: 192.168.123.30
node1: 192.168.123.31
node2: 192.168.123.32

user: vagrant
password: vagrant
```

### CentOS/RHEL Based Systems

{{% alert title="Info" color="primary" %}}
On Linux we use the libvirt provider for vagrant.
Using Libvirt in user session is quite troublesome:
the vagrant vms fail to use the default NAT network, but in user session you can not create a new one.
This is why we have to use sudo a lot in the follwing setup.
{{% /alert %}}

#### Techlab Installation and Startup

```bash
# install libvirt and build-dependencies
sudo dnf install libvirt libvirt-daemon-kvm libvirt-devel gcc make rsync

# start libvirtd
sudo systemctl start libvirtd.service

# install vagrant
sudo dnf install vagrant

# Add your user to the libvirt group
sudo usermod -a -G libvirt ${USER}

# install vagrant plugin for libvirt
sudo vagrant plugin install vagrant-libvirt

# create working directory and download vagrant file
mkdir ansible-techlab
cd ansible-techlab
curl -o Vagrantfile \
  https://raw.githubusercontent.com/puzzle/ansible-techlab/master/Vagrantfile.rhel

# create libvirt network for vagrant and activate it
curl -o vagrant.xml \
  https://raw.githubusercontent.com/puzzle/ansible-techlab/master/vagrant.xml
virsh net-define vagrant.xml
virsh net-start vagrant
virsh net-autostart vagrant

# Tweaks needed for mounting local folder into VMs
sudo firewall-cmd --permanent --zone=libvirt --add-service=nfs3
sudo firewall-cmd --permanent --zone=libvirt --add-service=nfs
sudo firewall-cmd --permanent --zone=libvirt --add-service=mountd
sudo firewall-cmd --permanent --zone=libvirt --add-service=rpc-bind
sudo firewall-cmd --permanent --zone=libvirt --add-port=2049/tcp
sudo firewall-cmd --permanent --zone=libvirt --add-port=2049/udp
sudo firewall-cmd --reload

sudo sed -i 's/# udp=n/udp=y/g' /etc/nfs.conf
sudo systemctl restart nfs-server.service

# setup vm's
sudo vagrant up
```

#### Techlab Shutdown

```bash
cd ansible-techlab

# shutdown all vm's
sudo vagrant destroy -f
sudo rm -rf .vagrant/
```

[vagrant]: https://www.vagrantup.com/

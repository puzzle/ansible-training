---
title: "CentOS/RHEL Vagrant Setup"
icon: "ti-plug"
description: "Vagrant installation on CentOS/RHEL Linux"
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
CentOS virtual machines running under KVM have the
following IP addresses and credentials.

```yaml
control: 192.168.122.30
node1: 192.168.122.31
node2: 192.168.122.32

user: vagrant
password: vagrant
```

### CentOS/RHEL Based Systems

{{% alert title="Info" color="primary" %}}
RHEL and CentOS ship per default with Vagrant.
Depending on the version and age of the distribution
Vagrant may not include support for CentOS 8 and fails
during the initial setup. As such the RPM package
from HashiCorp the vendor of Vagrant is utilized to
ensure a frictionless lab experience.
{{% /alert %}}

#### Techlab Installation and Startup

```bash
# install libvirt and build-dependencies
sudo yum install libvirt libvirt-daemon-kvm libvirt-devel gcc make rsync

# start libvirtd
sudo systemctl start libvirtd.service

# install vagrant from hashicorp
curl --location -o /var/tmp/vagrant_2.2.7_x86_64.rpm \
  https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.rpm
sudo yum localinstall /var/tmp/vagrant_2.2.7_x86_64.rpm

# Add your user to the libvirt group
sudo usermod -a -G libvirt ${USER}

# install vagrant plugin for libvirt
vagrant plugin install vagrant-libvirt

# create working directory and download vagrant file
mkdir ansible-techlab
cd ansible-techlab
curl -o Vagrantfile \
  https://raw.githubusercontent.com/puzzle/ansible-techlab/master/Vagrantfile

# setup vm's
vagrant up
```

#### Techlab Shutdown

```bash
cd ansible-techlab

# shutdown all vm's
vagrant destroy -f
```

[vagrant]: https://www.vagrantup.com/

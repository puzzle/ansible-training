---
title: "Debian/Ubuntu Vagrant Setup"
icon: "ti-plug"
description: "Vagrant installation on Debian/Ubuntu Linux"
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

### Debian/Ubuntu Based Systems

{{% alert title="Info" color="primary" %}}
Debian and Ubuntu ship per default with Vagrant.
Depending on the version and age of the distribution
Vagrant may not include support for CentOS 8 and fails
during the initial setup. As such the Debian package
from HashiCorp the vendor of Vagrant is utilized to
ensure a frictionless lab experience.
{{% /alert %}}

#### Techlab Installation and Startup

```bash
# install libvirt and dependencies
sudo apt install libvirt-daemon libvirt-clients libvirt-dev

# install vagrant from hashicorp
curl --location -o /var/tmp/vagrant_2.2.7_x86_64.deb \
  https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.deb
sudo dpkg -i /var/tmp/vagrant_2.2.7_x86_64.deb

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

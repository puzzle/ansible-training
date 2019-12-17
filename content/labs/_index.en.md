---
title: "Labs"
icon: "ti-panel"
description: "Ansible Techlabs"
type : "pages"
weight: 2
---

### Puzzle Techlab Setup

We assume that each user has three virtual machines available:

- a control host
- two nodes called `node1` and `node2`

{{% notice note %}}
The cloud-based lab infrastructure is provided if you are following a Puzzle-guided Techlab.  
{{% /notice %}}

#### Local Vagrant Setup (optional)

You can do the labs with any Linux servers you'd like.

An easy solution would be to use [Vagrant](https://www.vagrantup.com/).

With the Vagrant setup provided with this lab you can use three local CentOS virtual machines using KVM.
An example Vagrantfile can be found here: [GitHub: Ansible Techlab - Vagrantfile](https://raw.githubusercontent.com/puzzle/ansible-techlab/master/Vagrantfile)

{{% notice warning %}}
The following passwords are not secure and intended only to be used with local virtual machines not reachable from outside of the virtualization host.
{{% /notice %}}

```
control 192.168.122.50
node1 192.168.122.51
node2 192.168.122.52

user: vagrant
password: vagrant
```
With Vagrant you can create those vm's on your local machine:

```bash
# Install vagrant on CentOS/RHEL
yum install vagrant

# Install vagrant on Debian/Ubuntu
apt install vagrant

# install libvirt provider
vagrant plugin install vagrant-libvirt

# setup vm's
vagrant up

# remove all vm's
vagrant destroy -f
```
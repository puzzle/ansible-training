---
title: "Windows Vagrant Setup"
icon: "ti-plug"
description: "Vagrant installation on Windows"
weight: 3
---

To participate in the lab you can use any 3 Linux servers
of your choice.  The labs are tailored for setup with
CentOS/RHEL hosts. Below are instructions on how to setup
the 3 required host with Vagrant on Windows. Follow the step
by step guide to bootstrap the techlab environment on your
OS of choice.

{{% alert title="Warning" color="warning" %}}
The following passwords are not secure and intended only to
be used with local virtual machines not reachable from outside
of the virtualization host.
{{% /alert %}}


### Prerequisites

* VirtualBox 6 and higher requires 64-bit Windows.


### Connectivity Details

With the Windows Vagrant setup provided the three local
CentOS virtual machines running under [VirtualBox][virtualbox]
have the following IP addresses and credentials.

```yaml
control: 192.168.122.30
node1: 192.168.122.31
node2: 192.168.122.32

user: vagrant
password: vagrant
```

On Windows ensure VirtualBox and Vagrant are installed.
The easiest way is to use [Chocolatey][chocolatey] to install
both of them.

In an **administrative powershell console** execute the following
commands:

```bash
# install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# installl VirtualBox and Vagrant
choco install virtualbox vagrant

```

Open a new PowerShell console with your login account privileges
and execute the following commands.

```bash
# create directory and download Vagrantfile
mkdir ansible-techlab
cd ansible-techlab
iwr -OutFile Vagrantfile https://raw.githubusercontent.com/puzzle/ansible-techlab/master/Vagrantfile

# setup vm's
vagrant up
```

#### Techlab Shutdown

```bash
cd ansible-techlab

# shutdown all vm's
vagrant destroy -f
```
[virtualbox]: https://www.virtualbox.org/
[chocolatey]: https://chocolatey.org/

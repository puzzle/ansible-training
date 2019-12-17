---
title: "3.0 - Setup and AdHoc Commands"
weight: 30
---

In this lab we’ll continue with our environment setup from [Lab 1](../lab-01) and learn how to run ad hoc commands.

### Task 1

  - Ping all nodes in the inventory file using the ping module

{{% notice tip %}}
You’ve used the `ping` module in a previous lab.
{{% /notice %}}

### Task 2

  - Gather all facts from the nodes.
  - Only gather the fact `ansible_default_ipv4` from all hosts.

### Task 3

  - Search through the online documentation for special (magical) variables.
  - Which special variable you could use to set the `hostname` on all the servers using the information in the `inventory` file?

### Task 4

  - Try to find an appropriate ansible module to complete Task 3. Find out what parameters the module accepts.
  - This module will try make changes to the `/etc/hostname` file. What options should you use with the `ansible` command for it to work?

### Task 5

  - Set the hostname on all nodes using the inventory and an ansible ad-hoc command.
  - Check on all nodes if the `hostname` has been changed.

### Task 6

Complete the next steps using ansible ad hoc commands:

  - Install `httpd` on the nodes in group `web`
  - Start `httpd` on the remote server and configure it to always start on boot.
  - Revert the changes made by the ad hoc commands again.

### Task 7

Complete the next steps using ansible ad hoc commands:

  - Create a file `/home/ansible/testfile.txt` on node2.
  - Paste some custom text into the file using the `copy` module.
  - Remove the file with an ad hoc command.

## Solutions

{{% collapse solution-1 "Solution 1" %}}
```bash
$ ansible all -i hosts -m ping
5.102.146.128 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
...
...
```
{{% /collapse %}}

{{% collapse solution-2 "Solution 2" %}}
```bash
$ ansible all -i hosts -m setup # (a lot of green output should be printed)
$ ansible all -i hosts -m setup -a "filter=ansible_default_ipv4"
5.102.146.204 | SUCCESS => {
    "ansible_facts": {
        "ansible_default_ipv4": {
            "address": "5.102.146.204",
            "alias": "eth0",
            "broadcast": "5.102.146.255",
            "gateway": "5.102.146.1",
            "interface": "eth0",
            "macaddress": "5a:42:05:66:92:cc",
            "mtu": 1500,
            "netmask": "255.255.255.0",
            "network": "5.102.146.0",
            "type": "ether"
        },
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false
}
...
...
```
{{% /collapse %}}

{{% collapse solution-3 "Solution 3" %}}
  - See Ansible docs for special variables: <https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html>
  - `inventory_hostname` can be set to the hostname on the servers.
{{% /collapse %}}

{{% collapse solution-4 "Solution 4" %}}

```bash
$ ansible-doc -l | grep hostname # or see webpage
bigip_hostname                                         Manage the hostname of a BIG-IP
hostname                                               Manage hostname
win_hostname                                           Manages local Windows computer name

$ ansible-doc -s hostname
- name: Manage hostname
  hostname:
      name:                  # (required) Name of the host
```
  - We will need root privileges and therefore we have to use the become option `-b`
{{% /collapse %}}

{{% collapse solution-5 "Solution 5" %}}
```bash
$ ansible all -i hosts -b -m hostname -a "name={{ inventory_hostname }}"
$ ansible all -i hosts -b -a "cat /etc/hostname"
``` 
{{% /collapse %}}
    

{{% collapse solution-6 "Solution 6" %}}
```bash
$ ansible web -i hosts -b -m yum -a "name=httpd state=installed"
$ ansible web -i hosts -b -m service -a "name=httpd state=started enabled=yes"
``` 

Reverting the changes made on the remote hosts:

```bash
$ ansible web -i hosts -b -m service -a "name=httpd state=stopped enabled=no"
$ ansible web -i hosts -b -m yum -a "name=httpd state=absent"
```
{{% /collapse %}}

{{% collapse solution-7 "Solution 7" %}}
```bash
$ ansible node2 -i hosts -b -m file -a "path=/home/ansible/testfile.txt state=touch"
$ ansible node2 -i hosts -b -m copy -a "dest=/home/ansible/testfile.txt content='SOME RANDOM TEXT'"
$ ansible node2 -i hosts -b -m file -a "path=/home/ansible/testfile.txt state=absent"
```
{{% /collapse %}}
---
title: "3. Setup and Ad Hoc Commands"
weight: 30
sectionnumber: 3
---

In this lab we’ll continue with our environment setup from [Chapter 1](../01) and learn how to run ad hoc commands.

### Task 1

* Ping all nodes in the inventory file using the `ansible.builtin.ping` module.

{{% alert title="Tip" color="info" %}}
You’ve used the `ansible.builtin.ping` module in a previous lab.
{{% /alert %}}

{{% details title="Solution Task 1" %}}
```bash
$ ansible all -i hosts -m ansible.builtin.ping
5.102.146.128 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}
...
...
```
{{% /details %}}

### Task 2

* Gather all facts from the nodes.
* Only gather the fact `ansible_default_ipv4` from all hosts.

{{% details title="Solution Task 2" %}}
```bash
$ ansible all -i hosts -m ansible.builtin.setup # (a lot of green output should be printed)
$ ansible all -i hosts -m ansible.builtin.setup -a "filter=ansible_default_ipv4"
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
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false
}
...
...
```
{{% /details %}}

### Task 3

* Search through the online documentation for special (magical) variables.
* Which special variable could you use to set the `hostname` on each of the servers using
the information in the `inventory` file?

{{% details title="Solution Task 3" %}}

* See Ansible docs for special variables: [Special Variables](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html)
* `inventory_hostname` contains the name of the managed host from the inventory file and can be used
to set the hostname on the servers.

{{% /details %}}

### Task 4

* Try to find an appropriate Ansible module to complete Task 3. Find out what parameters the module accepts.
* This module will try to make changes to the `/etc/hostname` file.
What options should you use with the `ansible` command to make that work?

{{% details title="Solution Task 4" %}}

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

* We will need root privileges, and therefore we have to use the become option `-b`

{{% /details %}}

### Task 5

* Set the hostname on all nodes using the inventory and an ansible ad hoc command.
* Check on all nodes if the hostname has been changed.

{{% details title="Solution Task 5" %}}
```bash
ansible all -i hosts -b -m ansible.builtin.hostname -a "name={{ inventory_hostname }}"
ansible all -i hosts -a "cat /etc/hostname"
```
{{% /details %}}

### Task 6

Complete the next steps using Ansible ad hoc commands:

* Install `httpd` on the nodes in group `web`
* Start `httpd` on the remote server and configure it to always start on boot.
* Revert the changes made by the ad hoc commands again.

{{% details title="Solution Task 6" %}}
```bash
ansible web -i hosts -b -m ansible.builtin.dnf -a "name=httpd state=installed"
ansible web -i hosts -b -m ansible.builtin.systemd_service -a "name=httpd state=started enabled=true"
```

Reverting the changes made on the remote hosts:

```bash
ansible web -i hosts -b -m systemd_service -a "name=httpd state=stopped enabled=false"
ansible web -i hosts -b -m ansible.builtin.dnf -a "name=httpd state=absent"
```
{{% /details %}}

### Task 7

Complete the next steps using ansible ad hoc commands:

* Create a file `/home/ansible/testfile.txt` on node2.
* Paste some custom text into the file using the `copy` module.
* Remove the file with an ad hoc command.

{{% details title="Solution Task 7" %}}
Possible solution 1:

```bash
ansible node2 -i hosts -m file -a "path=/home/ansible/testfile.txt state=touch"
ansible node2 -i hosts -m copy -a "dest=/home/ansible/testfile.txt content='SOME RANDOM TEXT'"
ansible node2 -i hosts -m file -a "path=/home/ansible/testfile.txt state=absent"
```

Possible solution 2:
The copy module can create the file directly

```bash
ansible node2 -i hosts -m copy -a "dest=/home/ansible/testfile.txt content='SOME RANDOM TEXT'"
ansible node2 -i hosts -m file -a "path=/home/ansible/testfile.txt state=absent"
```
{{% /details %}}

### All done?

* [Puzzle Ansible Blog](https://www.puzzle.ch/blog?terms=eyJ0ZWNobm9sb2d5IjpbMzg3N119)
* [Ansible Meetup Bern](https://www.meetup.com/Ansible-Bern/)

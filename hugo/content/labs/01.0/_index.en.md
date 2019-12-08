---
title: "1.0 - Setting up Ansible"
date: 2019-11-29T11:02:05+06:00
weight: 10
---

During this lab you will configure ansible. You will be able to use ansible on the controller-node and run your first commands on the ansible-nodes.

You have the IPs of the controller host and managemeble nodes (given by your instructor). The controller host is where you execute Ansible from and the nodes represent the machines you like to manage. (We will do some configurations on the controller as well.)

To make it easier for inexperienced users we installed on the controller an editor and terminal accessible with your browser. You can then connect to the nodes from there.

## Connect to your control host

### Webbrowser

Connect to your control host by pasting the DNS name into your webbrowser

    https://<dnsname>

Login using the following username and password:

    username: ansible
    password: << web password >>

After a successful login you should see an editor similar to *visual
studio code* in your browser. In the navigation bar you can open
"Terminal" or press `ctrl-shift-^` to open a terminal. Do this now and
then continue with the installation of Ansible.

### SSH

You can access the nodes using ssh as well.
Use your favourite ssh-client to connect to the ip of your control host as user "ansible".

### Task 1

- Install all packages needed to use ansible on the controller.

{{% notice tip %}}
  Use `sudo` to elevate your privilege to that of `root`. Be sure to only use root priviledges for installing the packages, you should do the rest of the lab as user anisble.
{{% /notice %}}

- Test if you can connect to the nodes from your controller using SSH. Use their public IPs.

- Make sure python is installed on your nodes before continuing with the lab.

### Task 2

- Create a SSH-keypair for the `ansible` user on the `controller`.

- Enable SSH-key login for the `ansible` user on all nodes and the
    controller by distributing the SSH-public key.

- Test the login on the nodes.

### Task 3

- Create an inventory file named `hosts` in your working directory with your public IPs:

```
[tower]
controller ansible_host=<your-controller-ip>
    
[web]
node1 ansible_host=<your-node1-ip>
    
[db]
node2 ansible_host=<your-node2-ip>
```
{{% notice tip %}}
Instead of copying the ssh-id to the controller itself you could set "ansible_connection=local" in the inventory file for host "controller". Then ansible would not use ssh to connect to the controller, but use the "local" transport mechanism.
{{% /notice %}}

- Check if ansible is ready using the `ping` module to ping all hosts in your inventory

### Task 4

1. Configure the `ansible` user to have root privilege on all hosts in your inventory file.
   Also enable login without a password for this user.

2. Test the functionality by running `sudo -v` as user `ansible` on all nodes.


## Solutions

{{% collapse solution-1 "Solution 1" %}}
Installing ansible with root privileges:

    # yum -y install ansible

Opening a SSH connection:

    $ ssh -l ansible <node-ip>

  - Enter "yes" when prompted if your want to continue connecting

  - Copy paste your SSH-password you received from your instructor when
    prompted and hit return

On the nodes:

    $ which python # (or which python3)
    /usr/bin/python

{{% /collapse %}}

{{% collapse solution-2 "Solution 2" %}}

    $ ssh-keygen #(no passphrase, just hit enter until the end)
    $ ssh-copy-id <node-ip>

Follow the prompt and enter the `ansible` user password you received
from your instructor:

{{% notice note %}}
  Don’t forget your controller and the second node.
{{% /notice %}}

    usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/ansible/.ssh/id_rsa.pub"
    The authenticity of host '5.102.146.128 (5.102.146.128)' can't be established.
    ECDSA key fingerprint is SHA256:5PmNPnSzE2IS309kJ8fAKrAjk0/NZT91qC4zQo0Vwiw.
    ECDSA key fingerprint is MD5:43:5f:9c:e1:ad:b5:76:a1:fa:5d:09:9c:be:5d:c2:7e.
    Are you sure you want to continue connecting (yes/no)? yes
    /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
    /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
    ansible@5.102.146.128's password:
    
    Number of key(s) added: 1
    
    Now try logging into the machine, with:   "ssh '5.102.146.128'"
    and check to make sure that only the key(s) you wanted were added.

Test it by running the ssh command executed on that node:

    $ ssh <node-ip> hostname
    [yourusernamehere]-node1

{{% /collapse %}}

{{% collapse solution-3 "Solution 3" %}}

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

{{% /collapse %}}


{{% collapse solution-4 "Solution 4" %}}

In the file `/etc/sudoers` (On CentOS/RHEL), theres already a config entry for the wheel group that is similar to the one we need for our ansible user.
```
$ ssh -l ansible <node-ip>
$ sudo -i
# grep wheel /etc/sudoers
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL
# %wheel        ALL=(ALL)       NOPASSWD: ALL
```
Add a similar line for user ansible to the sudoers file: 
``` 
# echo 'ansible ALL=(ALL)   NOPASSWD: ALL' >> /etc/sudoers
```

Check if `ansible` user has root privileges:
```
    sudo -v
```
{{% notice note %}} 
  Note that you cannot do this using ansible yet. The reason being you
  need root privileges and we are just setting this up right now.
{{% /notice %}}

{{% /collapse %}}
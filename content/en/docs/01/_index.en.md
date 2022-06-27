---
title: 1. Setting up Ansible
weight: 1
sectionnumber: 1
---

During this lab you will configure Ansible. You will be able to use Ansible on the controller node and run your first commands on the ansible nodes (managed nodes).

You have the IP addresses of the controller node and managed nodes (given by your instructor). The controller node is where you execute Ansible from and the other nodes represent the machines you like to manage. We will do some configurations on the controller as well.

To make it easier for inexperienced users, we installed an editor and terminal on the controller, accessible from your browser.
You can then connect to the nodes from there.

Unless otherwise specified, your working directory for all labs should be `/home/ansible/techlab/`.

Some good advice:

* Always read all the tasks first. Some tasks might not be clear until you get the whole scope of the lab.
* Open a terminal that you use only for `ansible-doc` (see later) and another terminal that you use for ad hoc commands (see later) to check the result of your plays.
* When possible use copy & paste for filenames and file content. You'll make fewer mistakes.

## Connect to your controller host

### Web Browser

Connect to your controller host by pasting the DNS name into your web browser

```bash
https://<dnsname>
```

Login using the following username and password:

```
username: ansible
password: << web password >>
```

After a successful login you should see an editor similar to *visual studio code* in your browser. In the navigation bar you can open "Terminal" or press `ctrl-shift-^` to open a terminal. Do this now and then continue with the installation of Ansible.

### SSH

You can access the nodes using SSH as well. Use your favourite SSH client to connect to the IP address of your controller host as user `ansible`.

### Task 1

* Install all packages needed to use Ansible on the controller host.

{{% alert title="Tip" color="info" %}}
  Use `sudo` to elevate your privilege to those of `root`. Be sure to only use root priviledges for installing the packages, you should perform the rest of the lab as user `ansible`.
{{% /alert %}}

* Test if you can connect to the nodes from your controller using SSH. Use their public IPs.
* Make sure python is installed on your nodes before continuing with the lab.

{{% details title="Solution Task 1" %}}
Installing Ansible with root privileges (on controller host):

```bash
sudo dnf -y install ansible
```

* If `dnf` does not find the `ansible` package you might need to
  install `epel-release.noarch` to enable the EPEL repository.

Opening a SSH connection:
```bash
ssh -l ansible <node-ip>
```

* Enter "yes" when prompted if you want to continue connecting
* Insert your SSH-password you received from your instructor when prompted and hit return

On the nodes:
```bash
which python3 # (or which python)
/usr/bin/python3
```

If `which` does not find `python3` or `python`:
```bash
sudo dnf -y install python3 # (or python)
```

{{% /details %}}

### Task 2

* Create a SSH key pair for the user `ansible` on the controller host.
* Don't set a password for the private key! Just hit ENTER at the prompt.
* Enable SSH key-based login for the user `ansible` on all nodes and the controller by distributing the SSH-public key.
* Test the login on the nodes.

{{% details title="Solution Task 2" %}}
```bash
ssh-keygen #(no passphrase, just hit enter until the end)
ssh-copy-id <node-ip>
```

Follow the prompt and enter the `ansible` user password you received from your instructor:

{{% alert title="Note" color="primary" %}}
  Don’t forget your controller and the second node.
{{% /alert %}}

```bash
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
```

Test it by running the SSH command executed on that node:
```bash
ssh <node-ip> hostname
[yourusernamehere]-node1
```
{{% /details %}}

### Task 3

* Create an inventory file named `hosts` in your working directory with your public IPs:

```bash
[controller]
control0 ansible_host=<your-controller-ip>

[web]
node1 ansible_host=<your-node1-ip>

[db]
node2 ansible_host=<your-node2-ip>
```

{{% alert title="Tip" color="info" %}}
Instead of copying the ssh-id to the controller itself you could set `ansible_connection=local` in the inventory file for host `control0`. Then Ansible would not use SSH to connect to the controller, but use the "local" transport mechanism.
If you have a valid `/etc/hosts` file containing information about lab hosts, you can omit the `ansible_host=<ip>` parts in the inventory file.
{{% /alert %}}

* Check if ansible is ready using the `ping` module to ping all hosts in your inventory

{{% details title="Solution Task 3" %}}
```bash
cd techlab
vim hosts # (copy & paste inventory data)
ansible all -i hosts -m ping
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

### Task 4

{{% alert title="Note" color="primary" %}}
If you are using the lab servers provided by your teacher, the sudoers configuration is already done. Anyways have a look at it to see how stuff works.
{{% /alert %}}

* Configure the `ansible` user to have root privilege on all hosts in your inventory file. Also enable login without a password for this user.
* Test the functionality by running `sudo -v` as user `ansible` on all nodes.

{{% details title="Solution Task 4" %}}

In the file `/etc/sudoers` (On CentOS/RHEL), there's already a config entry for the wheel group that is similar to the one we need for our ansible user.
```bash
ssh -l ansible <node-ip>
sudo -i
grep wheel /etc/sudoers
Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL
%wheel        ALL=(ALL)       NOPASSWD: ALL # <-- this line!
```

Add a similar line for user ansible to the `sudoers` file:

```bash
echo 'ansible ALL=(ALL)   NOPASSWD: ALL' >> /etc/sudoers
```

Alternatively you can put that into a separate file:

```bash
echo 'ansible ALL=(ALL)   NOPASSWD: ALL' >> /etc/sudoers.d/ansible
```

Check if `ansible` user has root privileges:

```bash
sudo -v
```

{{% alert title="Note" color="primary" %}}
  Note that you cannot do this using Ansible yet. The reason being you
  need root privileges and we are just setting up those right now.
{{% /alert %}}

{{% /details %}}

### Task 5

* extend the inventory with a group `nodes` that has the groups `web` and `db` as members
  {{% alert title="Tip" color="info" %}}
  Take a look at [Ansible Docs - Inventory Intro](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) for how to use the `:children` suffix in INI file inventories.
  {{% /alert %}}
* ping all servers in the group `nodes`

{{% details title="Solution Task 5" %}}
Add `[nodes:children]` to inventory file:
```bash
cat hosts
[controller]
control0 ansible_host=192.168.122.30

[web]
node1 ansible_host=192.168.122.31

[db]
node2 ansible_host=192.168.122.32

[nodes:children]
web
db
```
Ping `nodes`:

```bash
# Note: hosts is the inventory file you created, either "-i hosts" or "-i ./hosts" works.
ansible -i hosts nodes -m ping
...
```
{{% alert title="Tip" color="info" %}}
Use `ansible -i hosts <group> --list-hosts` to verify group membership in Ansible inventories:
```bash
ansible -i hosts web  --list-hosts
  hosts (1):
    node1
ansible -i hosts db  --list-hosts
  hosts (1):
    node2
ansible -i hosts nodes  --list-hosts
  hosts (2):
    node1
    node2
ansible -i hosts all  --list-hosts
  hosts (3):
    control0
    node1
    node2
```
{{% /alert %}}
{{% /details %}}

### All done?

* Have a look at [The Bullhorn newsletter](https://github.com/ansible/community/wiki/News#the-bullhorn)
* See what inspired the creators of Ansible: [Rocannon's World](https://www.youtube.com/watch?v=X8F3r4_EkW8)
* Ansible [Configuration File](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html)
* Easteregg: [Cowsay not found!](https://docs.ansible.com/ansible/latest/notfound)

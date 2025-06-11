---
title: 4. Ansible Playbooks - Basics
weight: 40
sectionnumber: 4
---

In this lab we’ll get used to writing and running Ansible playbooks.

### Task 1

Create a playbook `webserver.yml` which does the following:

* Install `httpd` on the nodes in the `web` group.
* Start `httpd` and ensure the service starts on boot. Ensure that the Linux firewall is also started and enabled.
* Ensure port 80 is open on the firewall.

{{% alert title="Tip" color="info" %}}
Check what the options `immediate` and `permanent` of the `ansible.posix.firewalld` module mean and do.
{{% /alert %}}

* Run the playbook. After completion, test if the `httpd.service` is running and enabled on `node1`.

{{% details title="Solution Task 1" %}}

Below is a possible solution for your playbook:

```yaml
---
- hosts: web
  become: true
  tasks:
    - name: install httpd
      ansible.builtin.dnf:
        name: httpd
        state: installed
    - name: start and enable httpd
      ansible.builtin.systemd_service:
        name: httpd
        state: started
        enabled: true
    - name: start and enable firewalld
      ansible.builtin.systemd_service:
        name: firewalld
        state: started
        enabled: true
    - name: open firewall for http
      ansible.posix.firewalld:
        service: http
        state: enabled
        permanent: true
        immediate: true
```

Run your playbook with:

```bash
ansible-playbook -i hosts webserver.yml
```

Check `httpd.service` on group `web`:

```bash
 ansible -i hosts web -b -a "systemctl status httpd"
```

{{% alert title="Hint" color="info" %}}
 The ports for SSH, DHCP and cockpit are opened by default in the firewalld.
 It is best, especially for documentation, to open the ports explicitly in a basic settings file.
{{% /alert %}}

{{% /details %}}

### Task 2

* Create a folder `inventory` and move your inventory `hosts` there.
* Configure Ansible to use `/home/ansible/techlab/inventory/hosts` as the default inventory.
Do this using a configuration file in the `/home/ansible/techlab/` directory.
* Run the playbook again without using the `-i` flag to see if the configuration works.

{{% details title="Solution Task 2" %}}

Create a file `ansible.cfg` in your directory:

```bash
mkdir /home/ansible/techlab/inventory
mv /home/ansible/techlab/hosts /home/ansible/techlab/inventory/
ansible-config init --disabled > ansible.cfg
```

Edit your `ansible.cfg` file. Uncomment and edit the `inventory` entry to use your file:

```
[defaults]
# some basic default values...
inventory      = /home/ansible/techlab/inventory/hosts # <-- edit this line
#library        = /usr/share/my_modules/
```

```bash
$ ansible-playbook webserver.yml
PLAY [web] ***********************************************************************

TASK [Gathering Facts] ***********************************************************
ok: [node1]

TASK [install httpd] *************************************************************
ok: [node1]
...
```
{{% /details %}}

### Task 3

* Intentionally add errors to your playbook and have a look at the output.
You should get a feeling for Ansible's error messages:
  * Add a wrong indentation. Remember that this is a common mistake!
  * Use a tab character for indentation. Some editors do that automatically.
  * Add a wrong parameter name.
  * Remove the mistakes.

{{% details title="Solution Task 3" %}}

Wrong indentation:

```yaml
---
- hosts: web
  become: true
  tasks:
    - name: install httpd
      ansible.builtin.dnf:
      name: httpd        # <-- wrong indentation
      state: installed   # <-- wrong indentation
```

Wrong parameter name:

```yaml
---
- hosts: web
  become: true
  tasks:
    - name: install httpd
      ansible.builtin.dnf:
        name: httpd
        state: installed
        enabled: true     # <-- doesn't exist for dnf module
```

{{% /details %}}

### Task 4

* Create a playbook `tempfolder.yml`
* The playbook `tempfolder.yml` should create a temporary folder `/var/tempfolder` on all servers
except those in the group `db`.

{{% alert title="Tip" color="info" %}}
 Take a look at the user guide and find out how to use more complex inventory patterns.
 See [Ansible Docs - User Guide](https://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html#common-patterns)
{{% /alert %}}

* The folder has to have the sticky bit set, so that only the owner (set owner/group to `ansible`) of the
content (or root) can delete the files.
* Run the playbook and then check if the sticky bit was set using an ad hoc command.

{{% details title="Solution Task 4" %}}
```bash
$ cat tempfolder.yml
---
- hosts: all:!db
  become: true
  tasks:
    - name: create temp folder with sticky bit set
      ansible.builtin.file:
        dest: /var/tempfolder
        mode: "01755"
        owner: ansible
        group: ansible
        state: directory

$ ansible-playbook tempfolder.yml
$ ansible web,controller -b -a "ls -ld /var/tempfolder"
```
{{% alert title="Note" color="primary" %}}
 `ansible-doc file` doesn't provide any information about setting special permissions like sticky bit
 (`man chmod` will help you though). Remember to use a leading 0 before the actual permissions.
{{% /alert %}}

{{% /details %}}

### All done?

* [Ansible 101 by Jeff Geerling](https://www.youtube.com/watch?v=goclfp6a2IQ&list=PL2_OBreMn7FqZkvMYt6ATmgC0KAGGJNAN)

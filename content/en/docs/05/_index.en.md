---
title: 5. Ansible Roles - Basics
weight: 5
sectionnumber: 5
---

During this lab we’ll learn how to write and use Ansible roles.

### Task 1

* Create a directory `roles` in your techlab folder.
* Configure your ansible environment to use the `roles` folder as an additional resource for roles.

{{% details title="Solution Task 1" %}}
```bash
$ mkdir roles
$ grep roles_path ansible.cfg
roles_path    = /home/ansible/techlab/roles
```
{{% /details %}}

### Task 2

Write a role `httpd` in your new `roles` folder which does the
following:

* Install `httpd`, start its service and enable it to run on boot.
* Install `firewalld`, start its service and allow traffic for the services `http` and `https`.

{{% details title="Solution Task 2" %}}
```bash
$ cd roles/
$ ansible-galaxy init httpd

$ cat roles/httpd/tasks/main.yml
---
# tasks file for httpd
- name: install packages
  dnf:
    name:
      - httpd
      - firewalld
    state: installed
- name: start services
  service:
    name: "{{ item }}"
    state: started
    enabled: yes
  loop:
    - httpd
    - firewalld
- name: open firewall for http and https
  firewalld:
    service: "{{ item }}"
    state: enabled
    immediate: yes
    permanent: true
  loop:
    - http
    - https
```
{{% /details %}}

### Task 3

* Modify your playbook `webserver.yml` to use your new `httpd` role. It should be run on all hosts in the `web` group.
* Run your playbook and check if everything went as expected.

{{% details title="Solution Task 3" %}}
```bash
$ cat webserver.yml
---
- hosts: web
  become: true
  roles:
    - httpd

$ ansible-playbook webserver.yml
```
{{% /details %}}

### Task 4

* Create a new role called `base`. Its file `tasks/main.yml` should import the files `motd.yml` and `packages.yml`. (Create both files under `tasks/`).
* `motd.yml` should do the following: Use the variable `motd_content` to change the `/etc/motd` content to "This is a server\\n". Remember to move the template as well as the variable to a correct location in the `roles` folder.
* `packages.yml` should install the packages `firewalld`, `yum-utils`, `dos2unix`, `emacs` and `vim`
* Write a playbook `prod.yml` that applies the role `base` to all servers and the role `httpd` only to the group `web`.

{{% details title="Solution Task 4" %}}
```bash
$ cd roles/; ansible-galaxy init base;

$ cat roles/base/defaults/main.yml
---
# defaults file for base
motd_content: "This is a server\n"

$ ls roles/base/tasks/
main.yml      motd.yml      packages.yml

$ cat roles/base/tasks/motd.yml
---
- name: put motd template
  template:
    src: templates/motd.j2
    dest: /etc/motd

$ cat roles/base/tasks/packages.yml
---
- name: install packages
  dnf:
    name:
      - firewalld
      - yum-utils
      - dos2unix
      - emacs
      - vim
    state: installed

$ cat roles/base/tasks/main.yml
---
# tasks file for base
- name: set custom text
  include: motd.yml
  tags: motd
- name: install packages
  include: packages.yml
  tags: packages

$ cat prod.yml
---
- hosts: all
  become: true
  roles:
    - base

- hosts: web
  become: true
  roles:
    - httpd
```

{{% alert title="Note" color="primary" %}}
Take notice of the different content of `/etc/motd` on the control node!
{{% /alert %}}

{{% /details %}}

### Task 5

* Rewrite the `httpd` role to apply the `base` role each time it is used in a playbook. Use a dependency in the `meta/main.yml` file.
* Remove the play to run `base` role on all hosts in the `prod.yml` playbook. Run the playbook and see if role `base` was applied on hosts in the `web` group as well.

{{% details title="Solution Task 5" %}}

```bash
$ cat roles/httpd/meta/main.yml
---
dependencies:
  - base
$ cat prod.yml
---
- hosts: web
  become: true
  roles:
    - httpd

$ ansible-playbook prod.yml
```

{{% /details %}}

### All done?

* Have a look at the available [Playbook Keywords](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html)

---
title: "5.0 - Ansible Roles - Basics"
weight: 50
---

During this lab we’ll learn how to write and use Ansible roles.

### Task 1

- Create a directory `roles` in your techlab folder.
- Configure your ansible environment to use the `roles` folder as an additional resource for roles.

### Task 2

Write a role `httpd` in your new `roles` folder which does the
following:

- Install `httpd`, start its service and enable it to run on boot.
- Install `firewalld`, start its service and allow traffic for the services `http` and `https`.

### Task 3

- Modify your playbook `webserver.yml` to use your new `httpd` role. It should be run on all hosts in the `web` group.
- Run your playbook and check if everything went as expected.

### Task 4

- Create a new role called `base`. Its file `tasks/main.yml` should import the files `motd.yml` and `packages.yml`. (Create both files under `tasks/`).
- `motd.yml` should do the following: Use the variable `motd_content` to change the `/etc/motd` content to "This is a server\\n". Remember to move the template as well as the variable to a correct location in the `roles` folder.
- `packages.yml` should install the packages `firewalld`, `yum-utils`, `dos2unix`, `emacs` and `vim`
- Write a playbook `prod.yml` that applies the role `base` to all servers and the role `httpd` only to the group `web`

### Task 5

- Rewrite the `httpd` role to apply the `base` role each time it is used in a playbook. Use a dependency in the `meta/main.yml` file.
- Remove the play to run `base` role on all hosts in the `prod.yml` playbook. Run the playbook and see if role `base` was applied on hosts in the `web` group as well.

## Solutions

{{% collapse solution-1 "Solution 1" %}}
```bash
$ mkdir roles
$ grep roles_path ansible.cfg
roles_path    = /etc/ansible/roles:/usr/share/ansible/roles:/home/ansible/techlab/roles
```
{{% /collapse %}}

{{% collapse solution-2 "Solution 2" %}}
```bash
$ cd roles/
$ ansible-galaxy init httpd

$ cat roles/httpd/tasks/main.yml
---
# tasks file for httpd
- name: install packages
  yum:
    name:
      - httpd
      - firewalld
    state: installed
- name: start services
  service:
    name: "{{ item }}"
    state: started
    enabled: yes
  with_items:
    - httpd
    - firewalld
- name: open firewall for http and https
  firewalld:
    service: "{{ item }}"
    state: enabled
    immediate: yes
    permanent: true
  with_items:
    - http
    - https
```
{{% /collapse %}}

{{% collapse solution-3 "Solution 3" %}}
```bash
$ cat webserver.yml
---
- hosts: web
  become: yes
  roles:
    - httpd

$ ansible-playbook webserver.yml
```
{{% /collapse %}}

{{% collapse solution-4 "Solution 4" %}}
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
  yum:
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
  become: yes
  roles:
    - base

- hosts: web
  become: yes
  roles:
    - httpd
```

{{% notice note %}}
Take notice of the different content of `/etc/motd` on the control node!
{{% /notice %}}

{{% /collapse %}}

{{% collapse solution-5 "Solution 5" %}}

```bash
$ cat roles/httpd/meta/main.yml
---
dependencies:
  - base
$ cat prod.yml
---
- hosts: web
  become: yes
  roles:
    - httpd

$ ansible-playbook prod.yml
```

{{% /collapse %}}

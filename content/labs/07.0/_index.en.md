---
title: "7.0 - Ansible Galaxy and more"
weight: 70
---

In this lab we are going to use roles from galaxy and from other sources.

### Task 1
- Search the ansible-galaxy for a nginx role
- Install such a nginx role using `ansible-galaxy`
- Create a tar.gz file `nginx.tar.gz` with the content of the role using an Ansible ad hoc command

### Task 2
- Remove the nginx role using `ansible-galaxy`
- Create a file `requirements.yml` in the folder `/home/ansible/techlab/roles/`. The file should contain the information to install the role packed in `nginx.tar.gz` as `mynginx`
- Install the role by using an appropriate `ansible-galaxy` command and the `requirements.yml` file.
- Remove the role `mynginx` using `ansible-galaxy`
- Remove the file `nginx.tar.gz` and `roles/requirements.yml` by using an ad hoc command for each

### Task 3 (CentOS/RHEL only)
- Search your yum-repository for packages containing the string `roles`
- Install the package providing Ansible roles for system mangement
- See what files where installed with this package

### Task 4
- Search the installed files for an example to use the `rhel-system-roles.selinux` role
- use the example to create a playbook `selinux.yml` to set selinux mode to disabled on all servers
- run the playbook

{{% notice note %}}
You have to have a reasonable fresh version of ansible in order to get this working. On older systems you could get an errormessage containing strings like `template error while templating string: no test named 'version'`.
{{% /notice %}}

## Solutions
{{% collapse solution-1 "Solution 1" %}}
```bash
$ ansible-galaxy search nginx
$ ansible-galaxy install geerlingguy.nginx
$ ansible control -m archive -a "path=/home/ansible/techlab/roles/geerlingguy.nginx dest=/home/ansible/techlab/nginx.tar.gz format=bz2"
```
{{% /collapse %}}

{{% collapse solution-2 "Solution 2" %}}
```bash
$ ansible-galaxy remove geerlingguy.nginx

$ cat roles/requirements.yml 
---
- src: nginx.tar.gz
  name: mynginx
```
{{% notice note %}}
You can also install roles from url's and other archive-formats. Have a look at the documentation [Ansible Docs - Installing Roles](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles).
Note as well, that the order of the roles to be installed in the `requirements.yml` file could matter.
{{% /notice %}}

```bash
$ ansible-galaxy install -r roles/requirements.yml
---
- src: nginx.tar.gz
  name: mynginx

$ ansible-galaxy remove mynginx
$ ansible localhost -m file -a "dest=/home/ansible/techlab/nginx.tar.gz state=absent"
$ ansible localhost -m file -a "dest=/home/ansible/techlab/roles/requirements.yml state=absent"
```
{{% /collapse %}}

{{% collapse solution-3 "Solution 3" %}}
```bash
$ yum search roles
$ yum install rhel-system-roles
$ repoquery -l rhel-system-roles #<-- repoquery is provided by the package `yum-utils`
```
{{% /collapse %}}

{{% collapse solution-4 "Solution 4" %}}
```bash
$ repoquery -l rhel-system-roles | grep -i exa | grep selinux
$ cp /usr/share/doc/rhel-system-roles-1.0/selinux/example-selinux-playbook.yml selinux.yml
[ansible@control0 techlab]$ cat selinux.yml
---
- hosts: all
  become: true
  vars:
    selinux_policy: targeted
    #selinux_state: enforcing
    selinux_state: disabled
    selinux_booleans:
    #<-- more stuff here

$ ansible-playbook selinux.yml
```
{{% /collapse %}}
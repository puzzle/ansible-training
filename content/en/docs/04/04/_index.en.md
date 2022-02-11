---
title: 4.4 Ansible-Pull
weight: 44
sectionnumber: 4.4
---

In this lab we’ll have a short glimpse at how ansible-pull works.

### Task 1

* Search `docs.ansible.com` for information about the ansible-pull command.
* Look for a way to execute a playbook using ansible-pull
* Search for a example playbook

### Task 2

On node1:

* Install all needed packages to use ansible-pull
* Use an `ansible-pull` command that uses the resources in the folder `resources/ansible-pull/` of our github repository located at `https://github.com/puzzle/ansible-techlab`. This command should do the following:
* Apply the playbook `local.yml` located at the `resource/ansible-pull` folder and run it on all hosts in the inventory file `hosts`
* Show the content of `/etc/motd` and verify, that the file was copied using ansible-pull
* Also verify, that no content of the git repository was copied to the local folder.

{{% alert title="Tip" color="info" %}}
Note the following:

* If no playbook is specified, ansible-pull looks for a playbook `local.yml`.
* The location of files given as paratmeters to the ansibel-pull command ar always relative to the top level of the git repository.
* All information to run the ansible-pull command is taken from the git repository (playbook, inventory, MOTD-file to be copied). No local configuration is used!

{{% /alert %}}

### Task 3

It's a best practice to use cronjobs to trigger `ansible-pull` run at a regular basis. Do the following on node1:

* Create a cronjob `/etc/cron.d/ansible-pull`. This cronjob should run every minute as user ansible the ansible-pull command from Task 2.
* Now remove the existing `/etc/motd` file and use the command `watch` to show the content of `/etc/motd` every second. We want to observe that our cronjob runs the `ansible-pull` command again and restore the previously deleted MOTD-file

### Task 4

This task has nothing to do with `ansible-pull`, we just clean up the ansible-pull configurations. Create a playbook `revert_motd.yml` that runs on node1. It should:

* uninstall ansible
* remove the cronjob `/etc/cron.d/ansible-pull`
* empty the file `/etc/motd`

Run the playbook.


## Solutions

{{% details title="Task 1" %}}
[ansible-pull](https://docs.ansible.com/ansible/latest/cli/ansible-pull.html)
[Ansible-pull](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html#ansible-pull])
[GitHub ansible-examples](https://github.com/ansible/ansible-examples/blob/master/language_features/ansible_pull.yml)
{{% /details %}}

{{% details title="Task 2" %}}
```bash
sudo yum install -y ansible
/usr/bin/ansible-pull -U https://github.com/puzzle/ansible-techlab -i resources/ansible-pull/hosts resources/ansible-pull/local.yml
cat /etc/motd
ll #no file here...
```
{{% /details %}}

{{% details title="Task 3" %}}
```bash
$ sudo vim /etc/cron.d/ansible-pull #create the file with the content ->
$ cat /etc/cron.d/ansible-pull
* * * * * ansible /usr/bin/ansible-pull -U https://github.com/puzzle/ansible-techlab -i resources/ansible-pull/hosts resources/ansible-pull/local.yml
$ sudo rm -f /etc/motd; watch cat /etc/motd
```
{{% /details %}}

{{% details title="Task 4" %}}
```bash
$ cat revert_motd.yml
---
- hosts: node1
  become: yes
  tasks:
    - name: uninstall ansible
      yum:
        name: ansible
        state: absent
    - name: ensure cronjob not present
      file:
        path: /etc/cron.d/ansible-pull
        state: absent
    - name: ensure MOTD file empty
      copy:
        content: ""
        dest: /etc/motd

$ ansible-playbook revert_motd.yml
```
{{% /details %}}

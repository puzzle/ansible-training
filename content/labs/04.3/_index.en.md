---
title: "4.3 - Ansible Playbooks - Output"
weight: 43
---

In this lab we learn how to handle output of tasks.

### Task 1

- Write a playbook `output.yml` that uses the command module to find all config files of postfix. These files are located under `/etc/postfix/` and end with `.cf`. Targeted server is `node1`.
- Register the result to a variable called `output` by using the `register` keyword.
- Include a task using the debug module to print out all content of the variabl `output`. If unsure, consult the documentation about the debug module.

### Task 2
- Add another task using the debug module and print out the result of the search above. The difficulty here is to print *all* results and not just the first.

{{% notice tip %}}
Use an appropriate return value to show the output. Information about return values can be found here: <https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html>
{{% /notice %}}

- Now, loop over the results and create a backup file called <filename.cf>.bak for each file. Use the command module.

### Task 3 (Advanced)
- Now we enhance our play to only create the backup if no backup file is present. If one single file with an ending .bak is present, don't do any backup.
- Solve this task by searching for files ending with `.bak` and registering the result to a variable. Then do tasks only if certain conditions are met.

{{% notice tip %}}
Have a look at the documentation about conditionals: <https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html>
{{% /notice %}}

### Task 4 (Advanced)
- This task has to be solved without using the module `service`, `systemd` or similar but by using the `command` module.
- Ensure `httpd` is stopped by using an ansible ad hoc command.
- Write a play `servicehandler.yml` that installs `httpd`
- Start the service `httpd` with the command module.
- Start the service only if the service is not started. (The output of `systemctl status httpd` doesn't contains the string "Active: inactive (dead)")

{{% notice note %}}
`systemctl status` returns status `failed` when a service is not running. Therefore we use `ignore_errors: true` in the corresponding task to let Ansible continue anyways.
{{% /notice %}}

### Task 5 (Advanced)
- Rewrite the playbook `servicehandler.yml` and ensure that the `ignore_errors: true` line is removed. Instead set the state of the task to failed when and only when the output of `systemctl status httpd` contains the string "failed".

{{% notice note %}}
Have a look at the documentation about errorhandling: <https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html>
{{% /notice %}}

- Rerun your playbook and ensure it still runs fine.
- By using an ansible ad hoc command, place an invalid configuration file `/etc/httpd/conf/httpd.conf` for httpd and backup the file before. Use the copy module to do this in one task.
- Restart `httpd` by using an ansible ad hoc command. This should fail since the config file is not vaild.
- Rerun your playbook and ensure it fails. 

## Solutions

{{% collapse solution-1 "Solution 1" %}}
```bash
[ansible@control0 techlab]$ cat output.yml
---
- hosts: node1
  become: true
  tasks:
    - name: 
      command: "find /etc/postfix -type f -name *.cf"
      register: output
    - debug:
        var: output
```

{{% /collapse %}}

{{% collapse solution-2 "Solution 2" %}}

```bash
[ansible@control0 techlab]$ cat output.yml
---
- hosts: node1
  become: true
  tasks:
    - name:
      command: "find /etc/postfix -type f -name *.cf"
      register: output
    - debug:
        var: output.stdout_lines
    - name: create backup
      command: "cp {{ item }} {{ item }}.bak"
      with_items: "{{ output.stdout_lines  }}"
```
{{% /collapse %}}

{{% collapse solution-3 "Solution 3" %}}
```bash
[ansible@control0 techlab]$ cat output.yml 
---
- hosts: node1
  become: true
  tasks:
    - name:
      command: "find /etc/postfix -type f -name *.cf.bak"
      register: search
    - name: 
      command: "find /etc/postfix -type f -name *.cf"
      register: output
    - name: create backup only when no backupfile is present
      command: "cp {{ item }} {{ item }}.bak"
      with_items: "{{ output.stdout_lines  }}"
      when: search.stdout == '' #<- only do this task if the search for files ending with .bak is empty>
```
{{% /collapse %}}

{{% collapse solution-4 "Solution 4" %}}
```bash
[ansible@control0 techlab]$ ansible web -b -a "systemctl stop httpd"
[ansible@control0 techlab]$ cat servicehandler.yml 
---
- hosts: web
  become: yes
  tasks:
    - name: install httpd
      yum:
        name: httpd
        state: present
    - name: check state of service httpd
      command: 'systemctl status httpd'
      register: status
      ignore_errors: true
    - debug:
        var: status.stdout
    - name: start httpd
      command: 'systemctl start httpd'
      when: "'Active: active (running)' not in status.stdout"
[ansible@control0 techlab]$

```
{{% /collapse %}}

{{% collapse solution-5 "Solution 5" %}}
```bash
[ansible@control0 techlab]$ cat servicehandler.yml
---
- hosts: web
  become: yes
  tasks:
    - name: install httpd
      yum:
        name: httpd
        state: present
    - name: check state of service httpd
      command: 'systemctl status httpd'
      register: status
      failed_when: "'failed' in status.stdout"
    - debug:
        var: status.stdout
    - name: start httpd
      command: 'systemctl start httpd'
      when: "'Active: active (running)' not in status.stdout"
[ansible@control0 techlab]$ ansible web -b -m copy -a "content='bli bla blup' dest=/etc/httpd/conf/httpd.conf backup=yes"
[ansible@control0 techlab]$ ansible web -b -m service -a "name=httpd state=restarted"
```
{{% /collapse %}}

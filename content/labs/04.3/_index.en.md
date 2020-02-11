---
title: "4.3 - Ansible Playbooks - Output"
weight: 43
---

In this lab we learn how to handle output of tasks.

### Task 1

- Write a playbook `output.yml` that uses the command module to find all config files of postfix. These files are located under `/etc/postfix/` and end with `.cf`. Targeted server is `node1`.
- Register the result to a variable called `output` by using the `register` keyword.
- Include a task using the debug module to print out all content of the variable `output`. If unsure, consult the documentation about the debug module.

### Task 2
- Add another task to the playbook `output.yml` using the debug module and print out the resultng filenames of the search above.

{{% notice tip %}}
Use an appropriate return value to show the output. Information about return values can be found here: [Ansible Docs - Common Return Values](https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html)
{{% /notice %}}

- Now, loop over the results and create a backup file called `<filename.cf>.bak` for each file `<filename.cf>` that was found. Use the command module. Remember, that the result is probably a list with multiple elements.

### Task 3 (Advanced)
- Now we enhance our playbook `output.yml` to only create the backup if no backup file is present. If one single file with an ending `.bak` is present, don't do any backup.
- Solve this task by searching for files ending with `.bak` and registering the result to a variable. Then do tasks only if certain conditions are met.

{{% notice tip %}}
Have a look at the documentation about conditionals: [Ansible Docs - Playbook Conditionals](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html)
{{% /notice %}}

### Task 4 (Advanced)
- Ensure `httpd` is stopped by using an ansible ad hoc command.
- Write a play `servicehandler.yml` that does the following:
- Install `httpd` by using the `yum` module
- Start the service `httpd` with the `command` module. Don't use `service` or `systemd` module. 
- Start the service only if it is not started and running already. (The output of `systemctl status httpd` doesn't contains the string `Active: active (running)`)

{{% notice note %}}
`systemctl status` returns status `failed` when a service is not running. Therefore we use `ignore_errors: true` in the corresponding task to let Ansible continue anyways.
{{% /notice %}}

### Task 5 (Advanced)
- Rewrite the playbook `servicehandler.yml` and ensure that the `ignore_errors: true` line is removed. Instead set the state of the task to failed when and only when the output of `systemctl status httpd` contains the string "failed".

{{% notice note %}}
Have a look at the documentation about error handling: [Ansible Docs - Playbooks Error Handling](https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html)
{{% /notice %}}

- Rerun your playbook and ensure it still runs fine.
- By using an ansible ad hoc command, place an invalid configuration file `/etc/httpd/conf/httpd.conf` and backup the file before. Use the copy module to do this in ad hoc command.
- Restart `httpd` by using an ansible ad hoc command. This should fail since the config file is not vaild.
- Rerun your playbook and ensure it fails.
- Fix the errors in the config filei, restart httpd on node1 and rerun your playbook. Everything should be fine again.

## Solutions

{{% collapse solution-1 "Solution 1" %}}
Documentation about [debug module](https://docs.ansible.com/ansible/latest/modules/debug_module.html)
Example `output.yml`:
```yaml
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

Example `output.yml`:
```yaml
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
Example `output.yml`:
```yaml
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
      # only do this task if the search for files ending with .bak is empty>
      when: search.stdout == ''
```
{{% /collapse %}}

{{% collapse solution-4 "Solution 4" %}}

Stop the httpd service with Ansible:
```bash
$ ansible web -b -a "systemctl stop httpd"
``` 

Content of `servicehandler.yml`:
```yaml
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
```
{{% /collapse %}}

{{% collapse solution-5 "Solution 5" %}}
Example `servicehandler.yml`:
```bash
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
```

```bash
$ ansible web -b -m copy -a "content='bli bla blup' dest=/etc/httpd/conf/httpd.conf backup=yes"
$ ansible web -b -m service -a "name=httpd state=restarted"
```
{{% /collapse %}}

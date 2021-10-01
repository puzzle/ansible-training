---
title: 4.3 Ansible Playbooks - Output
weight: 43
sectionnumber: 4.3
---

In this lab we learn how to handle output of tasks.

### Task 1

* Write a playbook `output.yml` that uses the `command` module to find all config files of postfix. These files are located under `/etc/postfix/` and end with `.cf`. Targeted server is `node1`.
* Register the result to a variable called `output` by using the `register` keyword.
* Include a task using the `debug` module to print out all content of the variable `output`. If unsure, consult the documentation about the `debug` module.

{{% alert title="Note" color="primary" %}}
You might need to install the `postfix` package on `node1`.
{{% /alert %}}


### Task 2
* Add another task to the playbook `output.yml` using the `debug` module and print out the resulting filenames of the search above.

{{% alert title="Tip" color="info" %}}
Use an appropriate return value to show the output. Information about return values can be found here: [Ansible Docs - Common Return Values](https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html)
{{% /alert %}}

* Now, loop over the results and create a backup file called `<filename.cf>.bak` for each file `<filename.cf>` that was found. Use the `command` module. Remember, that the result is probably a list with multiple elements.

### Task 3 (Advanced)
* Now we enhance our playbook `output.yml` to only create the backup if no backup file is present.
* Solve this task by searching for files ending with `.bak` and registering the result to a variable. Then do tasks only if certain conditions are met.

{{% alert title="Tip" color="info" %}}
Have a look at the documentation about the command modul: [Ansible Docs - command](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html)
{{% /alert %}}

### Task 4 (Advanced)
* Ensure `httpd` is stopped by using an Ansible ad hoc command.
* Write a play `servicehandler.yml` that does the following:
* Install `httpd` by using the `yum` module
* Start the service `httpd` with the `command` module. Don't use `service` or `systemd` module.
* Start the service only if it is not started and running already. (The output of `systemctl status httpd` doesn't contains the string `Active: active (running)`)

{{% alert title="Note" color="primary" %}}
Have a look at the documentation about conditionals: [Ansible Docs - Playbook Conditionals](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html)

`systemctl status` returns status `failed` when a service is not running. Therefore we use `ignore_errors: true` in the corresponding task to let Ansible continue anyways.
{{% /alert %}}

### Task 5 (Advanced)
* Rewrite the playbook `servicehandler.yml` and ensure that the `ignore_errors: true` line is removed. Instead set the state of the task to failed when and only when the output of `systemctl status httpd` contains the string "failed".

{{% alert title="Note" color="primary" %}}
Have a look at the documentation about error handling: [Ansible Docs - Playbooks Error Handling](https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html)
{{% /alert %}}

* Rerun your playbook and ensure it still runs fine.
* By using an ansible ad hoc command, place an invalid configuration file `/etc/httpd/conf/httpd.conf` and backup the file before. Use the `copy` module to do this in ad hoc command.
* Restart `httpd` by using an Ansible ad hoc command. This should fail since the config file is not valid.
* Rerun your playbook and ensure it fails.
* Fix the errors in the config file, restart `httpd` on `node1` and rerun your playbook. Everything should be fine again.

## Solutions

{{% details title="Task 1" %}}
Documentation about [debug module](https://docs.ansible.com/ansible/2.9/modules/debug_module.html)
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

{{% /details %}}

{{% details title="Task 2" %}}

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
{{% /details %}}

{{% details title="Task 3" %}}
Possible solution 1:
Example `output.yml`:
```yaml
---
- hosts: node1
  become: true
  tasks:
    - name:
      command: "find /etc/postfix -type f -name *.cf"
      register: output
    - name: create backup only when no backupfile is present
      command: "cp {{ item }} {{ item }}.bak"
      # only do this if there is no .bak for file: item
      args:
        creates: "{{ item }}.bak"
      with_items: "{{ output.stdout_lines }}"
```

Possible solution 2:
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
      # only do this if there is no .bak for file: item
      when: search.stdout.find(item) == -1
```
{{% /details %}}

{{% details title="Task 4" %}}

Stop the `httpd` service with Ansible:
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
{{% /details %}}

{{% details title="Task 5" %}}
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
```
Now fix your apache config. You could use the backup of the file created in the previous ad-hoc command.

```bash
$ ansible web -b -m service -a "name=httpd state=restarted"
```
{{% /details %}}

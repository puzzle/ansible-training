---
title: 4.3 Ansible Playbooks - Output
weight: 43
sectionnumber: 4.3
---

In this lab we learn how to handle output of tasks.

### Task 1

* Write a playbook `output.yml` that uses the `ansible.builtin.command` module to find all config files of postfix.
These files are located under `/etc/postfix/` and end with `.cf`. Targeted server is `node1`.
* Register the result to a variable called `output` by using the `register` keyword.
* Include a task using the `ansible.builtin.debug` module to print out all content of the variable `output`.
If unsure, consult the documentation about the `ansible.builtin.debug` module.

{{% alert title="Note" color="primary" %}}
You might need to install the `postfix` package on `node1`.
{{% /alert %}}

{{% details title="Solution Task 1" %}}
Documentation about [debug module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debug_module.html)
Example `output.yml`:
```yaml
---
- hosts: node1
  become: true
  tasks:
    - name:
      ansible.builtin.command: 
        cmd: "find /etc/postfix -type f -name *.cf"
      register: output
    - name: Print the output
      ansible.builtin.debug:
        var: output
```

{{% /details %}}

### Task 2

* Add another task to the playbook `output.yml` using the `ansible.builtin.debug` module
and print out the resulting filenames of the search above.

{{% alert title="Tip" color="info" %}}
 Use an appropriate return value to show the output.
 Information about return values can be found here: [Ansible Docs - Common Return Values](https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html)
{{% /alert %}}

* Now, loop over the results and create a backup file called `<filename.cf>.bak`
for each file `<filename.cf>` that was found.
Use the `ansible.builtin.command` module.
Remember, that the result is probably a list with multiple elements.

{{% details title="Solution Task 2" %}}

Example `output.yml`:
```yaml
---
- hosts: node1
  become: true
  tasks:
    - name: Find the files
      command: 
        cmd: "find /etc/postfix -type f -name *.cf"
      register: output
    - name: Printb the output
      ansible.builtin.debug:
        var: output.stdout_lines
    - name: create backup
      ansible.builtin.command: 
        cmd: "cp {{ item }} {{ item }}.bak"
      loop: "{{ output.stdout_lines  }}"
```
{{% /details %}}

### Task 3 (Advanced)

* Now we enhance our playbook `output.yml` to only create the backup if no backup file is present.
* Solve this task by searching for files ending with `.bak` and registering the result to a variable.
Then do tasks only if certain conditions are met.

{{% alert title="Tip" color="info" %}}
 Have a look at the documentation about the ansible.builtin.command module: [Ansible Docs - command](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html)
{{% /alert %}}

{{% details title="Solution Task 3" %}}
Possible solution 1:
Example `output.yml`:
```yaml
---
- hosts: node1
  become: true
  tasks:
    - name: Find the files
      ansible.builtin.command: 
        cmd: "find /etc/postfix -type f -name *.cf"
      register: output
    - name: create backup only when no backup file is present
      ansible.builtin.command: 
        cmd: "cp {{ item }} {{ item }}.bak"
        creates: "{{ item }}.bak" # only do this if there is no .bak for file: item
      loop: "{{ output.stdout_lines }}"
```

Possible solution 2:
Example `output.yml`:
```yaml
---
- hosts: node1
  become: true
  tasks:
    - name: Find the backups
      ansible.builtin.command: 
        cmd: "find /etc/postfix -type f -name *.cf.bak"
      register: search
    - name: Find the files
      ansible.builtin.command: 
        cmd: "find /etc/postfix -type f -name *.cf"
      register: output
    - name: create backup only when no backup file is present
      ansible.builtin.command: 
        cmd: "cp {{ item }} {{ item }}.bak"
      loop: "{{ output.stdout_lines  }}"
      when: search.stdout.find(item) == -1 # only do this if there is no .bak for file: item
```
{{% /details %}}

### Task 4 (Advanced)

* Ensure `httpd` is stopped on the group `web` by using an Ansible ad hoc command.
* Write a play `servicehandler.yml` that does the following:
* Install `httpd` by using the `ansible.builtin.dnf` module
* Start the service `httpd` with the `ansible.builtin.command` module.
Don't use `ansible.builtin.service` or `ansible.builtin.systemd_service` module.
* Start the service only if it is not started and running already.
(The output of `systemctl status httpd` doesn't contains the string `Active: active (running)`)

{{% alert title="Note" color="primary" %}}
Have a look at the documentation about conditionals: [Ansible Docs - Playbook Conditionals](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html)

`systemctl status` returns status `failed` when a service is not running.
Therefore, we use `ignore_errors: true` in the corresponding task to let Ansible continue anyway.
{{% /alert %}}

{{% details title="Solution Task 4" %}}

Stop the `httpd` service with Ansible:
```bash
ansible web -b -a "systemctl stop httpd"
```

Content of `servicehandler.yml`:
```yaml
---
- hosts: web
  become: true
  tasks:
    - name: install httpd
      ansible.builtin.dnf:
        name: httpd
        state: present
    - name: check state of service httpd
      ansible.builtin.command: 
        cmd: 'systemctl status httpd'
      register: status
      ignore_errors: true
    - name: See the status
      ansible.builtin.debug:
        var: status.stdout
    - name: start httpd
      ansible.builtin.command: 
        cmd: 'systemctl start httpd'
      when: "'Active: active (running)' not in status.stdout"
```
{{% /details %}}

### Task 5 (Advanced)

* Rewrite the playbook `servicehandler.yml` and ensure that the `ignore_errors: true` line is removed.
Instead, set the state of the task to failed if
and only if the output of `systemctl status httpd` contains the string "failed".

{{% alert title="Note" color="primary" %}}
Have a look at the documentation about error handling: [Ansible Docs - Playbooks Error Handling](https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html)
{{% /alert %}}

* Rerun your playbook and ensure it still runs fine.
* By using an ansible ad hoc command, place an invalid configuration file `/etc/httpd/conf/httpd.conf`
and backup the file before.
Use the `ansible.builtin.copy` module to do this in ad hoc command.
* Restart `httpd` by using an Ansible ad hoc command. This should fail since the config file is not valid.
* Rerun your playbook and ensure it fails.
* Fix the errors in the config file, restart `httpd` on `node1` and rerun your playbook. Everything should be fine again.

{{% details title="Solution Task 5" %}}
Example `servicehandler.yml`:
```bash
---
- hosts: web
  become: true
  tasks:
    - name: install httpd
      ansible.builtin.dnf:
        name: httpd
        state: present
    - name: check state of service httpd
      ansible.builtin.command:
        cmd: 'systemctl status httpd'
      register: status
      failed_when: "'failed' in status.stdout"
    - name: Look at the status
      ansible.builtin.debug:
        var: status.stdout
    - name: start httpd
      ansible.builtin.command: 
        cmd: 'systemctl start httpd'
      when: "'Active: active (running)' not in status.stdout"
```

```bash
ansible web -b -m ansible.builtin.copy -a "content='bli bla blup' dest=/etc/httpd/conf/httpd.conf backup=true"
```
Now fix your apache config. You could use the backup of the file created in the previous ad-hoc command.

```bash
ansible web -b -m ansible.builtin.systemd_service -a "name=httpd state=restarted"
```
{{% /details %}}

### All done?

* [Output as YAML instead of JSON](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html)

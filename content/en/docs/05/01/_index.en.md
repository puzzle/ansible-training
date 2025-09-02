---
title: "5.1 Ansible Roles - Handlers and Blocks"
weight: 51
sectionnumber: 5.1
---

We start to use handlers and blocks as well.

### Task 1

* Create a playbook `myhandler.yml` which applies a role `handlerrole` on `node2`.
* The role `handlerrole` should do the following:
* Create a directory `newdir` in the folder `/home/ansible`.
* If the folder didn't exist before,
then do create a file `README.TXT` in this folder containing the text "This folder was created at `<timestamp>`".
* The value of `<timestamp>` should contain a quite accurate timestamp of when `ansible-playbook` was run.
* Run the playbook several times to see if it is really idempotent.

{{% details title="Solution Task 1" %}}
Below is a possible solution:

```bash
$ cat myhandler.yml
---
- hosts: node2
  become: true
  roles:
    - handlerrole

$ ansible-galaxy init roles/handlerrole

$ cat roles/handlerrole/tasks/main.yml
---
- name: create directory
  ansible.builtin.file:
    path: /home/ansible/newdir
    state: directory
    mode: "0755"
  notify: timestamp

$ cat roles/handlerrole/handlers/main.yml
---
- name: create readme with timestamp
  ansible.builtin.copy:
    dest: /home/ansible/newdir/README.TXT
    content: "This folder was created at {{ ansible_date_time.iso8601 }}"
    mode: "0644"
  listen: timestamp

$ ansible-playbook myhandler.yml #<-- some changes when run the first time
$ ansible all -a "cat /home/ansible/newdir/README.TXT" #<-- show created files with it's content
$ ansible-playbook myhandler.yml #<-- no changes here, idempotent!
```
{{% /details %}}

### Task 2

* Write a playbook `download.yml` which runs a role `downloader` on `node2`.
* The role `downloader` should try to download a file from a non-existing URL.
* The role should be able to handle errors.
Let it write the message _"Download failed!"_ to standard output if the download task failed.
The playbook must keep on running and shall not exit after this message.
* Regardless of download success,
output a message at the end of the play informing that the download attempt has finished.
* Use a `block:` to do these tasks.
* Add another `ansible.builtin.debug` task after the block to confirm the run continues even after a download fail.
* Run the playbook `download.yml`.

{{% details title="Solution Task 2" %}}

```bash
$ cat download.yml
---
- hosts: node2
  become: true
  roles:
    - downloader

$ ansible-galaxy init roles/downloader

$ cat roles/downloader/tasks/main.yml
---
# tasks file for roles/downloader
- block:
    - name: Download things from the internet
      ansible.builtin.get_url:
        url: https://www.not_existing_url.com/not_existing_file
        dest: /tmp/
        mode: "0400"
  rescue:
    - name: "Print an error message"
      ansible.builtin.debug:
        msg: "Download failed!"
  always:
    - name: "Print confirmation"
      ansible.builtin.debug:
        msg: "Download attempt finished."

- name: "A task after the block"
  ansible.builtin.debug:
    msg: "This gets executed after the block"

$ ansible-playbook download.yml
```

{{% alert title="Note" color="primary" %}}
Note the failed download task, but the playbook finished nonetheless.
{{% /alert %}}

{{% /details %}}

### All done?

* [Have a look at Jeff Geerling's roles](https://galaxy.ansible.com/ui/standalone/namespaces/2492/)
* [jeffgeerling.com](https://www.jeffgeerling.com/)


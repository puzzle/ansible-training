---
title: "05.1 Ansible Roles - Handlers and Blocks"
weight: 51
sectionnumber: 5.1
---

We start to use handlers and blocks as well.

### Task 1

* Create a playbook `myhandler.yml` which applies a role `handlerrole` on `node2`.
* The role `handlerrole` should do the following:
* Create a directory `newdir` in the folder `/home/ansible`.
* If the folder didn't exist before, then do create a file `README.TXT` in this folder containing the text "This folder was created at `<timestamp>`".
* The value of `<timestamp>` should contain a quite accurate timestamp of when `ansible-playbook` was run.
* Run the playbook several times to see if it is really idempotent.

### Task 2

* Write a playbook `download.yml` which runs a role `downloader` on `node2`.
* The role `downloader` should try to download a file from a non-existing URL.
* The role should be able to handle errors. Let it write the message _"Download failed!"_ to standard output if the download task failed. The playbook must keep on running and shall not exit after this message.
* In all cases, output a message at the end of the play informing that the download attempt has finished.
* Use a `block:` to do these tasks.
* Run the playbook `download.yml`.

### All done?

* [Have a look at Jeff Geerling's roles](https://www.jeffgeerling.com/)
* [jeffgeerling.com](https://www.jeffgeerling.com/)


## Solutions

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
  file:
    path: /home/ansible/newdir
    state: directory
  notify: timestamp

$ cat roles/handlerrole/handlers/main.yml
---
- name: create readme with timestamp 
  copy:
    dest: /home/ansible/newdir/README.TXT
    content: "This folder was created at {{ ansible_date_time.iso8601 }}"    
  listen: timestamp

$ ansible-playbook myhandler.yml #<-- some changes when run the first time
$ ansible-playbook myhandler.yml #<-- no changes here, idempotent!
```
{{% /details %}}

{{% details title="Solution Task 2" %}}

```bash
$ cat download.yml 
---
- hosts: node2
  become: true
  roles:
    - downloader

$ ansible-galaxy init roles/downloader

$ $ cat roles/downloader/tasks/main.yml 
---
# tasks file for roles/downloader
- block:
    - name: Download things from the internet
      get_url:
        url: http://www.not_existing_url.com/not_existing_file
        dest: /tmp/
  rescue:
    - debug:
        msg: "Download failed!"
  always:
    - debug:
        msg: "Download attempt finished."


$ ansible-playbook download.yml
```

{{% alert title="Note" color="primary" %}}
Note the failed download task, but the playbook finished nonetheless.
{{% /alert %}}

{{% /details %}}

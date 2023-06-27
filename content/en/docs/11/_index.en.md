---
title: 11. Event Driven Ansible
weight: 110
sectionnumber: 11
---

In this lab we are going to learn how to use Event Driven Ansible. For the following tasks, server `node1` and `node2` act as webservers. You can use Lab 4.0 as a guideline.

{{% alert title="Note" color="primary" %}}
Note, that as of June 2023, EDA is still in developer preview state. Documentation and all content is work in progress!
The installation of `ansible-rulebook` and the `ansible.eda` collection works fine on newer Fedora Systems as well as RHEL / Rocky Linux 9. At present times, you could have a harder time on other operating systems. Be warned...
{{% /alert %}}

### Task 1

* Point your webbrowser to the official documentation of `ansible-rulebook`.
* Install and configure everything needed to run ansible-rulebook and source plugins.
* Check version of 'ansible-rulebook'

{{% details title="Solution Task 1" %}}

[https://ansible-rulebook.readthedocs.io/en/stable/index.html](https://ansible-rulebook.readthedocs.io/en/stable/index.html)

Fedora 36+:
```bash
sudo dnf --assumeyes install java-17-openjdk python3-pip
export JAVA_HOME=/usr/lib/jvm/jre-17-openjdk
pip install ansible ansible-rulebook
ansible-galaxy collection install ansible.eda
```

Enterprise Linux 9:
```bash
sudo dnf install java-17-openjdk
sudo dnf install python3-pip
python3 -m venv ~/python
. ~/python/bin/activate
pip install --upgrade pip
pip install ansible ansible-rulebook

ansible-galaxy collection install ansible.eda

sudo dnf install systemd-devel
sudo dnf install gcc
sudo dnf install python3-devel

pip install -r  ~/.ansible/collections/ansible_collections/ansible/eda/requirements.txt
```

{{% /details %}}

### Task 2

* Write a playbook `webserver.yml` that installs the servers in group `web` as webservers. See Lab 4.0 for guidelines.
* Ensure that the inventory file `hosts` in the folder inventory has the group `web` with `node1` and `node2` as members.
* Run the playbook `webserver.yml` and check that the webservers are up and running.

{{% details title="Solution Task 2" %}}

```bash
cat webserver.yml
```
```bash
---
- hosts: web
  become: true
  tasks:
    - name: install httpd
      ansible.builtin.dnf:
        name:
          - httpd
          - firewalld
        state: installed
    - name: start and enable httpd
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: yes
    - name: start and enable firewalld
      ansible.builtin.service:
        name: firewalld
        state: started
        enabled: yes
    - name: open firewall for http
      firewalld:
        service: http
        state: enabled
        permanent: yes
        immediate: yes
```
```bash
cat inventory/hosts
```
```bash
[controller]
control0 ansible_host=<ip-of-control0>

[web]
node1 ansible_host=<ip-of-node1>
node2 ansible_host=<ip-of-node2>
```
```bash
ansible-playbook -i inventory/hosts webserver.yml
dnf install -y lynx
lynx http://<ip-of-node1>
lynx http://<ip-of-node2>
```
{{% /details %}}

### Task 3

* Write a rulebook `webserver_rulebook.yml` that checks if the webpages on `node1` and `node2` are up and running.
* If the webpages are not available anymore, the `webserver.yml` playbook should be re-run.
* Use `url_check` from the `ansible.eda` collection as the source plugin in your rulebook.
* Check the availability of the websites every 8 seconds.

{{% alert title="Note" color="primary" %}}
If you don't have the `ansible.eda` collection installed yet, `ansible-rulebook` would start, but fail because the `url_check` source plugin cannot be found.
{{% /alert %}}

{{% details title="Solution Task 3" %}}
```bash
$ cat webserver_rulebook.yml`
---
- name: rebuild webservers if site down
  hosts: web
  sources:
    - name: check webserver
      ansible.eda.url_check:
        urls:
          - http://<ip-of-node1>:80/
          - http://<ip-of-node2>:80/
        delay: 8
  rules:
    - name: check if site down and rebuild
      condition: event.url_check.status == "down"
      action:
        run_playbook:
          name: webserver.yml
```
{{% /details %}}

### Task 4

* Start `webserver_rulebook.yml` in verbose mode.
* Stop the httpd service on `node1` with ansible from another terminal on `control0` and see how the playbook `webserver.yml` is re-run. (You could also just stop the service directly on `node1`.)

{{% details title="Solution Task 4" %}}
```bash
ansible-rulebook --rulebook webserver_rulebook.yml -i inventory/hosts --verbose

ansible node1 -i inventory/hosts -b -m service -a "name=httpd state=stopped"
```
{{% /details %}}


### Task 5

* Write the rulebook `webhook_rulebook.yml` that opens a webhook on port 5000 of the control node `control0`.
* The rulebook should re-run the playbook `webserver.yml` if the webhook receives a message matching exactly the string "webservers down".
* Use `webhook` from the `ansible.eda` collection as the source plugin in your rulebook.

{{% details title="Solution Task 5" %}}
```bash
$ cat webhook_rulebook.yml 
---
- name: rebuild webserver if webhook receives message that matches rule condition
  hosts: web
  sources:
    - name: start webhook and listen for messages
      ansible.eda.webhook:
        host: 0.0.0.0
        port: 5000
  rules:
    - name: rebuild webserver if monitoring tool sends alert
      condition: event.payload.message == "webservers down"
      action:
        run_playbook:
          name: webserver.yml
```
{{% /details %}}

### Task 6

* Run the rulebook `webhook_rulebook.yml` in verbose mode.
* Send the string "webservers running" to the webhook.
* You can do this by issuing: `curl -H 'Content-Type: application/json' -d "{\"message\": \"webservers running\"}" 127.0.0.1:5000/endpoint`
* See how the message is received, processed, but no actions are taken since the message doesn't match the condition defined.
* Now send the message "webservers down" to the webhook. See how the playbook `webserver.yml` is run.

{{% details title="Solution Task 6" %}}
```bash
ansible-rulebook --rulebook webhook_rulebook.yml -i inventory/hosts --verbose
```
```bash
curl -H 'Content-Type: application/json' -d "{\"message\": \"webservers running\"}" 127.0.0.1:5000/endpoint
```
```bash
curl -H 'Content-Type: application/json' -d "{\"message\": \"webservers down\"}" 127.0.0.1:5000/endpoint
```
{{% /details %}}

### Task 7

* Write the rulebook `complex_rulebook.yml`. It has to meet the following requirements:
* It should check for three things:
  * check if the website on one of the two webservers is down. (Same as Task 3 above)
  * check if the message matches exactly the string "webservers down" (Same as Task 5 above)
  * check if the message contains the string "ERROR"
* If one of the criterias above are met, do two things:
  1. run the ansible shell module to print the string "WEBSERVER ISSUES, REMEDIATION IN PROGRESS." into the journald log. (The command to do so is "systemd-cat echo "WEBSERVER ISSUES, REMEDIATION IN PROGRESS.")
  2. run playbook `webservers.yml`
* Start the rulebook `complex_rulebook.yml` and do the same test as in Task 4 and Task 6.

{{% details title="Solution Task 7" %}}

```bash
cat complex_rulebook.yml
```
```bash
---
- name: rebuild webserver if webhook receives message that matches rule condition
  hosts: web
  sources:
    - name: check webserver
      ansible.eda.url_check:
        urls:
          - http://<ip-of-node1>:80/
          - http://<ip-of-node2>:80/
        delay: 8
    - name: start webhook and listen for messages
      ansible.eda.webhook:
        host: 0.0.0.0
        port: 5000
  rules:
    - name: rebuild webserver if any source reports an alert
      condition:
        any:
          - event.url_check.status == "down"
          - event.payload.message == "webservers down"
          - event.payload.message is search("ERROR",ignorecase=true)
      actions:
        - run_module:
            name: ansible.builtin.shell
            module_args:
              cmd: "systemd-cat echo \"WEBSERVER ISSUES, STARTING REMEDIATION NEXT.\""
        - run_playbook:
            name: webserver.yml
```

```bash
ansible-rulebook --rulebook complex_rulebook.yml -i inventory/hosts --verbose
```
```bash
curl -H 'Content-Type: application/json' -d "{\"message\": \"webservers down\"}" 127.0.0.1:5000/endpoint
```
Note, that you would have to open port 5000 on the firewall if the curl command is not send from the controller itself.
{{% /details %}}

### Task 9

* What source plugins are available in the `ansible.eda` collection?

{{% details title="Solution Task 10" %}}
[Event Driven Ansible on Github](https://github.com/ansible/event-driven-ansible/tree/main/extensions/eda/plugins/event_source)
{{% /details %}}

### All done?

* [Ansible-rulebook documentation](https://ansible-rulebook.readthedocs.io/en/stable/)
* [AnsibleAutomates Youtube channel for more examples](https://www.youtube.com/@AnsibleAutomation/videos)

---
title: 11.2. Event Driven Ansible - Events and Facts
weight: 112
sectionnumber: 11
---

In this lab we will have a closer look at events and facts.

### Task 1

* Copy the rulebook from Lab 11.2 Task 3 to a new one with the name `debug_event_rulebook.yml`.
* Substitute the `run_playbook` action with a `debug` action.
* That debug action should print out all information from the event.
* Stop the httpd service on node1.
* Run the rulebook in verbose mode. The debug action should show all information about the event.

{{% details title="Solution Task 1" %}}
```bash
cat debug_event_rulebook.yml
```
```bash
---
- name: show event json if site down
  hosts: web
  sources:
    - name: check webserver
      ansible.eda.url_check:
        urls:
          - http://<ip-of-node1>:80/
          - http://<ip-of-node2>:80/
        delay: 8
  rules:
    - name: check if site down and debug
      condition: event.url_check.status == "down"
      action:
        debug:
          var: event
```
```bash
ansible node1 -i inventory/hosts -b -m ansible.builtin.systemd_service -a "name=httpd state=stopped"
```
```bash
ansible-rulebook --rulebook debug_event_rulebook.yml -i inventory/hosts -vv
```
```bash
...
2023-06-26 15:04:55,381 - ansible_rulebook.rule_set_runner - INFO - call_action debug
2023-06-26 15:04:55,381 - ansible_rulebook.rule_set_runner - INFO - substitute_variables [{'var': 'event'}] [{'event': {'url_check': {'error_msg': "Cannot connect to host 5.102.146.223:80 ssl:default [Connect call failed ('5.102.146.223', 80)]", 'url': 'http://5.102.146.223/', 'status': 'down'}, 'meta': {'received_at': '2023-06-26T13:04:55.379428Z', 'source': {'name': 'check webserver', 'type': 'ansible.eda.url_check'}, 'uuid': '6710f9a8-c489-4699-a804-8e796855e290'}}}]
2023-06-26 15:04:55,381 - ansible_rulebook.rule_set_runner - INFO - action args: {'var': 'event'}
{'url_check': {'error_msg': "Cannot connect to host 5.102.146.223:80 ssl:default [Connect call failed ('5.102.146.223', 80)]", 'url': 'http://5.102.146.223/', 'status': 'down'}, 'meta': {'received_at': '2023-06-26T13:04:55.379428Z', 'source': {'name': 'check webserver', 'type': 'ansible.eda.url_check'}, 'uuid': '6710f9a8-c489-4699-a804-8e796855e290'}}
...
```
{{% /details %}}

### Task 2

* Rewrite the rulebook `debug_event_rulebook.yml`:
* Use a `run_playbook` action to start a playbook named `sos.yml`
* The playbook `sos.yml` should create an unattended sos report labeled with the fully qualified collection name of the source plugin used. Be sure to install the appropriate packages so that the sos report can be created.
* The name of the source plugin should be taken from the json output as a variable.
* The creation of the sos report takes quite some time.
* Ensure that the condition is throttled to run the action once within 5 minutes at most.
* The delay of the source check should stay at 8 seconds.
* Run the rulebook `debug_event_rulebook.yml` and ensure the sos reports on the webservers have the needed label.


{{% alert title="Note" color="primary" %}}
There are good onlinetools to convert [one-line json to multiline json](https://jsonformatter.curiousconcept.com) as well as [json to yaml converters](https://jsonformatter.org/json-to-yaml). Note: The json copied from the output has sometimes single quotes, RFC 8259 demands double quotes. Be sure that your converter fixes this as well. These converters can come in handy for easier reading of the output.
{{% /alert %}}

{{% details title="Solution Task 2" %}}
See the documentation on how to [throttle event storms](https://ansible.readthedocs.io/projects/rulebook/en/stable/conditions.html#throttle-actions-to-counter-event-storms-reactive).

```bash
cat debug_event_rulebook.yml
```
```bash
---
- name: run sos playbook if site down
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
      throttle:
        once_within: 5 minutes
        group_by_attributes:
          - event.meta.source.type
      action:
        run_playbook:
          name: sos.yml
```

```bash
cat sos.yml
```
```bash
---
- hosts: web
  become: true
  tasks:
    - name: install sos package
      ansible.builtin.dnf:
        name:
          - sos
        state: installed

    - name: create a sos report unattended containing no sensitive information
      ansible.builtin.command: |
        "sos report --clean --batch --label {{ ansible_eda.event.meta.source.type }}"
```

```bash
ansible-rulebook --rulebook debug_event_rulebook.yml -i inventory/hosts -vv
```
```bash
...
2023-06-28 11:15:53,766 - ansible_rulebook.builtin - INFO - ruleset: show event \
  json if site down, rule: check if site down and rebuild
2023-06-28 11:15:53,766 - ansible_rulebook.builtin - INFO - Calling Ansible runner

PLAY [web] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [node1]

TASK [install sos package] *****************************************************
ok: [node1]

TASK [create a sos report unattended containing no sensitive information] ******
changed: [node1]
...
PLAY RECAP *********************************************************************
node1                      : ok=3    changed=1    unreachable=0    failed=0    
skipped=0    rescued=0    ignored=0   
2023-06-28 11:17:59,741 - ansible_rulebook.builtin - INFO - Ansible Runner \
  Queue task cancelled
2023-06-28 11:17:59,742 - ansible_rulebook.builtin - INFO - Playbook rc: 0, \ 
  status: successful
...
```
{{% /details %}}

### All done?

* [Preview of AAP EDA-Controller GUI](https://www.youtube.com/watch?v=7i_EzHyrKQc&t=178s)

---
title: 11.3. EDA-Server
weight: 113
sectionnumber: 11
---

In this lab we will learn how to use EDA-Server to run our rulebooks. Some tasks have to be done on Ascender.

### Task 1

To connect your EDA-Server to your Ansible Controller, you have to create an access token on Ascender and add it to EDA-Server

* On Ascender, create an access token for the user Ansible. Be sure to chose the write scope
* On EDA-Server add this controller token to the user Ansible

{{% details title="Solution Task 1" %}}

Go to the Ascender Web-GUI

* On the left hand side, chose `Access`, then `Users`
* Click on user `ansible`, then chose the tab `Tokens` and click on the blue button `Add`
* Leave the `Application` field empty, add a description and chose the write scope.
* Click the `Save` button. Copy the Token from the popup window. This token is shown only once, so remember it.

Go to the EDA-Server Web-GUI

* On the left-hand side, chose `User Access` and then `Users`
* On the right, chose user `ansible`
* Now to the tab `Controller Tokens`
* Click on the button `Create controller token`. If you created already one, you have to delete it first to be able to create a new one.
* Enter a name, a description and paste in the token from Ascender in the `Token` field

{% /details %}}

### Task 2

Now we add a git repository with our rulebooks as a project to EDA-Server

* Be sure, your ansible rulebooks are residing in a toplevel folder "rulebooks" inside your git repository
* Add a Project to EDA-Server pointing to your git repository

{{% alert title="Note" color="primary" %}}
After creation the status of the project will be `failed` as long as you don't have a directory `extensions/eda/rulebooks` or `rulebooks` (relative to the root of the repository) present.
{{% /alert %}}

{{% details title="Solution Task 2" %}}

* On the left side navigate to `Resources` and then `Projects`.
* On the right side click on the `Create project` button.
* Enter a name, description, leave `SCM Type` as `Git`.
* As `SCM URL` enter the path to your git repository on your Controller node (`https://<yourname>-controller.workshop.puzzle.ch:4000/ansible/techlab`). Remember to use port 4000.
* Leave the `Credential` field empty.
* Clink on `Create project` at the bottom of the page.

{{% /details %}}


### Task 3

The last step needed to be able to run rulebooks is creating a Decision Environment.

* Install `ansible-builder` with pip on your `<yourname>-edaserver`. Be sure to install `podman` as well since it's the default container engine for `ansible-builder`.
* Prepare a yaml file `techlab-de.yml` with the definition for your Decision Environment. Take the [blueprint from the ansible-rulebook Github project](https://github.com/ansible/ansible-rulebook/blob/main/minimal-decision-environment.yml) as your base.
* Build the Decision Environment, name the image `techlab-de.yml` and tag it with `latest`.
* Push it to the container registry provided by your teacher.

{{% details title="Solution Task 3" %}}
```bash
pip3 install -y ansible-builder podman
```
```bash
cat techlab-de.yml
```
```
---
version: 3
images:
  base_image:
    name: 'registry.access.redhat.com/ubi9/python-311:latest'
dependencies:
  galaxy:
    collections:
      - ansible.eda
  python:
    - azure-servicebus
    - aiobotocore
    - aiohttp
    - aiokafka
    - watchdog
    - systemd-python
    - dpath
    - ansible-rulebook
  ansible_core:
    package_pip: ansible-core==2.14.4
  ansible_runner:
    package_pip: ansible-runner
  system:
    - java-17-openjdk-devel [platform:rpm]
```
```bash

```
```bash
ansible-builder build -f techlab-de.yml -t techlab-de:latest
```
```bash
podman login https://<registry_url> -u <username> -p <password>
podman push techlab-de:latest <registry_url>/techlab-de:latest
```

{{% /details %}}

### Task 4

* Add the Decision Environment `techlab-de` you just created to EDA-Server


{{% details title="Solution Task 4" %}}

* On the left side of the EDA-Server Web-GUI navigate to `Resources` then `Decision Environments`.
* On the right side, click on `Create decision environemnt`.
* Enter a name and description.
* In the `Image` field enter the path with tag to your Decision Environment (`<registry_url>/techlab-de:latest`)
* Leave the `Credentials` field empty
* Click on `Create decision environment` at the bottom of the page.

{{% /details %}}

### Task 5

Now have everything ready to run a ansible-rulebook. Ensure you have a job template `Provision_Webserver` in the Organization `Techlab` of your Ascender server. See the Ascender labs to set it up.

Make the following changes to your `webserver_rulebook.yml` rulebook (Lab 11.1):

* Change the action of the rulebook to start a job template `Provision_Webserver` in the organization `Techlab`.
* Be sure to push the changes into your git repository.
* On the EDA-Server create a `Rulebook Activation`

{{% details title="Solution Task 5" %}}
```bash
cat webserver_rulebook.yml
```
```yaml
---
- name: rebuild webservers if site down
  hosts: web
  sources:
    - name: check webserver
      ansible.eda.url_check:
        urls:
          - http://<yourname>-node1.workshop.puzzle.ch:80/
          - http://<yourname>-node2.workshop.puzzle.ch:80/
        delay: 8
  rules:
    - name: check if site down and rebuild
      condition: event.url_check.status == "down"
      action:
        run_job_template:
          name: Provision_Webserver
          organization: Techlab
```

* On the left side of the EDA-Server GUI, navigate to `Views`, then `Rulebook Activiations`
* On the right side click `Create rulebook activation`
* Enter the name `Webserver Provisioning`,  add a description and chose the project `Techlab Repo`.
* Chose `webserver_rulebook.yml` in the `Rulebook` field.
* (if no Rulebook shows up, sync the project)
* Chose `techlab-de` in the `Decision environment` field.
* Leave `Restart policy` set to `On failure`.
* Click `Create rulebook activation` at the bottom of the page.

{{% /details %}}

### Task 6

After a successful creation of the `Rulebook Activation` you can follow its logs

* Navigate to `Views`, then `Rulebook Activations` on the left side and then click on your `Webserver Provisioning` Rulebook Activation.
* Click on the `History` tab.
* Now click on the running instance ot the activation.
* In the `Output` field have a look at the logs

{{% details title="Solution Task 6" %}}

Output filed of the activation:

```bash
2023-11-08 14:31:09,925 - ansible_rulebook.app - INFO - Starting worker mode
2023-11-08 14:31:09,925 - ansible_rulebook.websocket - INFO - websocket ws://edaserver-app-daphne:8001/api/eda/ws/ansible-rulebook connecting
2023-11-08 14:31:09,958 - ansible_rulebook.websocket - INFO - websocket ws://edaserver-app-daphne:8001/api/eda/ws/ansible-rulebook connected
2023-11-08 14:31:09,996 - ansible_rulebook.job_template_runner - INFO - Attempting to connect to Controller https://puzzle-ascender.workshop.puzzle.ch
2023-11-08 14:31:10,106 - ansible_rulebook.app - INFO - AAP Version 23.1.0
2023-11-08 14:31:10,106 - ansible_rulebook.app - INFO - Starting sources
2023-11-08 14:31:10,107 - ansible_rulebook.app - INFO - Starting rules
2023-11-08 14:31:10,107 - ansible_rulebook.engine - INFO - run_ruleset
2023-11-08 14:31:10,109 - drools.ruleset - INFO - Using jar: /usr/local/lib/python3.9/site-packages/drools/jars/drools-ansible-rulebook-integration-runtime-1.0.5-SNAPSHOT.jar
2023-11-08 14:31:10 669 [main] INFO org.drools.ansible.rulebook.integration.api.rulesengine.AbstractRulesEvaluator - Start automatic pseudo clock with a tick every 100 milliseconds
2023-11-08 14:31:10,673 - ansible_rulebook.engine - INFO - ruleset define: {"name": "rebuild webservers if site down", "hosts": ["web"], "sources": [{"EventSource": {"name": "check webserver", "source_name": "ansible.eda.url_check", "source_args": {"urls": ["http://puzzle-node1.workshop.puzzle.ch:80/"], "delay": 8}, "source_filters": []}}], "rules": [{"Rule": {"name": "check if site down and rebuild", "condition": {"AllCondition": [{"EqualsExpression": {"lhs": {"Event": "url_check.status"}, "rhs": {"String": "down"}}}]}, "actions": [{"Action": {"action": "run_job_template", "action_args": {"name": "Provision_Webserver", "organization": "Puzzle"}}}], "enabled": true}}]}
2023-11-08 14:31:10,690 - ansible_rulebook.engine - INFO - load source
2023-11-08 14:31:11,166 - ansible_rulebook.engine - INFO - load source filters
2023-11-08 14:31:11,167 - ansible_rulebook.engine - INFO - loading eda.builtin.insert_meta_info
2023-11-08 14:31:11,586 - ansible_rulebook.engine - INFO - Calling main in ansible.eda.url_check
2023-11-08 14:31:11,587 - ansible_rulebook.websocket - INFO - feedback websocket ws://edaserver-app-daphne:8001/api/eda/ws/ansible-rulebook connecting
```
{{% /details %}}

### Task 7

Now, we stop the webserver on node1 and see in the logs of the rulebook activation how the rule triggers the action to start the job template on ascender and rebuild the webservers.

{{% details title="Solution Task 7" %}}

On `<yourname>-node1.workshop.puzzle.ch`:

```bash
sudo systemctl stop httpd
```

In the logs on EDA-Server (see the last task to navigate there):
```bash
...
2023-11-08 14:33:27 847 [main] INFO org.drools.ansible.rulebook.integration.api.rulesengine.RegisterOnlyAgendaFilter - Activation of effective rule "check if site down and rebuild" with facts: {m={url_check={url=http://puzzle-node1.workshop.puzzle.ch:80/, status=down, error_msg=Cannot connect to host puzzle-node1.workshop.puzzle.ch:80 ssl:default [Connect call failed ('5.102.145.36', 80)]}, meta={source={name=check webserver, type=ansible.eda.url_check}, received_at=2023-11-08T14:33:27.845005Z, uuid=65c50f85-89af-4ab3-ac25-81a1f951c469}}}
2023-11-08 14:33:27,848 - ansible_rulebook.rule_generator - INFO - calling check if site down and rebuild
2023-11-08 14:33:40,545 - ansible_rulebook.rule_set_runner - INFO - Task action::run_job_template::rebuild webservers if site down::check if site down and rebuild finished, active actions 0
2023-11-08 14:33:40,550 - ansible_rulebook.rule_set_runner - INFO - call_action run_job_template
2023-11-08 14:33:40,552 - ansible_rulebook.rule_set_runner - INFO - substitute_variables [{'name': 'Provision_Webserver', 'organization': 'Puzzle'}] [{'event': {'url_check': {'url': 'http://puzzle-node1.workshop.puzzle.ch:80/', 'status': 'down', 'error_msg': "Cannot connect to host puzzle-node1.workshop.puzzle.ch:80 ssl:default [Connect call failed ('5.102.145.36', 80)]"}, 'meta': {'source': {'name': 'check webserver', 'type': 'ansible.eda.url_check'}, 'received_at': '2023-11-08T14:33:27.845005Z', 'uuid': '65c50f85-89af-4ab3-ac25-81a1f951c469'}}}]
2023-11-08 14:33:40,552 - ansible_rulebook.rule_set_runner - INFO - action args: {'name': 'Provision_Webserver', 'organization': 'Puzzle'}
2023-11-08 14:33:40,552 - ansible_rulebook.action.run_job_template - INFO - running job template: Provision_Webserver, organization: Puzzle
2023-11-08 14:33:40,552 - ansible_rulebook.action.run_job_template - INFO - ruleset: rebuild webservers if site down, rule check if site down and rebuild
2023-11-08 14:34:01,225 - ansible_rulebook.rule_set_runner - INFO - Task action::run_job_template::rebuild webservers if site down::check if site down and rebuild finished, active actions 0
```

Check the webpage `http://<yourname>-node1.workshop.puzzle.ch/` in your internet browser and ensure the page is available again.

{{% /details %}}

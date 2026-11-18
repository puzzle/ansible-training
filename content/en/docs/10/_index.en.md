---
title: 10. Ansible-Navigator
weight: 100
sectionnumber: 10
---

During this lab you will get to know `ansible-navigator`.

### Task 1

* Install all packages needed to use `ansible-navigator` on the controller host.

{{% alert title="Tip" color="info" %}}
It doesn't matter which container engine you use. We use podman since it's the default.
{{% /alert %}}

* After installing, start `ansible-navigator` and closely observe what's happening. What does the output show you?

{{% details title="Solution Task 1" %}}
Since we have no Red Hat Subscription available, we install ansible-navigator with pip.
We install podman as well to be able to use containers.

```bash
$ sudo dnf install -y podman python3-pip
$ pip3 install ansible-navigator --user
...
```

* Ansible-navigator downloads a default execution environment:

```bash
$ ansible-navigator
----------------------------------------------------------------------------------
Execution environment image and pull policy overview
----------------------------------------------------------------------------------
Execution environment image name:  quay.io/ansible/ansible-navigator-demo-ee:0.6.0
Execution environment image tag:   0.6.0
Execution environment pull policy: tag
Execution environment pull needed: True
----------------------------------------------------------------------------------
Updating the execution environment
----------------------------------------------------------------------------------
Trying to pull quay.io/ansible/ansible-navigator-demo-ee:0.6.0...
Getting image source signatures
Copying blob 7a0437f04f83 done
... <ommitted> ...
Copying config e65e4777ca done
Writing manifest to image destination
Storing signatures
e65e4777caa3791b6b55a61cd5b171a99fad6d0e2b58097ad242b2b8d50e5103
```

{{% /details %}}

### Task 2

Configure ansible-navigator and ensure the following:

* Use the `ansible.cfg` in your local techlab directory.
If you didn't do the preceding labs , create a config file with `ansible-config init --disabled -t all > ansible.cfg`.
* Set `remote_user` in `ansible.cfg` to `ansible`.
* Move the inventory file `hosts` in a folder `inventory/`.
* Set the inventory file in your `ansible.cfg` to `inventory/hosts`.
* Use 20 forks.
* Enable colorful output.
* Log to a file `log.txt` in a subfolder `log` with a loglevel of `INFO`.
* Use the `quay.io/ansible/creator-ee:latest` execution environment when running a playbook.
* Create artifacts when running a playbook with `ansible-navigator` and put them in a subfolder `artifacts`.
Prefix the name of the artifact-file with the name of the actual playbook.

{{% details title="Solution Task 2" %}}

```bash
$ cat ansible.cfg
[defaults]
remote_user = ansible
inventory = /home/ansible/techlab/inventory/hosts

$ cat ansible-navigator.yml
---
ansible-navigator:
  ansible:
    config:
      path: /home/ansible/techlab/ansible.cfg
    cmdline: "--forks 20"
  color:
    enable: True
  execution-environment:
    container-engine: podman
    enabled: True
    image: quay.io/ansible/creator-ee:latest
  logging:
    level: info
    file: logs/log.txt
  playbook-artifact:
    enable: True
    save-as: artifacts/{playbook_name}-artifact.json

```
{{% /details %}}

### Task 3

* Create a playbook `site.yml` that contains two plays.
The first play is the same as `webservers.yml` from the earlier labs.
The second play sets the content of `/etc/motd` on all hosts of the group `db` to `This is a database server`.
Be sure to set a `name` keyword for each play.
Use "Run tasks on webservers" as value for the name keyword of the play that runs on the group `web`
and "Run tasks on dbservers" for the play that runs on group `db`.

{{% details title="Solution Task 3" %}}
```bash
$ cat site.yml
---
- name: Run tasks on webservers
  hosts: web
  become: true
  tasks:
    - name: install httpd
      ansible.builtin.dnf:
        name: httpd
        state: installed
    - name: start and enable httpd
      ansible.builtin.systemd_service:
        name: httpd
        state: started
        enabled: true
    - name: start and enable firewalld
      ansible.builtin.systemd_service:
        name: firewalld
        state: started
        enabled: true
    - name: open firewall for http
      ansible.posix.firewalld:
        service: http
        state: enabled
        permanent: true
        immediate: true
- name: Run tasks on dbservers
  hosts: db
  become: true
  tasks:
    - name: prepare motd
      ansible.builtin.copy:
        dest: /etc/motd
        content: "This is a database server"
        mode: "0644"
```
{{% /details %}}

### Task 4

* Run the playbook `site.yml` by using ansible-navigator and the configuration from Task 2.
* What additional config parameter has to be set in your `ansible.cfg`? If unsure, run the playbook and debug the error.
* While running the playbook, check in another terminal window if the container gets startet and stopped.
You can do this by issuing `watch podman container list`.

{{% details title="Solution Task 4" %}}
```bash
$ ansible-navigator run site.yml
...
```
If you had not set `remote_user` to `ansible` in the ansible configuration,
the EE would use user root to connect to the hosts per default.
So in case of problems, check your ansible.cfg:
```bash
$ grep remote_user ansible.cfg
remote_user = ansible
```
See the running container:
```bash
$ watch -n1 podman container list

Every 1.0s: podman container list                       control0: Tue Sep 15 16:29:04 2026

CONTAINER ID  IMAGE	                         COMMAND               CREATED        STAT
US	  PORTS       NAMES
77554aedb8f4  quay.io/ansible/creator-ee:latest  ansible-playbook ...  9	seconds	ago  Up 8
 seconds              ansible_runner_1d0a7283-a051-4689-b773-7012c65bf762
```
{{% /details %}}

### Task 5

* After a successful run of your playbook, we play around with the TUI.
Be sure to not let ansible-navigator run in interactive mode and not stdout mode (-m stdout).
Since interactive is the default, you shouldn't have any problems with that.
* Inspect the output in the TUI. Navigate to the task in "open firewall for http".

{{% details title="Solution Task 5" %}}

```bash
$ ansible-navigator run site.yml -m interactive
...
```
Note that `-m interactive` is not needed unless you configured the mode to `stdout` explicitly in your
`ansible-navigator.yml` config file.

```bash
  PLAY NAME               OK CHANGED UNREACHABLE FAILED SKIPPED IGNORED IN PROGRESS TASK COUNT   PROGRESS
0│Run tasks on webservers  5       0           0      0       0       0           0          5   COMPLETE
1│Run tasks on dbservers   2       0           0      0       0       0           0          2   COMPLETE
```
Choose `0` to inspect the tasks that run on the hostgroup `web`

```bash
  Result Host  Number Changed Task                     Task action              Duration
0│Ok     node1      0 False   Gathering Facts          gather_facts                   2s
1│Ok     node1      1 False   install httpd            ansible.builtin.dnf            2s
2│Ok     node1      2 False   start and enable httpd   ansible.builtin.systemd_s      1s
3│Ok     node1      3 False   start and enable firewallansible.builtin.systemd_s      1s
4│Ok     node1      4 False   open firewall for http   ansible.posix.firewalld        1s
```
Choose `4` to inspect the task for setting firewall rules

```bash
Play name: Run tasks on webservers:4
Task name: open firewall for http
Ok: node1 Permanent and Non-Permanent(immediate) operation
 0│---
 1│duration: 0.72592
 2│end: '2026-09-15T14:31:49.105882+00:00'
 3│event_loop: null
 4│host: node1
 5│play: Run tasks on webservers
 6│play_pattern: web
 7│playbook: /home/ansible/techlab/site.yml
 8│remote_addr: node1
 9│res:
10│  _ansible_no_log: false
11│  changed: false
12│  invocation:
13│    module_args:
14│	 icmp_block: null
15│	 icmp_block_inversion: null
16│	 immediate: true
17│	 interface: null
18│	 masquerade: null
19│	 offline: null
20│	 permanent: true
21│	 port: null
22│	 port_forward: null
23│	 protocol: null
24│	 rich_rule: null
25│	 service: http
26│	 source: null
27│	 state: enabled
28│	 target: null
29│	 timeout: 0
30│	 zone: null
31│  msg: Permanent and Non-Permanent(immediate) operation
32│resolved_action: ansible.posix.firewalld
33│start: '2026-09-15T14:31:48.379962+00:00'
34│task: open firewall for http
35│task_action: ansible.posix.firewalld
36│task_args: ''
37│task_path: /home/ansible/techlab/site.yml:20
```
Here you can find a lot of details about the task.
Note that you can switch between tasks when pressing the number equal to the indicated line number from the play summary.
In this case this would be the numbers from `0` to `4`.

{{% /details %}}

### Task 6

Use `ansible-navigator` to see the documentation of:

* the `file` module.
* the `dig` lookup plugin.

{{% details title="Solution Task 6" %}}

Attention! Be sure to use an EE that contains the needed documentation.
If that's not the case, just switch to not using any EE with the option `--ee false`.
```bash
$ ansible-navigator doc file
$ ansible-navigator doc -t lookup dig --ee false
...
```
{{% /details %}}

### Task 7

* Use `ansible-navigator` to see the current inventory.
* Navigate to `groups`, then `db` and then show all information of node `node2`.

{{% details title="Solution Task 7" %}}
Note that when inspecting an inventory you have to name it explicitly even when you have it configured in your `ansible.cfg`.
```bash
$ ansible-navigator inventory -i inventory/hosts
...
```
Navigate through the inventory and see what information you can find.
For example show all information about the hosts in group `db`:

```bash
  TITLE                DESCRIPTION
0│Browse groups        Explore each inventory group and group members members
1│Browse hosts         Explore the inventory with a list of all hosts
```
Choose `0`
```bash
  NAME                                        TAXONOMY                           TYPE
0│controller                                  all                                group
1│db                                          all                                group
2│ungrouped                                   all                                group
3│web                                         all                                group
```
Choose `1`
```bash
  NAME                           TAXONOMY                                      TYPE
0│node2                          all▸db                                        host
```
Choose `0`
```bash
[node2]
0│---
1│ansible_host: 5.102.148.164
2│inventory_hostname: node2
```
{{% /details %}}

### Task 8

* Use `ansible-navigator` to see the current ansible configuration.

{{% details title="Solution Task 8" %}}
```bash
$ ansible-navigator config
...
```
```bash
    OPTION                      DEFAULT SOURCE  VIA                         CURRENT VALUE
  0│ACTION_WARNINGS                True default default                     True
  1│AGNOSTIC_BECOME_PROMPT         True default default                     True
  2│ALLOW_WORLD_READABLE_TMPFILE   True default default                     False
  3│ANSIBLE_CONNECTION_PATH        True default default                     None
  4│ANSIBLE_COW_ACCEPTLIST         True default default                     ['bud-frogs', 'bunny', 'cheese...
  5│ANSIBLE_COW_PATH               True default default                     None
  6│ANSIBLE_COW_SELECTION          True default default                     default
  7│ANSIBLE_FORCE_COLOR            True default default                     False
  8│ANSIBLE_NOCOLOR                True default default                     False
  9│ANSIBLE_NOCOWS                 True default default                     False
 10│ANSIBLE_PIPELINING             True default default                     False
 11│ANY_ERRORS_FATAL               True default default                     False
  ...
```
Choose `9`
```bash
ANSIBLE NOCOWS (current/default: False)
 0│---
 1│current: false
 2│default: false
 3│description: If you have cowsay installed but want to avoid the 'cows' (why????),
 4│  use this.
 5│env:
 6│- name: ANSIBLE_NOCOWS
 7│ini:
 8│- key: nocows
 9│  section: defaults
10│name: Suppress cowsay output
11│option: ANSIBLE_NOCOWS
12│source: default
13│type: boolean
14│via: default
15│yaml:
16│  key: display.i_am_no_fun
```
{{% /details %}}

### Task 9

* The run of `site.yml` should have created an artifact file in the folder `artifacts/`.
* Replay the run by using `ansible-navigator` with the corresponding option.

{{% details title="Solution Task 9" %}}
```bash
$ ansible-navigator replay artifacts/site-artifact.json
...
```
Note that no ansible-run is triggered and no container of the EE-image is started.
{{% /details %}}

### Task 10

Use `ansible-navigator` to show all:

* available collections.
* infos about the module `credential` of the `awx.awx` collection.

{{% details title="Solution Task 10" %}}
```bash
$ ansible-navigator collections
...
```
```bash
  Name                         Version  Shadowed   Type        Path
0│ansible.builtin              2.16.3   False      contained   /usr/local/lib/python3.12/site-packages/ansible
1│ansible.posix                1.5.4    False      contained   /usr/share/ansible/collections/ansible_collections/ansible/posix
2│ansible.windows              2.2.0    False      contained   /usr/share/ansible/collections/ansible_collections/ansible/windows
3│awx.awx                      23.7.0   False      contained   /usr/share/ansible/collections/ansible_collections/awx/awx
4│containers.podman            1.12.0   False      contained   /usr/share/ansible/collections/ansible_collections/containers/podman
5│kubernetes.core              3.0.0    False      contained   /usr/share/ansible/collections/ansible_collections/kubernetes/core
6│redhatinsights.insights      1.2.2    False      contained   /usr/share/ansible/collections/ansible_collections/redhatinsights/insights
7│theforeman.foreman           4.0.0    False      contained   /usr/share/ansible/collections/ansible_collections/theforeman/foreman
```
Choose `3`:
```bash
   Awx.awx                      Type       Added Deprecated  Description
 0│ad_hoc_command               module     4.0.0 False       create, update, or destroy Automation Platform Controller ad hoc commands.
 1│ad_hoc_command_cancel        module     None  False       Cancel an Ad Hoc Command.
 2│ad_hoc_command_wait          module     None  False       Wait for Automation Platform Controller Ad Hoc Command to finish.
 3│application                  module     None  False       create, update, or destroy Automation Platform Controller applications
 4│bulk_host_create             module     None  False       Bulk host create in Automation Platform Controller
 5│bulk_host_delete             module     None  False       Bulk host delete in Automation Platform Controller
 6│bulk_job_launch              module     None  False       Bulk job launch in Automation Platform Controller
 7│controller                   inventory  None  False       Ansible dynamic inventory plugin for the Automation Platform Controller.
 ...
```
Choose `7`:
```bash
Image: awx.awx.controller
Description: Ansible dynamic inventory plugin for the Automation Platform Controller.
 0│---                                                                                                                                                  
 1│additional_information: {}                                                                                                                           
 2│collection_info:                                                                                                                                     
 3│  authors:                                                                                                                                           
 4│  - AWX Project Contributors <awx-project@googlegroups.com>                                                                                          
 5│  dependencies: {}             
  ...
```

{{% /details %}}

### All done?

* Have a look at the [ansible-navigator GitHub page](https://github.com/ansible/ansible-navigator).

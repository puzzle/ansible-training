---
title: 10. Ansible-Navigator
weight: 99
sectionnumber: 10
---

During this lab you will get to know `ansible-navigator`.

### Task 1

* Install all packages needed to use `ansible-navigator` on the controller host.

{{% alert title="Tip" color="info" %}}
  It doesn't matter which container engine you use. Anyways we use podman since its the default.
{{% /alert %}}

* After installing, start `ansible-navigator` and closely observe whats happening. What does the output show you?

### Task 2

Configure ansible-navigator and ensure the following:

* Use the `ansible.cfg` in your local techlab directory
* Use 20 forks
* Enable colorful output
* Log to a file `log.txt` in a subfolder `log` with a loglevel of `INFO`.
* Use the demo execution environment previously downloaded when running a playbook. 
* Create artifacts when running a playbook with `ansible-navigator` and put them in a subfolder `artifacts`. Prefix the name of the artifact-file with the name of the actual playbook.

### Task 3

* Create a playbook `site.yml` that contains two plays. The first play is the same as `webservers.yml` from the labs before and the second play set the content of `/etc/motd` on all hosts of the group `db` to `This is a database server`. Be sure to set a name-keyword for each play. Use "Run tasks on webservers" for the play that runs on the group `web` and "Run tasks on dbservers" for the play that runs on group `db`.

### Task 4 

* Run the playbook `site.yml` by using ansible-navigator and the configuration from Task 2.
* What additional config parameter has to be set in your `ansible.cfg`? If unsure, run the playbook and debug the error. 
* While running the playbook, check in another terminal window if the container gets startet and stopped. You can do this by issuing `watch podman container list` 

### Task 5

* After a successful run of your playbook, we play around with the TUI. Be sure to not let ansible-navigator run in interactive mode and not stdout mode (-m stdout). Since interactive is the default, you shouldn't have any problems with that.
* Inspect the output in the TUI. Navigate to the task in 

### Task 6

Use `ansible-navigator` to see the documentation of:

* the `file` module.
* the `dig` lookup plugin.

### Task 7

* Use `ansible-navigator` to see the current inventory.
* Navigate to `groups`, then `db` and then show all information of node `node2`.

### Task 8

* Use `ansible-navigator` to see the current ansible configuration.

### Task 9

* The run of `site.yml` should have created an artifact file in the folder `artifacts/`.
* Replay the this run by using `ansible-navigator` with the corresponding option.

### Task 10

Use `ansible-navigator` to show all:

* available collections.
* infos about the module `credential` of the `awx.awx` collection.

### All done?

* Have a look at the [ansible-navigator github page](https://github.com/ansible/ansible-navigator)

## Solutions

{{% details title="Solution Task 1" %}}
Since we have no RedHat Subscription available, we install ansible-navigator with pip. We install podman as well to be able to use containers.

```bash
$ sudo dnf install -y podman python3-pip
$ pip3 install ansible-navigator --user
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

{{% details title="Solution Task 2" %}}

```bash
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
    image: ansible-navigator-demo-ee:0.6.0
  logging:
    level: info
    file: logs/log.txt
  playbook-artifact:
    enable: True
    save-as: artifacts/{playbook_name}-artifact.json

```
{{% /details %}}

{{% details title="Solution Task 3" %}}
```bash
$ cat site.yml 
---
- name: Run tasks on webservers
  hosts: web
  become: true
  tasks:
    - name: install httpd
      yum:
        name: httpd
        state: installed
    - name: start and enable httpd
      service:
        name: httpd
        state: started
        enabled: yes
    - name: start and enable firewalld
      service:
        name: firewalld
        state: started
        enabled: yes
    - name: open firewall for http
      firewalld:
        service: http
        state: enabled
        permanent: yes
        immediate: yes
- name: Run tasks on dbservers
  hosts: db
  become: true
  tasks:
    - name: prepare motd
      copy:
        dest: /etc/motd
        content: "This is a database server"
```
{{% /details %}}

{{% details title="Solution Task 4" %}}
```bash
$ ansible-navigator run site.yml
```
Set `remote_user` to `ansible` in the ansible configuration. Otherwise, the EE would use user root to connect to the hosts.
```bash
$ grep remote_user ansible.cfg 
remote_user = ansible
```
See the running container:
```bash
$ watch podman container list

Every 2.0s: podman container list                                       phippu-controller: Sun Apr  3 08:12:20 2022
CONTAINER ID  IMAGE	                                       COMMAND               CREATED        STATUS
   PORTS       NAMES
ae762caaa21  quay.io/ansible/ansible-navigator-demo-ee:0.6.0  ansible-playbook ...  9 seconds ago  Up 9 seconds ag
o              ansible_runner_afb92a4e-3281-4928-986a-cbb84c999be7
```
{{% /details %}}

{{% details title="Solution Task 5" %}}

```bash
$ ansible-navigator run site.yml -m interactive
```
Note that `-m interactive` is not needed unless you configured the mode to `stdout` explicitly in your `ansible-navigator.yml` config file.

```bash
  PLAY NAME               OK CHANGED UNREACHABLE FAILED SKIPPED IGNORED IN PROGRESS TASK COUNT   PROGRESS
0│Run tasks on webservers  5       0           0      0       0       0           0          5   COMPLETE
1│Run tasks on dbservers   2       0           0      0       0       0           0          2   COMPLETE
```
Choose `0` to inspect the tasks that run on the hostgroup `web`

```bash
  RESULT HOST  NUMBER CHANGED  TASK                         TASK ACTION   DURATION
0│OK     node1      0   False  Gathering Facts              gather_facts	2s
1│OK     node1      1   False  install httpd                yum			2s
2│OK     node1      2   False  start and enable httpd       service		1s
3│OK     node1      3   False  start and enable firewalld   service		0s
4│OK     node1      4   False  open firewall for http       firewalld		1s
```
Choose `4` to inspect the task for setting firewall rules

```bash
PLAY [Run tasks on webservers:4] *************************************************************************
TASK [open firewall for http] ****************************************************************************
OK: [node1] Permanent and Non-Permanent(immediate) operation                                              
 0│---
 1│duration: 1.350668
 2│end: '2022-04-03T09:37:20.155703'
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
23│	 rich_rule: null
24│	 service: http
25│	 source: null
26│	 state: enabled
27│	 target: null
28│	 timeout: 0
29│	 zone: null
30│  msg: Permanent and Non-Permanent(immediate) operation
31│start: '2022-04-03T09:37:18.805035'
32│task: open firewall for http
33│task_action: firewalld
34│task_args: ''
35│task_path: /home/ansible/techlab/site.yml:20
```
Here you can find a lot of details about the task. Note that you can switch between tasks when pressing the numbers from the play summary. In this case this would be the numbers from `0` to `4`.

{{% /details %}}

{{% details title="Solution Task 6" %}}

Attention! Be sure to use an EE that contains the needed documentation. If thats not the case, just switch to not using any EE with the option `--ee false`
```bash
$ ansible-navigator doc file
$ ansible-navigator doc -t lookup dig --ee false
```
{{% /details %}}

{{% details title="Solution Task 7" %}}
Note that when inspecting an inventory you have to name it explicitely even when you have it configured in your `ansible.cfg`.
```bash
$ ansible-navigator inventory -i inventory/hosts
```
Navigate trough the inventory and see what information you can find. For example show all information about the hosts in group `db`:

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

{{% details title="Solution Task 8" %}}
```bash
$ ansible-navigator config
```
```bash
    OPTION                      DEFAULT SOURCE  VIA                         CURRENT VALUE
  0│ACTION_WARNINGS                True default default                     True 			 
  1│AGNOSTIC_BECOME_PROMPT         True default default                     True                         
  2│ALLOW_WORLD_READABLE_TMPFILE   True default default                     False                        
  3│ANSIBLE_CONNECTION_PATH        True default default                     None                         
  4│ANSIBLE_COW_ACCEPTLIST         True default default                     ['bud-frogs', 'bunny', 'chees...
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

{{% details title="Solution Task 9" %}}
```bash
$ ansible-navigator replay artifacts/site-artifact.json
```
Note that no ansible-run is triggered and no container of the EE-image is started.
{{% /details %}}


{{% details title="Solution Task 10" %}}
```bash
$ 
```
```bash
   NAME                    VERSION SHADOWED TYPE      PATH
 0│amazon.aws              1.5.0      False contained /usr/share/ansible/collections/ansible_collections/
 1│ansible.posix           1.2.0      False contained /usr/share/ansible/collections/ansible_collections/
 2│ansible.windows         1.7.1      False contained /usr/share/ansible/collections/ansible_collections/
 3│awx.awx                 19.2.2     False contained /usr/share/ansible/collections/ansible_collections/
 4│azure.azcollection      1.8.0      False contained /usr/share/ansible/collections/ansible_collections/
 5│community.vmware        1.12.0     False contained /usr/share/ansible/collections/ansible_collections/
 6│google.cloud            1.0.2      False contained /usr/share/ansible/collections/ansible_collections/
 7│kubernetes.core         2.1.1      False contained /usr/share/ansible/collections/ansible_collections/
 8│openstack.cloud         1.5.0      False contained /usr/share/ansible/collections/ansible_collections/
 9│ovirt.ovirt             1.5.4      False contained /usr/share/ansible/collections/ansible_collections/
10│redhatinsights.insights 1.0.5      False contained /usr/share/ansible/collections/ansible_collections/
11│theforeman.foreman      2.1.2      False contained /usr/share/ansible/collections/ansible_collections/
```
Choose `3`:
```bash
   AWX.AWX                TYPE      ADDED DEPRECATED DESCRIPTION
 0│ad_hoc_command         module    4.0.0      False create, update, or dest
 1│ad_hoc_command_cancel  module    None       False Cancel an Ad Hoc Comman
 2│ad_hoc_command_wait    module    None       False Wait for Automation Pla
 3│application            module    None       False create, update, or dest
 4│controller             inventory None       False Ansible dynamic invento
 5│controller_api         lookup    None       False Search the API for obje
 6│controller_meta        module    None       False Returns metadata about 
 7│credential             module    None       False create, update, or dest 
 ...
```
Choose `7`:
```bash
AWX.AWX.CREDENTIAL: create, update, or destroy Automation Platform Controller
  0│---                                                                     
  1│additional_information: {}                                              
  2│collection_info:                                                        
  3│  authors:                                                              
  4│  - AWX Project Contributors <awx-project@googlegroups.com>
  5│  dependencies: {}
  ...
```

{{% /details %}}

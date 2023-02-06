---
title: "10.2 Ansible-Runner"
weight: 99
sectionnumber: 10.2
---

In this lab, we will learn about `ansible-runner`, the component of AAP Controller / AWX that actually runs Ansible playbooks.

### Task 1

* Install all packages needed to use `ansible-runner` command line tool on the controller host. (In case of python problems, [have a look at the ansible-builder lab](https://ansible.puzzle.ch/docs/10/01/#task-1).
* Show the help context of the `ansible-runner` command.

{{% details title="Solution Task 1" %}}
Since we have no Red Hat Subscription available, we install ansible-runner with pip. We install podman as well to be able to use containers.

```bash
$ pip3 install ansible-runner --user
...
$ ansible-runner --help
```
Note that `ansible-runner` is already present when you installed `ansible-navigator` in the labs before.
{{% /details %}}

### Task 2

* Set up the folder structure needed by ansible-runner to find your inventory and put your playbook in the correct folder as well.
* Use `ansible-runner` to run the play site.yml from [Lab 10.0 Task 3](https://ansible.puzzle.ch/docs/10/#task-3).

{{% details title="Solution Task 2" %}}
```bash
$ pwd
/home/ansible/techlab
$ tree
.
├── inventory
│   └── hosts
└── project
    └── site.yml

$ ansible-runner run /home/ansible/techlab/ -p site.yml
PLAY [Run tasks on webservers] *************************************************

TASK [Gathering Facts] *********************************************************
ok: [node1]
...
...
...
node1                      : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node2                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
{{% /details %}}

### Task 3

* Add a task to `site.yml` playbook that waits for 120 seconds. The tasks should be at the end of the play running on the web group `web`.
* Use `ansible-runner` cli to run the playbook `site.yml`.
* Have a look at the running process in the `artifacts` directory. Find information about the facts cached for node1.
* Find information about a random job event.
* Show the standard output of the ansible run`

{{% details title="Solution Task 3" %}}
```bash
$ cat site.yml
...
- name: Sleep for 120 seconds
  ansible.builtin.wait_for:
    timeout: 120
...
$ ansible-runner start /home/ansible/techlab/ -p site.yml
$ tree
.
└── 82b7743d-72db-4760-b163-e24257a5ff78
    ├── command
    ├── fact_cache
    │   └── node1
    ├── job_events
    │   ├── 10-8cbb439d-831f-44e7-ad68-d067847efcfd.json
    │   ├── 11-62869478-2c8c-4cac-a566-6e09ca1aa295.json
    │   ├── 12-5a420566-9318-68c2-fc18-00000000000c.json
    │   ├── 13-ba4910c9-1f35-4687-851f-073bd70f96a1.json
    │   ├── 14-4cedb233-fc76-4019-a6ba-e829d3cf25f7.json
    │   ├── 1-54889cf9-5ceb-4541-930f-73fe24d4a08a.json
    │   ├── 15-5a420566-9318-68c2-fc18-00000000000d.json
    │   ├── 16-80f5f3f7-b1b5-4259-aa67-49213495fe5e.json
    │   ├── 17-505f561d-cce5-42b6-a219-eb7e596c8ef9.json
    │   ├── 18-5a420566-9318-68c2-fc18-00000000000e.json
    │   ├── 19-3ab80b71-789b-4e65-9cb4-6b7d76de2729.json
    │   ├── 2-5a420566-9318-68c2-fc18-000000000008.json
    │   ├── 3-5a420566-9318-68c2-fc18-000000000015.json
    │   ├── 4-790fc1a4-c0f8-4b3a-99cc-b4f4239d9a1f.json
    │   ├── 5-49005502-bf17-4a88-ae9e-e25c45588bf6.json
    │   ├── 6-5a420566-9318-68c2-fc18-00000000000a.json
    │   ├── 7-2764164b-0fbd-4c13-b7ce-0671b308640e.json
    │   ├── 8-6f454b56-c99d-4996-9de2-c349953f9970.json
    │   └── 9-5a420566-9318-68c2-fc18-00000000000b.json
    ├── stderr
    └── stdout

3 directories, 23 files
$
```
NOTE: the output of the `tree` command varies depending on when it is run.

```
$ cat 82b7743d-72db-4760-b163-e24257a5ff78/fact_cache/node1
{
    "_ansible_facts_gathered": true,
    "ansible_all_ipv4_addresses": [
        "5.102.147.253"
    ],
    "ansible_all_ipv6_addresses": [
        "fe80::5842:5ff:fe66:93fd"
    ],
    "ansible_apparmor": {
        "status": "disabled"
...
```

```
$ cat artifacts/82b7743d-72db-4760-b163-e24257a5ff78/job_events/1-54889cf9-5ceb-4541-930f-73fe24d4a08a.json
...
```

```
$ cat artifacts/82b7743d-72db-4760-b163-e24257a5ff78/stdout

PLAY [Run tasks on webservers] *************************************************

TASK [Gathering Facts] *********************************************************
ok: [node1]

TASK [install httpd] ***********************************************************
ok: [node1]

TASK [start and enable httpd] **************************************************
ok: [node1]

TASK [start and enable firewalld] **********************************************
ok: [node1]

TASK [open firewall for http] **************************************************
ok: [node1]

TASK [Sleep for 120 seconds] ***************************************************
ok: [node1]

PLAY [Run tasks on dbservers] **************************************************

TASK [Gathering Facts] *********************************************************
ok: [node2]

TASK [prepare motd] ************************************************************
ok: [node2]

PLAY RECAP *********************************************************************
node1                      : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node2                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
{{% /details %}}

### Task 4

Use `ansible-runner` cli to run the playbook `site.yml` inside an execution environment (ee). If you did the `ansible-builder` labs, you can use the ee you created then. Otherwise use `quay.io/ansible/ansible-navigator-demo-ee`. We want to use `podman` to execute the ee and also use process isolation. See `ansible-runner run --help` for which options you have to use.

Since it is run inside a container, we have to specify with which user we want to run Ansible. Default would be the root user which is not a best practice. Also, we add a working ssh_key to the correct location in our directory. This is needed in order to open an ssh-connetion from inside the ee to the managed nodes.

{{% alert title="Tip" color="warn" %}}
If the ee you choose is not present yet, podman will first pull it when running `ansible-runner`. This can take some time.
{{% /alert %}}

* create the needed folder, files and its content for using the ee
* create the needed folder, files and its content for using `ansible` as `remote_user` and the corresponding ssh_key
* run the playbook `site.yml` inside the ee with the `ansible-runner` cli

{{% details title="Solution Task 4" %}}
```bash
$ tree
.
├── env
│   ├── settings
│   └── ssh_key
├── inventory
│   └── hosts
└── project
    └── site.yml

$ cat env/settings
---
container_image: default-ee
process_isolation_executable: podman
process_isolation: true

$ cat /home/ansible/.ssh/id_rsa > env/ssh_key

$ head env/ssh_key 
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAACFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAgEAvAZuI1j7kz+J9bb375jjGdQqqsGc2imuoeTnFOqwLdg6+1LPj9RC
NDE7JpDoTmTRTuEqSyD/CmGawv4tLrOig4Q/sFeV1JsEt9V3fF1s9VJ7VcYq2baSLyrHFQ
...

$ cat project/site.yml
---
- name: Run tasks on webservers
  hosts: web
  become: true
  remote_user: ansible #<-- 
...
- name: Run tasks on dbservers
  hosts: db
  become: true
  remote_user: ansible #<--
...

$ ansible-runner run /home/ansible/techlab/ -p site.yml
Identity added: /runner/artifacts/6fdb3c4d-ee40-4a40-8d6b-57b9a3788d7e/ssh_key_data (Created for convenience ahead of techlab)

PLAY [Run tasks on webservers] *************************************************

TASK [Gathering Facts] *********************************************************
ok: [node1]

...

PLAY RECAP *********************************************************************
node1                      : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node2                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
$
```

{{% alert title="Warning" color="warn" %}}
Not defining `process_isolation_executable: podman` in `env/settings` would lead to `ansible-runner` run our playbook NOT inside an ee. The output however looks almost the same.
{{% /alert %}}

{{% /details %}}

### Task 5

Now we want to have a look at whats happening in the background while running our playbook with `ansible-runner` inside an ee.

* Start your playbook in the background. Use `ansible-runner --help` to see which option you can use.
* While the playbook runs, have look at the running processes with `watch -n1 'ps -ef | grep ansible- | grep -v grep'`
* Also while the playbook runs, have a look at the running containers with `watch -n1 podman ps -a`
* While the playbook still runs, stop it with corresponding option and see how the processes are terminated and the running container stopped.

{{% details title="Solution Task 5" %}}
```bash
$ ansible-runner start /home/ansible/techlab/ -p site.yml
...
$ ansible-runner stop /home/ansible/techlab/ -p site.yml
...
```

{{% /details %}}

### Task 6

Now we want to run our playbook `site.yml` by starting an execution environment with podman and mounting our metadata folder into the correct location inside the ee. Have a look at the [documentation](https://ansible-runner.readthedocs.io/en/stable/container/#using-runner-as-a-container-interface-to-ansible) for help.

{{% alert title="Tip" color="info" %}}
If you have selinux in enforcing mode, remember to relabel the volumes mounted inside the container with `:Z`.
{{% /alert %}}

{{% alert title="Warning" color="warn" %}}
Remove your `podman`-settings in `env/settings`. Otherwise, `ansible-runner` would try to run Ansible inside the container with `podman` again. This would fail since its not installed inside the `ansible-runner` image.
{{% /alert %}}

* Use the ee `default-ee` from before or use `quay.io/ansible/ansible-navigator-demo-ee`. Remember, that an ee is always based on the ansible-runner reference image.
* How do you specify which playbook to run?
* Into which directory inside the container do you have to mount your metadata directory?
* Remove the podman-settings in the file `env/settings`. These settings would cause `ansible-runner` inside the container to try run in podman again. This would fail because podman is not installed inside the ee.
* Run your Ansible project with podman using the ee stated above.

{{% details title="Solution Task 6" %}}

* With the env variable `RUNNER_PLAYBOOK=test.yml`.
* Into the `/runner` directory.
* `$ mv env/settings ../`
* Run it:

```bash
$ podman run --rm -e RUNNER_PLAYBOOK=site.yml -v /home/ansible/techlab:/runner:Z default-ee:latest 
Identity added: /runner/artifacts/cf33c64a-c5cf-41dd-8479-e9c0057d8e8f/ssh_key_data (Created for convenience ahead of techlab)

PLAY [Run tasks on webservers] *************************************************

TASK [Gathering Facts] *********************************************************
ok: [node1]

TASK [install httpd] ***********************************************************
ok: [node1]

TASK [start and enable httpd] **************************************************
ok: [node1]

TASK [start and enable firewalld] **********************************************
ok: [node1]

PLAY [Run tasks on dbservers] **************************************************

TASK [Gathering Facts] *********************************************************
ok: [node2]

TASK [prepare motd] ************************************************************
ok: [node2]

PLAY RECAP *********************************************************************
node1                      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node2                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$
```

{{% /details %}}

### Task 7 (Advanced)

* Why can't you run your `site.yml` playbook with the `quay.io/ansible/ansible-runner` image?

{{% details title="Solution Task 7" %}}
Our playbook contains a tasks that uses the `ansible.posix.firewalld` module. The `ansible-runner` ee contains nothing but `ansible-core`. This means it cannot run the `ansible.posix.firewalld` module because it's not present in `ansible-core`.

You can show the content of the `ansible-builder` ee with `ansible-navigator`:

```bash
ANSIBLE-RUNNER:LATEST (INFORMATION ABOUT ANSIBLE AND ANSIBLE COLLECTIONS)      
0│---
1│ansible:
2│  collections:
3│    details: {}
4│    errors:
5│    - |-
6│      ERROR! - None of the provided paths were usable. Please specify a valid
7│  version:
8│    details: core 2.12.5.post0
```
See the [ansible-navigator lab](https://ansible.puzzle.ch/docs/10/#task-10) about how to get there!

{{% /details %}}

### Task 8

Now we want to run our playbook directly by using the python module `ansible-runner`

* Install the python module `ansible-runner`
* Create a python script `run_ansible_run.py` that runs your playbook `site.yml`
* The script should use `/home/ansible/techlab/` as the ansible metadata directory
* Make the script executable
* Run the script

{{% details title="Solution Task 8" %}}
```bash
$ pip3 install ansible-runner --user

$ cat run_ansible_run.py
#!/usr/bin/python3
import ansible_runner
ansible_runner.run(
        private_data_dir='/home/ansible/techlab/',
        playbook='site.yml')

$ chmod +x run_ansible_run.py

$ ./run_ansible_run.py
Identity added: /home/ansible/techlab/artifacts/5e703775-5234-491c-b958-09bf0bd2e756/ssh_key_data (Created for convenience ahead of techlab)

PLAY [Run tasks on webservers] *************************************************

TASK [Gathering Facts] *********************************************************
ok: [node1]

TASK [install httpd] ***********************************************************
ok: [node1]

TASK [start and enable httpd] **************************************************
ok: [node1]

TASK [start and enable firewalld] **********************************************
ok: [node1]

TASK [open firewall for http] **************************************************
ok: [node1]

TASK [Sleep for 120 seconds] ***************************************************
ok: [node1]

PLAY [Run tasks on dbservers] **************************************************

TASK [Gathering Facts] *********************************************************
ok: [node2]

TASK [prepare motd] ************************************************************
ok: [node2]

PLAY RECAP *********************************************************************
node1                      : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node2                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
$

```
{{% /details %}}

### All done?

* Have a look at the [ansible-runner github page](https://github.com/ansible/ansible-runner)
* Have a look at the [docs of the latest version of ansible-runner](https://ansible-runner.readthedocs.io/en/latest/)

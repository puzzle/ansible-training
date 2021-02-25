---
title: "4.5 - Task control"
weight: 45
sectionnumber: 4.5
---

In this lab we learn about task control.

### Task 1
- Write an ad-hoc command that sleeps for 1000 seconds and runs on `node1`
- Ensure that the command times out after 10 seconds if not completed by then. Run the task.
- Use the `time` command to see how long your ad-hoc command had to run. Use `man time` to see how `time` works.
- Now add a polling interval of 30 seconds. Run the task, and ensure with the `time` command, that it had a longer runtime.
- See what happens if you only specify the polling interval but no async timeout. Tip: set a sleep duration of only 10 seconds.

### Task 2

- Write a playbook `async.yml` that does the same as in the task above:
- Run a command that sleeps for 1000 second and runs on `node1`.
- Let the task wait at most for 10 seconds before timing out.
- Run the task.
 
### Task 3 (Advanced)

In the playbook `async.yml` do the following:
- Put the task above in the background and change the values of the sleepduration, polling intervall ans async time to reasonable values.
- Check back with an `async_status` task if the sleep-task has finished.
- Run the playbook.

{{% alert title="Tip" color="info" %}}
If unsure, check the documentation about [async_status](https://docs.ansible.com/ansible/2.9/modules/async_status_module.html) for an example.
{{% /alert %}}

## Solutions

{{% details title="Task 1" %}}
```bash
$ ansible node1 -i hosts -B 10 -a "/usr/bin/sleep 1000"
node1 | FAILED | rc=-1 >>
async task did not complete within the requested time - 10s
$
$ time ansible node1 -i hosts -B 10 -a "/usr/bin/sleep 1000"
node1 | FAILED | rc=-1 >>
async task did not complete within the requested time - 10s

real	0m17.626s #<- a bit more than 10 seconds
user	0m3.603s
sys	0m0.510s
$ time ansible node1 -i hosts -B 10 -P 30 -a "/usr/bin/sleep 1000"
node1 | FAILED | rc=-1 >>
async task did not complete within the requested time - 10s

real	0m32.625s #<- more than the polling intervall
user	0m5.541s
sys	0m0.684s
$
```
Setting the poll parameter without the async parameter results in the job not beeing put in background.
```bash
$ ansible node1 -i hosts -P 30 -a "/usr/bin/sleep 10"
node1 | CHANGED | rc=0 >>
$
```
{{% /details %}}

{{% details title="Task 2" %}}
```bash
$ cat async.yml 
---
- hosts: node1
  tasks:
    - name: sleeping beauty
      command: "/usr/bin/sleep 1000"
      async: 10

$ ansible-playbook -i hosts async.yml 

PLAY [node1] **************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [node1]

TASK [sleeping beauty] ****************************************************************************************************************************************************************************************
fatal: [node1]: FAILED! => {"changed": false, "msg": "async task did not complete within the requested time - 10s"}

PLAY RECAP ****************************************************************************************************************************************************************************************************
node1                      : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

$
```

{{% /details %}}

{{% details title="Task 3" %}}
```bash
$ cat async.yml 
---
- hosts: node1
  tasks:
    - name: sleeping beauty
      command: "/usr/bin/sleep 30"
      async: 60
      poll: 0
      register: sleepingbeauty

    - name: check back if task in background has finished
      async_status:
        jid: '{{ sleepingbeauty.ansible_job_id }}'
      register: beauty_status
      until: beauty_status.finished
      retries: 50

$ ansible-playbook -i hosts async.yml 

PLAY [node1] **************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [node1]

TASK [sleeping beauty] ****************************************************************************************************************************************************************************************
changed: [node1]

TASK [check back if task in background has finished] **********************************************************************************************************************************************************
FAILED - RETRYING: check back if task in background has finished (50 retries left).
FAILED - RETRYING: check back if task in background has finished (49 retries left).
FAILED - RETRYING: check back if task in background has finished (48 retries left).
FAILED - RETRYING: check back if task in background has finished (47 retries left).
FAILED - RETRYING: check back if task in background has finished (46 retries left).
FAILED - RETRYING: check back if task in background has finished (45 retries left).
changed: [node1]

PLAY RECAP ****************************************************************************************************************************************************************************************************
node1                      : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$
```
{{% /details %}}

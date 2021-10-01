---
title: "9.1 AWX Installation"
weight: 91
sectionnumber: 9.1
---

AWX only supports containerized installations via OpenShift, Kubernetes or Docker Compose. We have chosen to use Docker Compose to run AWX on `control0` in this techlab.

CentOS 8 doesn't provide an easy way to install AWX -- we have to solve some problems first:

* According to [AWX issue 3998](https://github.com/ansible/awx/issues/3998) the current  AWX version relies on native Docker and cannot be deployed with Podman.
* Our techlab infrastructure is based on CentOS 8 which does not include Docker by default.
* Even with the official [Docker CE repository](https://download.docker.com/linux/centos/docker-ce.repo) the `docker-ce` package cannot be installed due to version conflicts with the `containerd.io` package.
* A possible solution is to install an older version of Docker CE using `yum install` with the `--nobest` switch.
* As this swith is not supported by Ansible's `yum` module we need to create some "hacks" with the `command` module.

### Task 1

* Create a playbook `prepare_for_awx.yml` that should run on the controller node.
* That playbook should first check that at least 4GB of main memory are available on the machine `control0`.
* It should than install the following packages: `epel-release`,  `git` and  `python3-pip`.
          
### Task 2

* Extend `prepare_for_awx.yml`:
  * It should add the Docker CE repository https://download.docker.com/linux/centos/docker-ce.repo to `/etc/yum.repos.d/`
  * Install `docker-ce` by running `yum -y install --nobest docker-ce` in a `command` module.
  * To make this idempotend, first check if it is already installed. Take care to return proper "changed" info. Use the `command` module.
  * Start and enable `dockerd`.
  * Add the user `ansible` to the `docker` group.

### Task 3

* Extend `prepare_for_awx.yml`:
  * Install Docker Compose via the Python package manager (pip).
  * Use the  Ansible module `pip`.

### Task 4

* Extend `prepare_for_awx.yml`:
  * Clone the AWX source from [GitHub](https://github.com/ansible/awx.git).
  * Use Ansible's `git` module to store the cloned repo under `/home/ansible/techlab/awx/`.
  * Choose a dedicaded version (i.e. 14.0.0), take a look at [AWX Releases]/https://github.com/ansible/awx/releases) for the current stable version.
  * Make sure that the directory with the AWX sources is readable and writable by the user `ansible`.

### Task 5

* Activate the docker group for current user: Log out and log in again as user `ansible` to `control0`.
* Change directry to `/home/ansible/techlab/awx/installer`
* Optional: Edit the file `inventory` and change the values of `admin_user` and `admin_password` (or keep the defaults: "admin" and "password").
* Run the installer: `ansible-playbook -i inventory install.yml`
* With your Web Browser connect to http://<IP of control0>. You should see a login form and be able to log in.

## Solutions
{{% details title="Task 1" %}}
```bash
$ cat prepare_for_awx.yml
---
- name: prepare for awx installation
  hosts: controller
  become: yes
  tasks:
    - name: check that at least 4GB are available
      fail:
      when: ansible_memtotal_mb < 3900
    - name: install required software
      yum:
        name:
          - epel-release
          - git
          - python3-pip
        state: latest
```
{{% /details %}}

{{% details title="Task 2" %}}
```bash
$ cat prepare_for_awx.yml
---
    ...
    ...
    ...
    - name: add the Docker CE repository
      get_url:
        url: https://download.docker.com/linux/centos/docker-ce.repo
        dest: /etc/yum.repos.d/docker-ce.repo
    - name: check if docker-ce is already installed
      command: rpm -qi docker-ce
      register: rpm_out
      ignore_errors: true
      changed_when: false
    - name: install docker-ce
      command: yum -y install --nobest docker-ce
      when: rpm_out.rc != 0
    - name: start and enable dockerd
      service:
        name: docker
        enabled: yes
        state: started
    - name: add the user ansible to the docker group
      user:
        name: ansible
        groups: docker
        append: yes
```
{{% /details %}}

{{% details title="Task 3" %}}
```bash
$ cat prepare_for_awx.yml
    ...
    ...
    ...
    - name: install Docker Compose via the Python package manager
      pip:
        name: docker-compose
```
{{% /details %}}

{{% details title="Task 4" %}}
```bash
$ cat prepare_for_awx.yml
    ...
    ...
    ...
    - name: clone the AWX sources
      git:
        repo: https://github.com/ansible/awx.git
        dest: /home/ansible/techlab/awx
        version: 14.0.0
      become: no
```
{{% /details %}}


{{% details title="Task 5" %}}
```bash
$ logout 
Connection to 192.168.122.30 closed.
$ ssh ansible@192.168.122.30
ansible@192.168.122.30's password: ********
...
$ groups
ansible docker
$ cd /home/ansible/techlab/awx/installer/
$ vim inventory #  change admin_user and admin_password
$ ansible-playbook -i inventory install.yml

PLAY [Build and deploy AWX] ******************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]

TASK [check_vars : include_tasks] ************************************************************************************************************************************************************
skipping: [localhost]
...
...
...
TASK [local_docker : Start the containers] ***************************************************************************************************************************************************
changed: [localhost]

TASK [local_docker : Update CA trust in awx_web container] ***********************************************************************************************************************************
changed: [localhost]

TASK [local_docker : Update CA trust in awx_task container] **********************************************************************************************************************************
changed: [localhost]

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=16   changed=8    unreachable=0    failed=0    skipped=86   rescued=0    ignored=0   
```

Go to http://192.168.122.30 and enter admin name and password:

![AWX Login](awx001.png)
{{% /details %}}

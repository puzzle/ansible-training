---
title: 8. Ansible Collections
weight: 80
sectionnumber: 8
---

In this lab we are going to learn how to use Ansible collections.

### Task 1

* Create a collection with the `ansible-galaxy collection` command. Choose a namespace and a collection name of your liking.
* Have a look at what folders have been created.

{{% details title="Solution Task 1" %}}
```bash
$ pwd
/home/ansible/techlab
$ ansible-galaxy collection init puzzle.ansible_techlab
- Collection puzzle.ansible_techlab was created successfully
$ tree
.
├── ansible.cfg
├── collections.yml
├── hosts
├── puzzle
│   └── ansible_techlab
│       ├── docs
│       ├── galaxy.yml
│       ├── plugins
│       │   └── README.md
│       ├── README.md
│       └── roles
└── requirements.yml

5 directories, 7 files
[ansible@master-controller techlab]$
```
{{% /details %}}

### Task 2

* Build a collection from your newly initialized collection-skeleton. Have a close look at the name that was set.
* Change the namespace and collection name in the file `galaxy.yml` in the skeleton.
* Rebuild the collection and see the new name.

{{% alert title="Tip" color="info" %}}
Check the [dev guide](https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html) for details about the structure of a collection and the content of the galaxy.yml file.

The information about the place of the playbook is not complete yet. Just try... 😉
{{% /alert %}}

{{% details title="Solution Task 2" %}}

```bash
$ ansible-galaxy collection build puzzle/ansible_techlab/
Created collection for puzzle.ansible_techlab at /home/ansible/techlab/puzzle-ansible_techlab-1.0.0.tar.gz

$ vim /home/ansible/techlab/puzzle/ansible_techlab/galaxy.yml

$ grep ^name /home/ansible/techlab/puzzle/ansible_techlab/galaxy.yml
namespace: newpuzzle
name: ansible_techlab2

$ ansible-galaxy collection build puzzle/ansible_techlab/
Created collection for newpuzzle.ansible_techlab2 at /home/ansible/techlab/newpuzzle-ansible_techlab2-1.0.0.tar.gz
```
{{% /details %}}

### Task 3

* Install one of your newly built collections from the `tar.gz` file. See where it was installed.
* Have a look at the ansible configuration and figure out why it was installed there.

{{% alert title="Tip" color="info" %}}
With `ansible-config dump` you can even see the default configuration values not explicitly set 
in the `ansible.cfg` file. Look for `COLLECTIONS_PATHS`.
{{% /alert %}}

* Change the ansible configuration so that the collection gets installed at `/home/ansible/techlab/collections`.
* Reinstall the `tar.gz` file of the collection and verify the new location.

{{% alert title="Tip" color="info" %}}
Note the subfolder `ansible-collections` that was created. This is default ansible behavior.
{{% /alert %}}

{{% details title="Solution Task 3" %}}
```bash
$ ansible-galaxy collection install puzzle-ansible_techlab-1.0.0.tar.gz
Process install dependency map
Starting collection install process
Installing 'puzzle.ansible_techlab:1.0.0' to '/home/ansible/.ansible/collections/ansible_collections/puzzle/ansible_techlab'

$ ansible-config dump | grep COLLECTIONS_PATHS
COLLECTIONS_PATHS(default) = [u'/home/ansible/.ansible/collections', u'/usr/share/ansible/collections']

$ vim ansible.cfg
$ grep "\[defaults\]" -A1 ansible.cfg
[defaults]
collections_paths = /home/ansible/techlab/collections

$ ansible-galaxy collection install puzzle-ansible_techlab-1.0.0.tar.gz
Process install dependency map
Starting collection install process
Installing 'puzzle.ansible_techlab:1.0.0' to '/home/ansible/techlab/collections/ansible_collections/puzzle/ansible_techlab'
```
{{% /details %}}

### Task 4

* Use `ansible-config dump` to see what default galaxy server is configured
* Add another galaxy server to your `GALAXY_SERVER_LIST`. This entry can point to a nonexistent galaxy server.
* Set it explicitly to `galaxy.ansible.com` in the `ansible.cfg` file, even though this is the default value.
* Review the setting with `ansible-config dump`.

{{% details title="Solution Task 4" %}}
```bash

$ ansible-config dump | grep -i galaxy_server
GALAXY_SERVER(default) = https://galaxy.ansible.com
GALAXY_SERVER_LIST(default) = None
```
Add the following block to your `/home/ansible/techlab/ansible.cfg`:
```
[galaxy]
server_list = puzzle_galaxy

[galaxy_server.puzzle_galaxy]
url = https://galaxy.ansible.com

$ ansible-config dump | grep GALAXY_SERVER
GALAXY_SERVER(default) = https://galaxy.ansible.com
GALAXY_SERVER_LIST(/home/ansible/techlab/ansible.cfg) = ['puzzle_galaxy']
[ansible@master-controller techlab]$
```
{{% /details %}}

### Task 5

* Install the collection `nginx_controller`,
provided by the company NGINX (`nginxinc.nginx_controller`) using the `ansible-galaxy` command.
* Write a requirements file `requirements.yml` that ensures the collection `cloud` from `cloudscale_ch` is installed.
Install the collection by using this requirements file.

{{% details title="Solution Task 5" %}}
```bash
$ ansible-galaxy collection install nginxinc.nginx_controller
Process install dependency map
Starting collection install process
Installing 'nginxinc.nginx_controller:3.7.5' to '/home/ansible/techlab/collections/ansible_collections/nginxinc/nginx_controller'

$ cat requirements.yml
collections:
- name: cloudscale_ch.cloud

$ ansible-galaxy collection install -r requirements.yml
Process install dependency map
Starting collection install process
Installing 'cloudscale_ch.cloud:1.0.0' to '/home/ansible/techlab/collections/ansible_collections/cloudscale_ch/cloud'
```
{{% /details %}}

### Task 6

* Install the collection `podman` from namespace `containers` using any of the methods you know.
* Write a playbook `collection.yml` that runs only on the controller and uses the `podman`
collection from the namespace `containers`.
* The playbook should install podman on the controller and pull any podman image.
Be sure to escalate privileges if needed. (Use the image `quay.io/bitnami/nginx` if unsure).
* Use the module `podman_container` to start a container from the previously pulled image.
* Confirm the container is up and running using `sudo podman ps -l`.

{{% details title="Solution Task 6" %}}
```bash
$ ansible-galaxy collection install containers.podman
Process install dependency map
Starting collection install process
Installing 'containers.podman:1.1.4' to '/home/ansible/techlab/collections/ansible_collections/containers/podman'

$ cat collections.yml
---
- name: example for using modules from a collection
  become: true
  hosts: controller
  collections:
    - containers.podman
  tasks:
    - name: install podman
      ansible.builtin.dnf:
        name: podman
        state: installed

    - name: Pull an image using the module from the collection
      containers.podman.podman_image:
        pull: true
        name: quay.io/bitnami/nginx

    - name: Run nginx container
      containers.podman.podman_container:
        name: my_nginx_container
        image: nginx
        state: present
        publish:
          - '8080'
```
OR:
```bash
$ cat collections.yml
---
- name: example for using modules from a collection
  become: true
  hosts: controller
  tasks:
    - name: install podman
      ansible.builtin.dnf:
        name: podman
        state: installed

    - name: Pull an image using the module from the collection
      containers.podman.podman_image:
        pull: true
        name: quay.io/bitnami/nginx

    - name: Run nginx container
      containers.podman.podman_container:
        name: my_nginx_container
        image: nginx
        state: present
        publish:
          - '8080'
```
This would not work, since the module `podman_container`
is only content of the collection and not part of the ansible-base installation:
```bash
$ cat collections.yml
---
- name: example for using modules from a collection
  become: true
  hosts: controller
  tasks:
    - name: install podman
      ansible.builtin.dnf:
        name: podman
        state: installed

    - name: Pull an image using the module from the collection
      containers.podman.podman_image:
        pull: true
        name: quay.io/bitnami/nginx

    - name: Run nginx container
      podman_container:
        name: my_nginx_container
        image: nginx
        state: present
        publish:
          - '8080'

$ ansible-playbook -i hosts collections.yml
ERROR! couldn't resolve module/action 'podman_container'.
This often indicates a misspelling, missing collection, or incorrect module path.

The error appears to be in '/home/ansible/techlab/collections.yml': line 16, column 7, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:


    - name: Run nginx container
      ^ here
```

Check the running container:

```bash
$ sudo podman ps -l
CONTAINER ID  IMAGE                         COMMAND               CREATED             STATUS                 PORTS                                  NAMES
00783ec12950  quay.io/bitnami/nginx:latest  /opt/bitnami/scri...  About a minute ago  Up About a minute ago  8443/tcp, 0.0.0.0:32771->8080/tcp      my_nginx_container
```
You can even connect to your container using a dynamically assigned port
(32771 in the example above) on your host machine. Make sure to adjust the port in the `curl` command-line accordingly:
```bash
$ curl -s http://localhost:32771 | grep title
<title>Welcome to nginx!</title>
```
{{% /details %}}

### Task 7

* Remove podman with an ad-hoc command to not interfere with the next labs.

{{% details title="Solution Task 7" %}}
```bash
ansible localhost -b -m ansible.builtin.dnf -a"name=podman, state=absent"
```
{{% /details %}}

### All done?

* [What led to ansible collections and reorganization of the community?](https://www.ansible.com/blog/thoughts-on-restructuring-the-ansible-project)

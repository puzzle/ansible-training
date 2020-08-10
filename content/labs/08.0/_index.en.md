---
title: "8.0 - Ansible Collections"
weight: 70
---

In this lab we are going to learn how to use Ansible collections.

### Task 1

- Create a collection with the `ansible-galaxy collection` command. Choose a namespace and a collection name of your liking.
- Have a look at what folders have been created.

### Task 2

- Build a collection from your newly initialized collection-skeleton. Have a close look at the name that was set.
- Change the namespace and collection name in the file `galaxy.yml` in the skeleton.
- Rebuild the collection and see the new name.

{{% notice tip %}}
Check the [dev guide](https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html) for details about the structure of a collection and the content of the galaxy.yml file. The information about the place of the playbook is not complete yet. Just try... :-)
{{% /notice %}}

### Task 3

- Install one of your newly build collections from the `tar.gz` file. See where it was installed.
- Have a look at the ansible configuration and figure out why it was installed there.

{{% notice tip %}}
With `ansible-config dump` you can even see the default configuration values not explicitly set in the `ansible.cfg` file. Look for `COLLECTIONS_PATHS`.
{{% /notice %}}

- Change the ansible configuration so that the collection gets installed at `/home/ansible/techlab/collections`.
- Reinstall the `tar.gz` file of the collection and verify the new location. 
{{% notice tip %}}
Note the subfolder `ansible-collections` that was created. This is default ansible behavior.
{{% /notice %}}

### Task 4

- Use `ansible-config dump` to see what default galaxy server is configured
- Add another galaxy-server to your GALAXY_SERVER_LIST. This entry can point to a nonexistent galaxy-server.
- Set it explicitly to `galaxy.ansible.com` in the `ansible.cfg` file, even though this is the default value.
- Review the setting with `ansible_config dump`


### Task 5

- Install the collection `nginx_controller` from nginx incorporation (nginxinc.nginx_controller) using the `ansible-galaxy` command.
- Write a requirements-file `requirements.yml` that ensures the collection `cloud` from `cloudscale_ch` is installed. Install the collection by using this requirements-file.



### Task 6
- Install the collection `podman` from namespace `containers` using any of the methods you know.
- Write a playbook `collection.yml` that runs only on the controller and uses the `podman` collection from the namespace `containers`.
- The playbook should install podman on the controller and pull any podman image. Be sure to escalate privileges if needed. (Use the image `quay.io/bitnami/nginx` if unsure).
- Use the module `podman_container` to start a container from the previously pulled image.
- Confirm the container is up and running using `sudo podman ps -l`.


## Solutions
{{% collapse solution-1 "Solution 1" %}}
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
│   └── ansible_techlab
│       ├── docs
│       ├── galaxy.yml
│       ├── plugins
│       │   └── README.md
│       ├── README.md
│       └── roles
└── requirements.yml

5 directories, 7 files
[ansible@master-controller techlab]$
```
{{% /collapse %}}

{{% collapse solution-2 "Solution 2" %}}

```bash
$ ansible-galaxy collection build puzzle/ansible_techlab/
Created collection for puzzle.ansible_techlab at /home/ansible/techlab/puzzle-ansible_techlab-1.0.0.tar.gz

$ vim /home/ansible/techlab/puzzle/ansible_techlab/galaxy.yml

$ grep ^name /home/ansible/techlab/puzzle/ansible_techlab/galaxy.yml 
namespace: newpuzzle
name: ansible_techlab2

$ ansible-galaxy collection build puzzle/ansible_techlab/
Created collection for newpuzzle.ansible_techlab2 at /home/ansible/techlab/newpuzzle-ansible_techlab2-1.0.0.tar.gz
$
```
{{% /collapse %}}

{{% collapse solution-3 "Solution 3" %}}
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
{{% /collapse %}}

{{% collapse solution-4 "Solution 4" %}}
```bash

$ ansible-config dump | grep -i galaxy_server
GALAXY_SERVER(default) = https://galaxy.ansible.com
GALAXY_SERVER_LIST(default) = None
$
```
Add the following block to your `/home/ansible/techlab/ansible.cfg`:
```
[galaxy]
server_list = puzzle_galaxy

[galaxy_server.puzzle_galaxy]
url = https://galaxy.ansible.com

$ ansible-config dump | grep GALAXY_SERVER
GALAXY_SERVER(default) = https://galaxy.ansible.com
GALAXY_SERVER_LIST(/home/ansible/techlab/ansible.cfg) = [u'puzzle_galaxy']
[ansible@master-controller techlab]$
```
{{% /collapse %}}

{{% collapse solution-5 "Solution 5" %}}
```bash
$ ansible-galaxy collection install nginxinc.nginx_controller
Process install dependency map
Starting collection install process
Installing 'nginxinc.nginx_controller:3.7.5' to '/home/ansible/techlab/collections/ansible_collections/nginxinc/nginx_controller'
$
$ cat requirements.yml 
collections:
- name: cloudscale_ch.cloud
$
$ ansible-galaxy collection install -r requirements.yml 
Process install dependency map
Starting collection install process
Installing 'cloudscale_ch.cloud:1.0.0' to '/home/ansible/techlab/collections/ansible_collections/cloudscale_ch/cloud'
$
{{% /collapse %}}

{{% collapse solution-6 "Solution 6" %}}
```bash
$ $ ansible-galaxy collection install containers.podman
Process install dependency map
Starting collection install process
Installing 'containers.podman:1.1.4' to '/home/ansible/techlab/collections/ansible_collections/containers/podman'
$
$ cat collections.yml 
---
- name: example for using modules from a collection
  become: yes
  hosts: controller
  collections:
    - containers.podman
  tasks:
    - name: install podman
      yum:
        name: podman
        state: installed

    - name: Pull an image using the module from the collection
      podman_image:
        pull: yes
        name: quay.io/bitnami/nginx

    - name: Run nginx container
      podman_container:
        name: my_nginx_container
        image: nginx
        state: present
        expose:
          - '80'
$
```
OR:
```bash
$ cat collections.yml 
---
- name: example for using modules from a collection
  become: yes
  hosts: controller
  tasks:
    - name: install podman
      yum:
        name: podman
        state: installed

    - name: Pull an image using the module from the collection
      containers.podman.podman_image:
        pull: yes
        name: quay.io/bitnami/nginx

    - name: Run nginx container
      containers.podman.podman_container:
        name: my_nginx_container
        image: nginx
        state: present
        expose:
          - '80'
$
```
This would not work, since the module podman_container is only content of the collection and not part of the ansible-base installation:
```bash
$ cat collections.yml 
---
- name: example for using modules from a collection
  become: yes
  hosts: controller
  tasks:
    - name: install podman
      yum:
        name: podman
        state: installed

    - name: Pull an image using the module from the collection
      podman_image:
        pull: yes
        name: quay.io/bitnami/nginx

    - name: Run nginx container
      podman_container:
        name: my_nginx_container
        image: nginx
        state: present
        expose:
          - '80'
$
$ ansible-playbook -i hosts collections.yml 
ERROR! couldn't resolve module/action 'podman_container'. This often indicates a misspelling, missing collection, or incorrect module path.

The error appears to be in '/home/ansible/techlab/collections.yml': line 16, column 7, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:


    - name: Run nginx container
      ^ here
$
```

Check the running container:

```bash
]$ sudo podman ps -l
CONTAINER ID  IMAGE                         COMMAND               CREATED             STATUS                 PORTS  NAMES
00783ec12950  quay.io/bitnami/nginx:latest  /opt/bitnami/scri...  About a minute ago  Up About a minute ago         my_nginx_container
$
```
You can even connect to your container on port 80, using the podman-interface shown by the `ip a` command (`cni-podman0` in our case). A warning is shown because of the unverified certificate, but connection to port 80 on the container works:
```bash
$ ip a | grep -A2 podman
3: cni-podman0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 66:8c:38:9e:30:54 brd ff:ff:ff:ff:ff:ff
    inet 10.88.0.1/16 brd 10.88.255.255 scope global cni-podman0
$ wget 10.88.0.1:80 --no-check-certificate
--2020-08-10 13:41:16--  http://10.88.0.1/
Connecting to 10.88.0.1:80... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://10.88.0.1/ [following]
--2020-08-10 13:41:16--  https://10.88.0.1/
Connecting to 10.88.0.1:443... connected.
WARNING: cannot verify 10.88.0.1's certificate, issued by ‘/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3’:
  Unable to locally verify the issuer's authority.
    WARNING: certificate common name ‘*.xip.puzzle.ch’ doesn't match requested host name ‘10.88.0.1’.
HTTP request sent, awaiting response... 401 Unauthorized
Authorization failed.
$
```

{{% /collapse %}}

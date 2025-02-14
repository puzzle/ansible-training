---
title: "10.1 Ansible-Builder"
weight: 101
sectionnumber: 10.1
---

In this lab, we will use `ansible-builder` to build our own execution environment.

### Task 1

* Ensure to have a new version of python installed.
`ansible-builder` is developing quickly and chances are that you cannot run it with
a python version that's not rather new.
* Install all packages needed to use `ansible-builder` on the controller host.

{{% details title="Solution Task 1" %}}
Since we have no Red Hat Subscription available, we install ansible-builder with pip.
We install podman as well to be able to use containers.

Update python if needed: <!-- TODO: Maybe we should install something newer than python 3.9? -->
```bash
$ sudo dnf module install -y python39
$ sudo dnf module enable python39
$ sudo alternatives --config python3

There are 2 programs which provide 'python3'.

  Selection    Command
-----------------------------------------------
*+ 1           /usr/bin/python3.6
   2           /usr/bin/python3.9

Enter to keep the current selection[+], or type selection number: 2
$ python3 --version
Python 3.9.13
```

Install `ansible-builder` AFTER you ensured the newer python version to be present.
```bash
$ sudo dnf install -y podman python3-pip
$ pip3 install ansible-builder --user
...
```
{{% /details %}}

### Task 2

* Create a playbook `container.yml` that installs `podman` and pulls the image
`docker.io/bitnami/mariadb` on all `db` servers.
* Run this playbook and observe how it fails because the collection `containers.podman`
is not available in the demo EE `ansible-navigator-demo-ee`.
* For the remainder of this lab, we build our own execution environment containing the collection `containers.podman`.

{{% details title="Solution Task 2" %}}
```bash
$ cat container.yml 
---
- name: test ee with containers.podman collection
  hosts: db
  become: true
  tasks:
  - name: Install podman
    ansible.builtin.dnf:
      name: podman
      state: present
  - name: Pull an image
    containers.podman.podman_image:
      name: docker.io/bitnami/mariadb

$ ansible-navigator run container.yml

            WARNING
            ──────────────────────────────────────────────────────────────────────────────────
            Errors were encountered while running the playbook:
            ERROR! couldn't resolve module/action 'containers.podman.podman_image'. This often
            indicates a misspelling, missing collection, or incorrect module path....
            [HINT] To see the full error message try ':stdout'
            [HINT] After it's fixed, try to ':rerun' the playbook
            ──────────────────────────────────────────────────────────────────────────────────
                                                                                         Ok 
```
{{% /details %}}

### Task 3

Create a new execution environment with the name `default-ee`.
You can find information about the needed configuration files in the [official documentation of ansible-builder](https://ansible-builder.readthedocs.io/en/stable/definition.html#execution-environment-definition).
If you have a Red Hat account, you have access to their [ansible-builder guide](https://access.redhat.com/documentation/en-us/red_hat_ansible_automation_platform/2.1/html/ansible_builder_guide/index).

The new EE should:

* be based on the latest stable version of the `ansible-runner` image from `https://quay.io`
* use the `ansible.cfg` in the `techlab` folder
* contain the `pyfiglet` python3 module
* contain the collection `containers.podman` and `ansible.posix`

{{% details title="Solution Task 3" %}}
```bash
$ cat default-ee.yml 
version: 1
build_arg_defaults:
  EE_BASE_IMAGE: "quay.io/ansible/ansible-runner:latest"
  ANSIBLE_GALAXY_CLI_COLLECTION_OPTS: "-c"
ansible_config: 'ansible.cfg'
dependencies:
    python: requirements.txt
    galaxy: requirements.yml

$ cat requirements.txt 
pyfiglet

$ cat requirements.yml 
collections:
  - containers.podman
  - ansible.posix
```
{{% /details %}}

### Task 4

* Build the new execution environment with the files from the last task.
The resulting image should have a name of `default-ee`. This will take a few minutes.
* With the option for very verbose (`-v3`) set, you can observe what `ansible-builder` does in the background.

If you are interested in the details about how the execution environment is built:

* Have a look at the newly created folder `context/` and see the files created there.
* Have a look at your local podman registry and see, the images downloaded for creating your EE.

{{% alert title="Tip" color="info" %}}
If the creation fails due to "no space left on device", remove unneeded images.
For example, you could remove the demo EE `ansible-navigator-demo-ee` installed by `ansible-navigator`
(`podman rmi quay.io/ansible/.ansible-navigator-demo-ee:0.6.0`).
{{% /alert %}}

{{% details title="Solution Task 4" %}}
```bash
$ ansible-builder build -f default-ee.yml -v3 -t default-ee
...
Complete! The build context can be found at: /home/ansible/techlab/context
$ podman image list --filter reference=default-ee
localhost/default-ee             latest      04a2ff8e9e37  About an hour ago  830 MB

$ tree context/
context/
├── _build
│   ├── ansible.cfg
│   ├── requirements.txt
│   └── requirements.yml
└── Containerfile

1 directory, 4 files

$ cat context/Containerfile 
ARG EE_BASE_IMAGE=quay.io/ansible/ansible-runner:latest
ARG EE_BUILDER_IMAGE=quay.io/ansible/ansible-builder:latest

FROM $EE_BASE_IMAGE as galaxy
ARG ANSIBLE_GALAXY_CLI_COLLECTION_OPTS=-c
USER root

ADD _build/ansible.cfg ~/.ansible.cfg

ADD _build /build
WORKDIR /build

RUN ansible-galaxy role install -r requirements.yml --roles-path /usr/share/ansible/roles
RUN ansible-galaxy collection install $ANSIBLE_GALAXY_CLI_COLLECTION_OPTS -r requirements.yml --collections-path /usr/share/ansible/collections

FROM $EE_BUILDER_IMAGE as builder

COPY --from=galaxy /usr/share/ansible /usr/share/ansible

ADD _build/requirements.txt requirements.txt
RUN ansible-builder introspect --sanitize --user-pip=requirements.txt --write-bindep=/tmp/src/bindep.txt --write-pip=/tmp/src/requirements.txt
RUN assemble

FROM $EE_BASE_IMAGE
USER root

COPY --from=galaxy /usr/share/ansible /usr/share/ansible

COPY --from=builder /output/ /output/
RUN /output/install-from-bindep && rm -rf /output/wheels
```
{{% /details %}}

### Task 5

* Inspect the image of your new EE with `ansible-navigator`.
* Check the included ansible version and verify that the collections `containers.podman` and `ansible.posix` are present.

{{% details title="Solution Task 5" %}}
```bash
$ ansible-navigator images

  NAME                                  TAG       EXECUTION ENVIRONMENT           CREATED            SIZE
0│ansible-navigator-demo-ee             0.6.0                      True           8 months ago       1.35 GB
1│ansible-runner                        latest                     True           14 hours ago       807 MB
2│default-ee                            latest                     True           2 hours ago        830 MB
```
Choose `2`:
```bash
  DEFAULT-EE:LATEST                          DESCRIPTION
0│Image information                          Information collected from image inspection
1│General information                        OS and python version information
2│Ansible version and collections            Information about ansible and ansible collections
3│Python packages                            Information about python and python packages
4│Operating system packages                  Information about operating system packages
5│Everything                                 All image information
```
Choose `2`:
```bash
DEFAULT-EE:LATEST (INFORMATION ABOUT ANSIBLE AND ANSIBLE COLLECTIONS)                                            
│---
1│ansible:
2│  collections:
3│    details:
4│      ansible.posix: 1.5.1
5│      containers.podman: 1.10.1
6│  version:
7│    details: core 2.12.5.post0
```
{{% /details %}}

### Task 6

* Change your configuration file `ansible-navigator.yml` to use your newly created EE `default-ee`.
* Podman's default behaviour is to pull any image tagged with `latest` when starting a container from it.
Since we didn't set up a proper registry at localhost we want to avoid this behaviour
by a setting in the config file `ansible-navigator.yml`.

{{% alert title="Tip" color="info" %}}
The stable version of ansible-navigator doesn't support the same options as the latest version.
Be sure to look into the [documentation of the stable version](https://ansible-navigator.readthedocs.io/en/stable/settings/#the-ansible-navigator-settings-file) since that is what we have installed.
There's also a [documentation of the latest version](https://ansible-navigator.readthedocs.io/en/latest/) where you can have a glimpse at the upcoming features.
{{% /alert %}}

* Run the playbook `container.yml` and verify that the image `docker pull quay.io/bitnami/mariadb`
was pulled on the db servers. Provide a cmdline option to run it in stdout mode.
* Can you run your previous playbook `site.yml` with the new EE?

{{% details title="Solution Task 6" %}}
```bash
$ cat ansible-navigator.yml 
---
ansible-navigator:
  ansible:
    config:
      help: False
      path: /home/ansible/techlab/ansible.cfg
    cmdline: "--forks 20"
  color:
    enable: True
  execution-environment:
    container-engine: podman
    enabled: True
    image: default-ee:latest   #<---
    pull-policy: never         #<---
```

```bash
$ ansible-navigator run container.yml -m stdout

PLAY [test ee with containers.podman collection] *******************************

TASK [Gathering Facts] *********************************************************
ok: [node2]

TASK [Install podman] **********************************************************
ok: [node2]

TASK [Pull an image] ***********************************************************
ok: [node2]

PLAY RECAP *********************************************************************
node2                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ ansible db -b -a "podman images"
node2 | CHANGED | rc=0 >>
REPOSITORY             TAG         IMAGE ID      CREATED       SIZE
quay.io/bitnami/mariadb  latest      c6cb896c1070  11 hours ago  93.5 MB
```
Note that if you pulled the image as user `root` on the `db` servers,
you will not see it in the output of `podman images` unless it's run as user `root` as well.

Because we included the collection `ansible.posix` in our EE earlier,
we can run tasks with the `ansible.posix.firewalld` module.
Therefore, running the playbook `site.yml` from the ansible-navigator lab would work as well!

```bash
$ ansible-navigator run site.yml
...
```

{{% /details %}}

### All done?

* Think about why the container was able to connect to the servers over ssh without providing a password
* Have a look at the [ansible-builder GitHub page](https://github.com/ansible/ansible-builder)
* Have a look at the [docs of the latest version of ansible-navigator](https://ansible-navigator.readthedocs.io/en/latest/) to see how the tool will evolve

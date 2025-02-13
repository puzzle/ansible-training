---
title: "9.1 AWX / Ascender / AAP Installation"
weight: 91
sectionnumber: 9.1
---

### Task 1

Get yourself familiar with the installation options for AWX, Ascender and AAP

* Have a look at the different installation documentations
  * [AWX install](https://github.com/ansible/awx/blob/devel/INSTALL.md)
  * [Ascender Install](https://github.com/ctrliq/ascender-install)
  * [AAP Install](https://access.redhat.com/documentation/en-us/red_hat_ansible_automation_platform/)
* What is one of the advantages when installing Ascender?
* What is one of the advantages when installing AAP?
{{% details title="Solution Task 1" %}}
An advantage of Ascender is the handy install script [ascender-install](https://github.com/ctrliq/ascender-install).
Another advantage is, that everything is available even without a valid subscription for Ascender.

An advantage of AAP is the availability of an rpm based installation.
The downside is, that those rpm's are only available when you have a valid AAP subscription
and you are logged in the Red Hat customer backend.
{{% /details %}}

### Task 2

* Now, we want to install Ascender locally using k3s. The [ascender-install](https://github.com/ctrliq/ascender-install)
repository from Github is checked out to the folder `/home/ansible/ascender-install` on your ascender server.
* Which file contains the configuration parameters for your installation?

{{% details title="Solution Task 2" %}}
```
/home/ansible/ascender-install/default.config.yml
```
See that the file was already prepared with the information for your lab servers.
{{% /details %}}

### Task 3

* Run the installation. This may take some time.

{{% details title="Solution Task 3" %}}
```bash
cd /home/ansible/ascender-install
sudo ./setup.sh
```
{{% /details %}}

### Task 4

* Log in to Ascender using the username and password provided by the teacher.
* In which file are the credentials defined?

{{% details title="Solution Task 4" %}}
```
/home/ansible/ascender-install/default.config.yml
```
{{% /details %}}

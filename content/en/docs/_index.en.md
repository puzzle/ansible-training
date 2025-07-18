---
title: "Labs"
weight: 2
menu:
  main:
    weight: 2
---

Welcome to the Puzzle Ansible Techlab. This is an
introductory course for getting to know the
basics of the Ansible configuration management
system.

### Target Audience

This course is targeting Linux system administrators
with working knowledge of Linux that did not yet have
exposure to the Ansible configuration management
system. A familiarity with the basic concept of
configuration management is not a prerequisite.


### Techlab Setup

This Ansible techlab assumes that each participant has a
cluster of virtual machines available. Namely:

* a control host called `control0`
* two Linux nodes called `node1` and `node2`
* three Windows nodes called `win1`, `win2` and `win3`
* a Linux server called `ascender`

Overview:

| Hostname      | IP address        | Operating System    |
| ------------- | ----------------- | ------------------- |
| `control0`    | `192.168.200.101` | Rocky Linux 9       |
| `node1`       | `192.168.200.103` | Rocky Linux 9       |
| `node2`       | `192.168.200.104` | Rocky Linux 9       |
| `win1`        | `192.168.200.105` | Windows Server 2022 |
| `win2`        | `192.168.200.106` | Windows Server 2022 |
| `win3`        | `192.168.200.107` | Windows Server 2022 |
| `ascender`    | `192.168.200.108` | Rocky Linux 9       |


{{% alert title="Note" color="primary" %}}
The cloud-based lab infrastructure is provided if you
are following a guided Techlab by Puzzle ITC.
{{% /alert %}}

If you prefer to run the techlab environment locally
you can find instructions to set up Vagrant-based
virtual hosts in the [setup section](/setup)
of this website.

If you already have a setup or the instructor provided
a ready-made one, you may skip ahead to
[1.0 Setting up Ansible](01)

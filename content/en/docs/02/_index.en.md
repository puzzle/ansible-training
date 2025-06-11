---
title: 2. Documentation
weight: 20
sectionnumber: 2
---

### Task 1

* Print out a list of all Ansible modules in your terminal.

{{% alert title="Note" color="primary" %}}
Don’t be rattled about the massive amount of modules you’ll see in your terminal.
{{% /alert %}}

* Print out information about the Ansible module `ansible.builtin.file` in your terminal.

{{% details title="Solution Task 1" %}}
```bash
ansible-doc -l
ansible-doc file
ansible-doc -s file
```
{{% /details %}}

### Task 2

* Find the official online documentation of Ansible in your browser.
* Visit the module index (i.e. list of all modules) in the online documentation.
* Use the search field in the upper left of the web page and also use the search field in the lower right.

{{% details title="Solution Task 2" %}}

* visit [Ansible Docs](https://docs.ansible.com/)
* visit [Ansible Docs - Modules by category](https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html)

{{% alert title="Note" color="primary" %}}
Starting from Ansible > 2.10 modules are shipped via collections.
We will have a look at collections in [Chapter 8](../08).
You'll find an overview of the most used collections on [Ansible Docs - Collection Index](https://docs.ansible.com/ansible/latest/collections/index.html)

{{% /alert %}}

{{% /details %}}

### Task 3 (Advanced)

* The `ansible-core` package has additional documentation.
* Use your package-managers functionality to find out what files are installed.
* Now find documentation about jinja2 on the controller.

{{% details title="Solution Task 3" %}}
One way to find a list of provided documentation:
```bash
rpm -ql ansible-core
```

You can also search for files in `/usr/share/doc`:
```bash
ls -lahr /usr/share/doc/ | grep jinja2
```
{{% /details %}}

### Task 4 (Captain Future)

* Have a look at the development documentation.
* Search for the release dates of future ansible versions.

{{% details title="Solution Task 4" %}}

* [https://docs.ansible.com/ansible/devel/](https://docs.ansible.com/ansible/devel/)
* [https://docs.ansible.com/ansible/devel/roadmap/index.html#ansible-roadmap](https://docs.ansible.com/ansible/devel/roadmap/ansible_roadmap_index.html)

{{% /details %}}

### All done?

* [Red Hat Automation Blog](https://www.redhat.com/en/blog/channel/management-and-automation)
* [Red Hat Ansible YouTube](https://www.youtube.com/c/AnsibleAutomation/videos)

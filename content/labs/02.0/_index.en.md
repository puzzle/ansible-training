---
title: "2.0 - Documentation"
weight: 20
---

### Task 1

- Print out a list of all Ansible modules in your terminal

{{% notice note %}} 
 Don’t be rattled about the massive amount of modules you’ll see in your terminal.
{{% /notice %}}

- Print out information about the Ansible module `file` in your terminal

### Task 2

- Find the official online documentation of Ansible in your browser
- Visit the module index (e.g. list of all modules) in the online documentation
- Use the search field in the upper left of the webpage and also use the search field in the lower right

### Task 3 (Advanced)

- By installing the `ansible-doc` package, not only the command itself gets installed but also a lot of additional documentation. Use your package-managers functionality to find out what files are installed with `yum install ansible-doc`.
- Now find documentation about jinja2 on the controller.

### Solutions

{{% collapse solution-1 "Solution 1" %}}
```bash
$ ansible-doc -l
$ ansible-doc file
$ ansible-doc -s file
```
{{% /collapse %}}

{{% collapse solution-2 "Solution 2" %}}
- visit [Ansible Docs](https://docs.ansible.com/)
- visit [Ansible Docs - Modules by category](https://docs.ansible.com/ansible/latest/modules/modules_by_category.html)
{{% /collapse %}}

{{% collapse solution-3 "Solution 3" %}}
One way to find a list of provided documentation:
```bash
$ yum install -y yum-utils # (if needed)
$ repoquery ansible-doc -l
``` 

You can also search for files in `/usr/share/doc`:
```bash
$ ls -lahr /usr/share/doc/ | grep jinja2
```
{{% /collapse %}}
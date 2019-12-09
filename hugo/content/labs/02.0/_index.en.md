---
title: "2.0 - Documentation"
weight: 20
---

### Task 1

- Print out a list of all ansible modules in your terminal


{{% notice note %}} 
 Don’t be rattled about the massive amount of modules you’ll see in
 your terminal.
{{% /notice %}}

  - Print out information about the ansible module `file` in your
    terminal

### Task 2

- Find the official online documentation of ansible in your browser

- Visit the module index (e.g. list of all modules) in the online
  documentation

- Use the search field in the upper left of the webpage and also use the search field in the lower right

### Task 3 (Advanced)

- Find documentation provided by the ansible-doc yum package, but not provided by the command itself

- Find documentation about jinja2 on the controller

### Solutions

{{% collapse solution-1 "Solution 1" %}}
```bash
$ ansible-doc -l
$ ansible-doc file
$ ansible-doc -s file
```
{{% /collapse %}}

{{% collapse solution-2 "Solution 2" %}}
- visit <https://docs.ansible.com/>
- visit <https://docs.ansible.com/ansible/latest/modules/modules_by_category.html>
{{% /collapse %}}

{{% collapse solution-3 "Solution 3" %}}
One way to find a list of provided documentation:
```bash
$ yum install -y yum-utils # (if needed)
$ repoquery ansible-doc -l
``` 

You can also search for files in /usr/share/doc:
```bash
$ ll -R /usr/share/doc/ | grep jinja2
```
{{% /collapse %}}
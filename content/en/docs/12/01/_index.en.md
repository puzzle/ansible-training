---
title: 12.1 Ansible Module Development - Basics
weight: 121
sectionnumber: 12
---

In this lab we are going to learn how Ansible uses modules and where to find information about developing a custom module.

### Task 1

* In which language has a module to be written?
* Point your webbrowser to the official documentation about developing modules.
* Point your webbrowser to the official documentation about developing modules best practices.
* Point your webbrowser to the official documentation about developing collections.
* Point your webbrowser to the official documentation about debugging your module.
* Which environment variable lets you keep the remote module files after executing the module (instead of deleting it)?

{{% details title="Solution Task 1" %}}

* either Pyhon (Linux) or Powershell (Windows)
* [https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html)
* [https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_best_practices.html#developing-modules-best-practices](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_best_practices.html#developing-modules-best-practices)
* [https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html#developing-collections](https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html#developing-collections)
* [https://docs.ansible.com/ansible/latest/dev_guide/debugging.html#debugging-modules](https://docs.ansible.com/ansible/latest/dev_guide/debugging.html#debugging-modules)
* `ANSIBLE_KEEP_REMOTE_FILES`

{{% /details %}}

### Task 2

* for possible content of the `my_module.py` file, see the [official documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module) 
* 

{{% details title="Solution Task 2" %}}

```bash
$ mkdir /home/ansible/techlab/library/
$ touch /home/ansible/techlab/library/my_module.py
```
{{% /details %}}

### All done?

* [Ansible module development on YouTube](https://www.youtube.com/results?search_query=ansible+module+development)
* Have a look at the [Puzzle OPNsense Ansible Collection](https://github.com/puzzle/puzzle.opnsense)

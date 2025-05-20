---
title: 12.4  Initializing a Collection
weight: 124
sectionnumber: 12
---
Ansible modules are packaged and published inside Ansible collections in order to be used.
Therefore, we will start by learning how to initialize a collection.
Since we have already our python environment set up in the previous lab, we can start right away inside our current Python environment.

### Task 1 - Creating the Collection

Create the `training.labs` collection in the current project directory `/home/ansible/techlab/ansible-module-development` using the `ansible-creator` tool.

{{% details title="Solution Task 1" %}}

```bash
ansible-creator init collection training.labs ./training.labs
```
{{% /details %}}

### Task 2 - Set up the ansible development environment
With the collection created we can start working with its ansible development environment (`ade`).
This tool installs our newly created collection inside our virtual environment in such a way that ansible can use it.

Can you find out how to use the `ade install` command to install the collection to your current pipenv?


{{% details title="Solution Task 2" %}}

To get the current virtualenv from pipenv you can use `pipenv --venv`. The output of this command can then be further used
inside the `ade install` command as follows:

```bash
cd training.labs
ade install -e .\[test] --venv $(pipenv --venv)
```

Not also the `-e` flag is required to install the collection in editable mode.
If you installed it in any other way, use `ade uninstall training.labs` and repeat the command above.

{{% /details %}}

### Task 3 - Verify the collection installation
How can you verify that the new collection is installed and can be used by ansible?

The newly created collection comes with a few sample plugins out of the box which for now we will use to verify the collection installation.


{{% details title="Solution Task 3" %}}


You can check the installation of your collection in the following ways:
1. Using the `ade list` command you should see your collection in the list.
2. Using the `ansible-doc --list` command you should see the sample modules that come with the collection (e.g. `training.labs.sample_module`).
3. Most important you should see the collection in the `pipenv --venv` folder (inside the `lib/python3.1*/site-packages` folder):
   ```bash
   ls -lah $(pipenv --venv)/lib/python3.1*/site-packages/ansible_collections/training/labs
   ```
   Here you can see that `ade` creates a symlink to the collection folder ./training.labs inside the `ansible_collections` folder.


{{% /details %}}

### All done?
 - Have a look at the file structure of the newly created collection in the `training.labs` folder. Try to understand the structure, you can use the [Ansible Collection structure documentation ](https://docs.ansible.com/ansible/latest/dev_guide/developing_collections_structure.html#collection-structure) to learn more about the structure.
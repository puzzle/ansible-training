---
title: 12.2 Ansible Module Development - Environment Setup
weight: 122
sectionnumber: 12
---

In this section, we'll dive into setting up an isolated Python environment specifically tailored for Ansible module
development.
We'll be using `pipenv`, a powerful tool that simplifies dependency management and virtual environment creation.

### Why Use Virtual Environments?

When working on multiple Python projects, it's crucial to isolate their dependencies.
Different projects might rely on different versions of the same library, or even different Python versions altogether.
Installing packages globally can lead to conflicts and break existing projects.
Virtual environments solve this problem by creating isolated spaces where you can install project-specific dependencies
without affecting other projects or the system-wide Python installation.

{{% alert title="Note" color="primary" %}}
This section covers a Python environment setup using `pipenv`. If you are already well-versed with Python and any other
environment management tool like `poetry`, `venv`, `uv`, etc., feel free to skip this section.
However, keep in mind that you still need to install the necessary package `ansible-dev-tools` within your
chosen environment.

{{% /alert %}}

### Introducing `pipenv`

`pipenv` is a modern tool designed to handle both virtual environments and dependency management in Python projects. It
streamlines the process of:

* **Creating and managing virtual environments:** `pipenv` automatically creates a virtual environment for your project
  in the current directory or a specified location and handles all activiation for you.
* **Managing dependencies:** It uses a `Pipfile` to track your project's dependencies and a `Pipfile.lock` to ensure
  reproducible builds.
* **Simplified workflow:** It offers intuitive commands for installing, uninstalling, and updating packages.

### Task 1

Let's have a closer look at the `ansible-dev-tools` package.

The `ansible-dev-tools` package is a curated collection of essential tools for developing, testing, and
maintaining Ansible content.
It significantly simplifies the development workflow by bundling together frequently used utilities.
You can find detailed information about it
here: [Ansible Development Tools Documentation](https://ansible.readthedocs.io/projects/dev-tools).

What useful ansible-tools does `ansible-dev-tools` contain?

{{% details title="Solution Task 1" %}}

Here's a breakdown of the key packages included:

* **`ansible-builder`:** Automates the process of building Ansible execution environments using schemas and tooling
  defined in Ansible Collections.
* **`ansible-core`:** The core Ansible automation engine, enabling configuration management, application deployment, and
  task automation.
* **`ansible-creator`:**  A tool designed for efficiently generating Ansible content, helping to streamline development
  and content creation.
* **`ansible-dev-environment`**: A pip-like install for Ansible collections.
* **`ansible-lint`:** Analyzes playbooks and identifies areas for improvement in terms of best practices and potential
  issues.
* **`ansible-navigator`:** Provides a text-based user interface (TUI) for interacting with and managing Ansible.
* **`ansible-sign`**: Utility for signing and verifying Ansible project directory contents.
* **`molecule`:**  Aids in the development and testing of various Ansible content types, including collections,
  playbooks, and roles.
* **`pytest-ansible`:**  A plugin that allows using Ansible within pytest tests, and it helps in using pytest as a
  collection unit test runner, while also allowing molecule scenarios as pytest fixtures.
* **`tox-ansible`:** Provides a method to create a matrix of Python and Ansible environments to run tests for Ansible
  collections, both locally and with Github actions.

{{% /details %}}

### Task 2

If you don't have pipenv installed yet, you can install it globally using `pip` (which is usually installed with your
Python distribution):

```bash
dnf install python3-pip
pip install pipenv
```

Can you tell what pipenv version has been installed on your system?

{{% details title="Solution Task 2" %}}
You can get the pipenv version by running the following:

```bash
pipenv --version
```

The output may look like this

```bash
 $ pipenv --version
pipenv, version 2024.1.0
```

{{% /details %}}

### Task 3

Let's create a new project with a dedicated virtual environment. The project should reside in the folder `/home/ansible/techlab/ansible-module-development`.

1. **Create your project directory and navigate there:**

   ```bash
   mkdir -p /home/ansible/techlab/ansible-module-development
   cd /home/ansible/techlab/ansible-module-development
   ```

2. **Create the virtual environment:**
   To create the virtual environment run:
   ```bash
   pipenv install
   ```
   What happened with this command?

{{% details title="Solution Task 3" %}}

* It created a `Pipfile` and a `Pipfile.lock` in the current directory.
* A virtual environment has been created at `pipenv --venv`.
  {{% /details %}}

### Task 4

In this techlab we rely on the version 25.2.1 of the `ansible-dev-tools` package.
Can you find out how to install it in your new pipenv?

{{% details title="Solution Task 4" %}}

```bash
pipenv install ansible-dev-tools==25.2.1
```

* This will add `ansible-dev-tools` to your `Pipfile` and install it within the project's virtual environment.
* The version of the package is explicitly set in the `[packages]` directive of the `Pipfile`.
* `pipenv` also automatically updates the `Pipfile.lock`, so other developers can get the exact same dependency
  versions.

{{% alert title="Note on Version-Specific Dependency Installation" color="warning" %}}
When installing dependencies with pipenv, it's highly recommended to specify the exact version you need, like this:
`pipenv install ansible-dev-tools==25.2.1`, instead of just `pipenv install ansible-dev-tools`.
This ensures version locking, reproducible builds, prevents unexpected breakage, ensures an explicit dependency and
compatibility.
In short, always be explicit about the version you want to install.
You can always update to a newer version later (after testing it!), but starting with a locked version provides a much
more stable foundation.
{{% /alert %}}

{{% /details %}}

### Task 5

To start working within your virtual environment, you need to "activate" it. pipenv makes this super easy:

```bash
pipenv shell
```

* This command will launch a new shell session within the virtual environment.

How can you verify if the shell is active?

{{% details title="Solution Task 4" %}}

* You can verify that the virtual environments python interpreter is used by checking the output of `which python`. If
  the python interpreter is located inside the virtualenv at the location of `pipenv --venv` your virtual environment is
  active.
* You could also verify if any of the installed dependencies are available by e.g. running `ansible` or any other
  command from the `ansible-dev-tools` package.

{{% /details %}}

### Deactivating the Environment

To exit the virtual environment and return to your system's default shell, simply type:

```bash
exit
```

### All done?

* [Automatic Loading of .env in pipenv](https://pipenv.pypa.io/en/latest/shell.html#automatic-loading-of-env)
* [Checkout pipenv workflows](https://pipenv.pypa.io/en/latest/workflows.html#pipenv-workflows)

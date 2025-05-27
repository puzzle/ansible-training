---
title: 12.5 Testing your module
weight: 125
sectionnumber: 12
---

Since we now have our module inside our new collection we want to test it.
For that the ansible tooling has a set of modules to help us with different kinds of testing.

Ansible content should be tested in three ways:

1. Sanity Testing - Mainly static code analysis of different kinds
2. Unit Testing - Testing the logic of you code
3. Integration Testing - Testing how you ansible content behaves when integrated with other ansible content

We will have a look at how to set up and create these kind of tests.
But first let's have a look on how these tests are executed.

### Task 1 - tox-ansible

To perform tests on Ansible content `tox` alongside with the tox plugin `tox-ansible` is used.
`tox` is a Python test-automation framework, which allows you to run tests in different environments.
When we created the collection using the `ansible-creator` tool, it created a `tox-ansible.ini` file which we can use as a tox configuration.

In this file, we can configure what Python versions and Ansible versions to preform test against.
This can be very powerful especially when running extensive CI pipelines.
We will focus however, on our local Python and Ansible versions for now.
Try to solve the following tasks:

1. Can you list all available tests?
2. What Python and Ansible versions are available on you lab server?
3. Can you configure the tox-ansible plugin to use your local Python and Ansible versions? (Use the tox ansible [documentation](https://ansible.readthedocs.io/projects/tox-ansible/configuration/))

{{% details title="Solution Task 1" %}}

1. With the pipenv activated and inside the collection directory run:
    ```bash
    tox list --ansible -c tox-ansible.ini
    ```
2. You can find out which Python and Ansible versions are available by running:
   ```bash
    $ python -V
    Python 3.12.5
    $ ansible --version
    ansible [core 2.18.6]
      config file = /home/ansible/techlab/ansible-module-development/ansible.cfg
      configured module search path = ['/home/ansible/techlab/ansible-module-development/library']
      ansible python module location = /home/ansible/.local/share/virtualenvs/ansible-module-development-J9Af2H_I/lib/python3.12/site-packages/ansible
      ansible collection location = /home/ansible/.ansible/collections:/usr/share/ansible/collections
      executable location = /home/ansible/.local/share/virtualenvs/ansible-module-development-J9Af2H_I/bin/ansible
      python version = 3.12.5 (main, Apr  2 2025, 00:00:00) [GCC 11.5.0 20240719 (Red Hat 11.5.0-5)] (/home/ansible/.local/share/virtualenvs/ansible-module-development-J9Af2H_I/bin/python)
      jinja version = 3.1.6
      libyaml = True

   ```

3. You can configure tox-ansible to use your local Python and Ansible versions by skipping all versions that do not match your local Python and Ansible versions. The following lines should do the trick:

   ```ini
   [ansible]
   skip =
     py3.10
     py3.11
     py3.13
     2.16
     2.17
     devel
     milestone
   
   ```

{{% /details %}}

### Task 2 - Sanity Testing our collection

Let's try to run sanity tests against our collection.
List the available sanity tests again and choose to run the sanity tests.

In the test output you will some issues regarding the sample plugins, feel free to either remove these plugins or ignore them.

Does the `schroedingers_cat` plugin pass the sanity tests?

Try to fix all the tests.

{{% details title="Solution Task 2" %}}

You can execute a specific sanity test by running:

```bash
tox -e sanity-py3.12-2.18 --ansible --conf tox-ansible.ini
```

Those plugins can be removed:

```bash
rm plugins/test/sample_test.py
rm plugins/action/sample_action.py
rm plugins/action/sample_*.py
```

{{% /details %}}

### Task 3 - Unit Testing our collection

Unit tests can be run similarly to sanity tests but with the `unit` environment:

```bash
$ tox -e unit-py3.12-2.18 --ansible --conf tox-ansible.ini
....

2 workers [1 item]      
scheduling tests via LoadScheduling

tests/unit/test_basic.py::test_basic 
[gw0] [100%] PASSED tests/unit/test_basic.py::test_basic 

================================================ 1 passed in 0.40s ================================================
  unit-py3.12-2.18: OK (74.18=setup[45.34]+cmd[0.00,0.13,27.87,0.02,0.82] seconds)
  congratulations :) (74.27 seconds)

```

As you can see from the output of this command there are already some basic tests present in the collection.
We will ignore them for now and focus on writing our own tests against our collection to make sure our module works as expected.

The Ansible Community Documentation has an extensive documentation page about unit testing modules that you can find [here](https://docs.ansible.com/ansible/latest/dev_guide/testing_units_modules.html).
Keep this page in mind since it may come in handy as a reference for the following tasks.
It may also be helpful if you are not familiar with unit testing and want to learn more on what unit tests are and why we need them.

For now, we will start by creating a test file for the `schroedingers_cat` module in the `tests/unit/plugins/modules` directory and adding some test cases in it.
In this lab we will use pytest style test cases.

Can you implement the following unit test cases?

1. The module should always return a `cat_state` on exit.
2. The module should always return a cat state of `dead and alive` when the `force_box_open` argument is set to `False` (default).
3. The module should always return a cat state of `alive` or `dead` when the `force_box_open` argument is set to `True`.


{{% details title="Solution Task 3" %}}

First create the unit test file:

```bash
cd training.labs
mkdir -p tests/unit/plugins/modules
touch tests/unit/plugins/{,modules/}__init__.py
touch tests/unit/plugins/modules/test_schroedingers_cat.py
```

To write isolated unit tests we will need some of the utilities introduced in the Ansible Community Documentation.
First we need to address the question how can i control with what arguments my module will be called in the unit test.

The `set_module_args` function from the documentation can be used to set the arguments that will be passed to the module:

```python
from ansible.module_utils import basic
from ansible.module_utils.common.text.converters import to_bytes

def set_module_args(args):
    """prepare arguments so that they will be picked up during module creation"""
    args = json.dumps({'ANSIBLE_MODULE_ARGS': args})
    basic._ANSIBLE_ARGS = to_bytes(args)
```

With this approach we leverage a global variable which ansible uses to store the passed arguments.
Then we can set the arguments to the module by calling the `set_module_args` function in the test cases.

The second issue we need to address is to verify the termination status of the module.
It either will call the exit_json function or the fail_json function.
Using pytest fixtrues to mock the AnsibleModule functions is a good approach to test the module:

```python
from unittest.mock import patch, MagicMock

import pytest

@pytest.fixture
def mock_exit_json():
    with patch('ansible.module_utils.basic.AnsibleModule.exit_json', new=MagicMock()) as mock:
        yield mock
```

Now let's implement the unit tests for the cases mentioned above:


```python
from ansible_collections.training.labs.plugins.modules import schroedingers_cat

def test_schroedingers_cat_returns_cat_state(mock_exit_json: MagicMock) -> None:
    """
    Check that the module returns a cat state.
    """
    set_module_args({})
    schroedingers_cat.run_module()

    mock_exit_json.assert_called_once()
    assert "cat_state" in mock_exit_json.call_args.kwargs

    
def test_schroedingers_cat_returns_dead_and_alive_when_force_box_open_is_false(mock_exit_json: MagicMock) -> None:
    """
    Check that the module returns dead and alive when force_box_open is false.
    """
    set_module_args({'force_box_open': False})
    schroedingers_cat.run_module()

    mock_exit_json.assert_called_once()
    assert mock_exit_json.call_args.kwargs['cat_state'] == 'dead and alive'

    
def test_schroedingers_cat_returns_alive_or_dead_when_force_box_open_is_true(mock_exit_json: MagicMock) -> None:
    """
    Check that the module returns alive or dead when force_box_open is true.
    """
    set_module_args({'force_box_open': True})
    schroedingers_cat.run_module()

    mock_exit_json.assert_called_once()
    assert mock_exit_json.call_args.kwargs['cat_state'] in ['alive', 'dead']
```

Now we can run the unit tests using tox just like we did for the sanity tests:

```bash
$ tox -e unit-py3.13-2.18  --ansible -c tox-ansible.ini 
...
============================================== test session starts ================================================
...

tests/unit/plugins/modules/test_schroedingers_cat.py::test_schroedingers_cat_returns_cat_state 
tests/unit/plugins/modules/test_schroedingers_cat.py::test_schroedingers_cat_returns_dead_and_alive_when_force_box_open_is_false 
[gw1] [ 33%] PASSED tests/unit/plugins/modules/test_schroedingers_cat.py::test_schroedingers_cat_returns_dead_and_alive_when_force_box_open_is_false 
[gw0] [ 66%] PASSED tests/unit/plugins/modules/test_schroedingers_cat.py::test_schroedingers_cat_returns_cat_state 
tests/unit/plugins/modules/test_schroedingers_cat.py::test_schroedingers_cat_returns_alive_or_dead_when_force_box_open_is_true 
[gw0] [100%] PASSED tests/unit/plugins/modules/test_schroedingers_cat.py::test_schroedingers_cat_returns_alive_or_dead_when_force_box_open_is_true 

================================================ 3 passed in 0.44s ================================================
  unit-py3.13-2.18: OK (4.81=setup[0.04]+cmd[0.00,0.23,3.78,0.01,0.74] seconds)
  congratulations :) (4.88 seconds)
```

{{% /details %}}


### All done?

* Can you test your module in any other way?

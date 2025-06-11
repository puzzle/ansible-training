---
title: 12.3 Creating a Local Module
weight: 123
sectionnumber: 12
---

Before we dive further into the bells and whistles of collections and other ansible dev tools, let's start with a simple module.
Most likely you will encounter use-cases that will not justify the overhead of maintaining a collection.
In those cases it is still possible to create a local module and use it in your playbooks in a much easier and more appropriate way.

## Setup

To do so, we need to configure Ansible to look for our custom modules at a specified location.

We can tell Ansible where to look for custom modules by either setting the `ANSIBLE_LIBRARY`
environment variable or by setting the `library` option in the `defaults` section of the  `ansible.cfg` file.

Let's use the `ansible.cfg` approach for this and set the `library` option to a local folder `./library`.

{{% details title="Solution Task 1" %}}

The `ansible.cfg` file should look like this:

```ini
[defaults]
library = ./library
```

Do not forget to create the `library` folder:

```bash
mkdir -p ./library
```

{{% /details %}}

## Ansible Module Structure

Let's have a look at the example module of the [official documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#codecell0).
From the code of the `my_test.py` module we can identify the key elements required to write a module:

### 1. Some boilerplate code

Ansible modules must start with this boilerplate code.

```python
#!/usr/bin/python
# Copyright:  (c) 2025, Your Name <your@email.ch>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type
```

This ensures that the module can be executed as a standalone module using python 2 and 3.

### 2. The `DOCUMENTATION` block

This block contains information about the module and its arguments.
Ansible tooling uses this information to generate documentation for the `ansible-doc` output and the `antsibull-doc` HTML pages.
For this reason this block must adhere to a specific format, which is thoroughly documented in the [official documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_documenting.html#documentation-block).

### 3. The `EXAMPLES` block

This block contains examples of how to use the module. Just like the `DOCUMENTATION` block, this block must adhere to a specific format.
The specification is documented in the [official documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_documenting.html#examples-block) as well.

### 4. The `RETURN` block

Finally, the `RETURN` block contains information about the return values of the module. Again, this block must adhere to a specific format.
The specification is documented in the [official documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_documenting.html#return-block).

### 5. The main function

The main function contains the code of the module. There are only a few rules to keep in mind:

* in the main function you must instantiate an `AnsibleModule` object with an argument specification.
* you can access the Ansible task arguments using the `module.params` dictionary and use them to implement your logic.
* the main function exits when either `module.fail_json` (in case of failure) or `module.exit_json` (in case of success) is called.

So given these rules, the main function signature will probably look like this:

```python
def main() -> None:
    ...
```


### 6. The main guard

This is the last part and is the entry point of the module.
It contains the code call that is executed when the module is called, either by Ansible when it executes the module on the target host
or when we want to test the module locally. This part usually looks like this:

```python
if __name__ == '__main__':
    main()
```

Now that we know how a module is structured, let's try to implement a simple module ourselves.


## Task 2 - Schrödingers Cat - Module specification

Let's say for some reason we need a module `schroedingers_cat` which can determine the state of a cat on our hosts.
We can implement it in the previously created directory as `./library/schroedingers_cat.py`.
By default, the module must return `dead and alive` as the state of the cat.
However, if the `force_box_open` argument is set to `true`, the module should choose randomly between `alive` or `dead`.

Given the above requirements, try to implement the `DOCUMENTATION`, `EXAMPLES` and `RETURN` of the `schroedingers_cat` module.

{{% details title="Solution Task 1" %}}

First create the module file:

```bash
touch ./library/schroedingers_cat.py
```

Now, add these blocks and don't forget the boilerplate code:

```python
#!/usr/bin/python
# Copyright:  (c) 2025, Your Name <your@email.ch>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: schroedingers_cat
short_description: Determine the state of a cat
description:
    - Determine the state of the cat either by opening the box or assume that it is in a superposition state.
options:
    force_box_open:
        description: Open the box to determine the state of the cat.
        required: false
        type: bool
        default: false
author:
    - Your Name <your@email.ch>
'''

EXAMPLES = r'''
- name: Determine the state of a cat
  schroedingers_cat:
    force_box_open: true
  register: cat_state
    
- name: Determine the state of a cat without opening the box
  schroedingers_cat:
  register: cat_state

'''

RETURN = r'''
cat_state:
    description: The state of the cat
    type: str
    returned: always
    sample: 'alive'
'''
```

{{% /details %}}

## Task 2 - Schrödingers Cat - Implementing the module

Now let's implement the main function of the `schroedingers_cat` module.

Keep in mind the rules for the main function mentioned above and don't forget to call the function in the main guard.

{{% details title="Solution Task 2" %}}

First we must import the required python dependencies:

```python
from ansible.module_utils.basic import AnsibleModule

import random
```

Now we can start the main function by creating the argument specification and instantiating an AnsibleModule object:
```python
def main() -> None:
    module_args_spec: dict = dict(
        force_box_open=dict(
            type="bool",
            default=False,
            required=False,
        )
    )

    module = AnsibleModule(argument_spec=module_args_spec)
```

The next step now would be to access the arguments using the `module.params` dictionary to implement the logic of the module.

```python
    force_box_open: bool = module.params["force_box_open"]
    cat_state: str = random.choice(["alive", "dead"]) if force_box_open else "dead and alive"
```

Finally, we can return the result using the `module.exit_json` function:

```python
    module.exit_json(cat_state=cat_state)
```

At the very last of the file we need to add the main guard where we call the main function:

```python
if __name__ == "__main__":
    main()
```

{{% /details %}}

## Task 3 - Schrödingers Cat - Verifying the module

Now that we have the logic in place let's verify the module. First we can test using `ansible-doc` if the module is detected correctly by ansible.
If so we can then proceed with testing our module with an Ansible adhoc command.

{{% details title="Solution Task 3" %}}
First check using `ansible-doc`:

```bash
ansible-doc schroedingers_cat
```

If the module is detected correctly, we can then proceed with testing our module with Ansible adhoc commands:

```bash
$ ansible localhost -m schroedingers_cat
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | SUCCESS => {
    "cat_state": "dead and alive",
    "changed": false
}
```

or with the `force_box_open` argument:

```bash
$ ansible localhost -m schroedingers_cat -a "force_box_open=true"
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | SUCCESS => {
    "cat_state": "dead",
    "changed": false
}
$ ansible localhost -m schroedingers_cat -a "force_box_open=true"
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | SUCCESS => {
    "cat_state": "alive",
    "changed": false
}

```

Running the module with the `force_box_open` argument should result in a random `alive` or `dead` state.

{{% /details %}}

## All done?

* Can you verify your module in any other way? see [Verifying your module](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#verifying-your-module-code)

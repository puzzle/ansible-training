---
title: 12.7 Module Utils
weight: 127
sectionnumber: 12
---

In this short lab we will have a look on how to move reusable code from modules into module utils.

### Task 1 - Create a Module Utils for file handling

In the last lab, we created a simple module that allows us to track the cat's state on every host by writing it to a file in `/tmp/.cat_state.txt`.
To do so we wrote two functions in the module to write and read the cat state from the file.

Let's create a module util for file handling operations called `state_file_utils.py` and move the functions there.

{{% details title="Solution Task 1" %}}


Create the `moduel_utils/state_file_utils.py` file with the following content:

```python
# Copyright:  (c) 2025, Your Name <your@email.ch>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import (absolute_import, division, print_function)

__metaclass__ = type

from typing import Optional

CAT_STATE_FILE_PATH: str = "/tmp/.cat_state.txt"


def read_cat_state() -> Optional[str]:
    """
    Get the previous cat state from the file.
    """
    try:
        with open(CAT_STATE_FILE_PATH, "r") as f:
            return f.read().strip()
    except (IOError, FileNotFoundError):
        return None


def write_cat_state(cat_state: str) -> None:
    """
    Write the cat state to the file.
    """
    with open(CAT_STATE_FILE_PATH, "w") as f:
        f.write(cat_state)

```

Now import it in the `training.labs.schroedingers_cat` module and update the code:
```python
...

from ansible.module_utils.basic import AnsibleModule

from ansible_collections.training.labs.plugins.module_utils.state_file_utils import (
    read_cat_state,
    write_cat_state,
)

import random
from typing import Optional


def run_module() -> None:
    ...
    previous_cat_state: Optional[str] = read_cat_state()
    ...
    if previous_cat_state != new_cat_state or previous_cat_state is None:
        ...
        if not module.check_mode:
            write_cat_state(new_cat_state)
...
```

{{% /details %}}

### All done?

- Can you add unit tests to the module utils?
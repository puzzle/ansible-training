---
title: 12.6 Tracking State in a Custom Module
weight: 126
sectionnumber: 12
---

In this lab, you will extend the `schroedinger_cat` example module to track the cat's state on every host by writing it to a file in `/tmp/.cat_state.txt`.
You will also add support for check mode and ensure that the module always provides a diff when run with `--diff`.

### Task 1 - Write Cat State to a file

Modify the module so that it writes the current cat state ("alive" or "dead") to `/tmp/.cat_state` whenever it runs (we will handle the check mode later).

Verify this behaviour in the integration tests from the previous lab.

{{% details title="Solution Task 1" %}}

Let's have a look at one possible solution. We can start by having a look at the `run_module` function and see how the new program flow could look like:

```python
from typing import Optional


def run_module() -> None:
    module_args_spec: dict = dict(
        force_box_open=dict(
            type="bool",
            default=False,
            required=False,
        )
    )

    module = AnsibleModule(argument_spec=module_args_spec)
    force_box_open: bool = module.params["force_box_open"]

    if not force_box_open:
        # If the box is not opened, the cat is in a superposition state
        module.exit_json(cat_state="dead and alive")

    previous_cat_state: Optional[str] = _get_previous_cat_state()
    new_cat_state: str = random.choice(["alive", "dead"])
    changed: bool = False

    if previous_cat_state != new_cat_state or previous_cat_state is None:
        changed = True
        _write_cat_state(new_cat_state)

    module.exit_json(cat_state=new_cat_state, changed=changed)

```

Now given this top level function, let's have a look at how the `_write_cat_state` and `_get_previous_cat_state` function could look like:

```python
from typing import Optional


CAT_STATE_FILE_PATH: str = "/tmp/.cat_state.txt"


def _get_previous_cat_state() -> Optional[str]:
    """
    Get the previous cat state from the file.
    """
    try:
        with open(CAT_STATE_FILE_PATH, "r") as f:
            return f.read().strip()
    except (IOError, FileNotFoundError):
        return None


def _write_cat_state(cat_state: str) -> None:
    """
    Write the cat state to the file.
    """
    with open(CAT_STATE_FILE_PATH, "w") as f:
        f.write(cat_state)


```

Your integration tests could look like this:

```yaml
---

- name: Test schroedingers_cat without force open box
  block:
    - name: Test schroedingers_cat without force open box
      training.labs.schroedingers_cat:
      register: no_force_result

    - name: Assert that the cat state is 'dead and alive' and not changed
      ansible.builtin.assert:
        that:
          - no_force_result.cat_state == 'dead and alive'
          - not no_force_result.changed

    - name: Get cat state file stats
      ansible.builtin.stat:
        path: "/tmp/.cat_state.txt"
      register: file_result

    - name: Assert that the file has not been created since the box has not been opened
      ansible.builtin.assert:
        that:
          - not file_result.stat.exists

- name: Test schroedingers_cat with force open box
  block:
    - name: Test schroedingers_cat with force open box
      training.labs.schroedingers_cat:
        force_box_open: true
      register: force_result

    - name: Assert that the cat state is 'dead' or 'alive'
      ansible.builtin.assert:
        that:
          - force_result.cat_state in ['dead', 'alive']

    - name: Get cat state file stats
      ansible.builtin.stat:
        path: "/tmp/.cat_state.txt"
      register: file_result

    - name: Assert that the file has been created since the box has been opened
      ansible.builtin.assert:
        that:
          - file_result.stat.exists
```

{{% /details %}}


### Task 2 - Implement a molecule cleanup playbook

Running the previous integration tests will create a file in the user's home directory.
So when re-running the tests, they will fail.
Let's write a molecule cleanup playbook to remove it.

Can  you figure out how to add a playbook in the `extensions/molecule/` directory that removes the file before and after each run?

{{% details title="Solution Task 2" %}}

For instance, you could create a playbook in the `extensions/molecule/integration_schroedingers_cat` scenario called `cleanup_cat_state.yml`.
The playbook could look like this:

```yaml
---
- name: Remove cat state file
  file:
    path: "/tmp/.cat_state.txt"
    state: absent
```

Now configure it in the `molecule.yml` file:

```yaml
---
...
provisioner:
  ...
  playbooks:
    cleanup: ./cleanup_cat_state.yml
    converge: ../utils/playbooks/converge.yml
    destroy: ./cleanup_cat_state.yml
    prepare: ./cleanup_cat_state.yml
...
```

Now re-run the integration tests and make sure they pass.

{{% /details %}}

### Task 3 - Implement Check Mode Support

The next feature we want to support in our module is the ansible check mode.

Can you figure out how to implement it in our existing module?

Don't forget to test it!

{{% details title="Solution Task 3" %}}

To support the check mode in our module we need to enable it when instantiating the module:

```python
    ...
    module = AnsibleModule(argument_spec=module_args_spec, supports_check_mode=True)
    ...
```

Next we need to prevent creating a file or writing to it in check mode.
One solution could be in the `run_module` function to not call the `_write_cat_state` function in check mode:

```python
    ...
    if previous_cat_state != new_cat_state or previous_cat_state is None:
        changed = True
        if not module.check_mode:
            _write_cat_state(new_cat_state)
    ...
```

Now to test it we can add a new block to the integration tests.
To ensure the file is not created by any other block, go ahead and add the following block before the `Test schroedingers_cat with force open box` block:

```yaml

- name: Test schroedingers_cat with force open box in check mode
  block:
    - name: Test schroedingers_cat with force open box
      training.labs.schroedingers_cat:
        force_box_open: true
      check_mode: true
      register: force_result

    - name: Assert that the cat state is 'dead' or 'alive'
      ansible.builtin.assert:
        that:
          - force_result.cat_state in ['dead', 'alive']
  
    - name: Get cat state file stats
      ansible.builtin.stat:
        path: "/tmp/.cat_state.txt"
      register: file_result

    - name: Assert that the file has not been created since it ran in check mode
      ansible.builtin.assert:
        that:
          - not file_result.stat.exists
```

{{% /details %}}

### Task 4 - Always Return a Diff Value

Ensure the module always returns a `diff` value in the result, showing the previous and new state whenever a change occurs.
This enables `--diff` mode support.

To do so we need to add a `diff` key to the result, containing a dictionary with a `before` and `after` key.

Go ahead, implement and test it!

{{% details title="Solution Task 3" %}}

We could implement it like this in the `run_module` function:

```python
    ...
    changed: bool = False
    diff: dict = {}
    
    if previous_cat_state != new_cat_state or previous_cat_state is None:
        changed = True
        diff = {
            "before": previous_cat_state ,
            "after": new_cat_state,
        }
        if not module.check_mode:
            _write_cat_state(new_cat_state)

    module.exit_json(cat_state=new_cat_state, changed=changed, diff=diff)

...
```

Test it by adding a few checks to the assertions in the integration tests.
For example, we expect the diff to be present when the state of the cat is changed:

```yaml

- name: Test schroedingers_cat with force open box
  block:
   ...
    
    - name: Assert a diff exists when the cat state is changed
      ansible.builtin.assert:
        that:
          - force_result.diff
      when: force_result.changed
```

{{% /details %}}


### All done?

* Can you make the state file path configurable via a module parameter?
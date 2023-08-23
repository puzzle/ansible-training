---
title: 6. Managing Secrets with Ansible Vault
weight: 60
sectionnumber: 6
---

In this lab we are going to practice encryption in Ansible playbooks. It assumes your working directory is always `/home/ansible/techlab/`.

### Task 1

* Create a simple playbook called `secretservice.yml` which creates a file `MI6` in the `/etc/` directory on `node1` and `node2`. Use the `template` module and a template named `mi6.j2`. Don’t encrypt anything yet and use the inventory hosts from the earlier labs.
* The content of the file `MI6` should be:
  ```
    username: jamesbond
    password: miss_moneypenny
  ```
* Run the playbook and check if the file `/etc/MI6` has been deployed on the nodes.

{{% details title="Solution Task 1" %}}
```bash
$ cat mi6.j2
username: jamesbond
password: miss_moneypenny

$ cat secretservice.yml
---
- hosts: node1, node2
  become: true
  tasks:
    - name: put template
      template:
        src: mi6.j2
        dest: /etc/MI6

$ ansible-playbook secretservice.yml
$ ansible node1,node2 -a "cat /etc/MI6"  #<-- show created files with it's content
```
{{% /details %}}

### Task 2

* Make the playbook `secretservice.yml` use a variable file named `secret_vars.yml` with the content:
  ```
    var_username: jamesbond
    var_password: miss_moneypenny
  ```
* Rewrite the `mi6.j2` template to use the variables from the `secret_vars.yml` file. Nothing is encrypted yet.
* Rerun the playbook and remember nothing has been encrypted yet.

{{% details title="Solution Task 2" %}}

```bash
$ cat secret_vars.yml
---
var_username: jamesbond
var_password: miss_moneypenny

$ cat mi6.j2
username: {{ var_username }}
password: {{ var_password }}

$ cat secretservice.yml
---
- hosts: node1, node2
  become: true
  vars_files:
    - secret_vars.yml
  tasks:
    - name: put template
      template:
        src: mi6.j2
        dest: /etc/MI6

$ ansible-playbook secretservice.yml
```
{{% /details %}}

### Task 3

* Encrypt the `secret_vars.yml` file by using `ansible-vault` with the password *goldfinger*.

{{% alert title="Tip" color="info" %}}
You don’t have to set a label when encrypting the file.
{{% /alert %}}

* Rerun the playbook providing the password for decrypting `secret_vars.yml` at the command prompt.
* Create a file named `vaultpassword` containing the unencrypted string "goldfinger".
* Rerun the playbook providing the password for decrypting `secret_vars.yml` from the file `vaultpassword`.

{{% alert title="Tip" color="info" %}}
Since the password is in clear text in the file `vaultpassword`, you should never ever push it to a git repository or similar. Also double check that only the necessary permissions are set.
{{% /alert %}}

{{% details title="Solution Task 3" %}}
```bash
$ cat vaultpassword
goldfinger

$ ansible-vault encrypt secret_vars.yml --vault-id vaultpassword

$ ansible-playbook secretservice.yml --ask-vault-pass

$ ansible-playbook secretservice.yml --vault-id vaultpassword
```
{{% /details %}}

### Task 4

* Configure your environment to always use the `vaultpassword` file as the vault file.
* Rerun the playbook without providing the password or the password file at the command line.

{{% details title="Solution Task 4" %}}

Make sure you recieve the following output in your terminal:

```bash
$ grep ^vault /home/ansible/techlab/ansible.cfg
vault_password_file = /home/ansible/techlab/vaultpassword

$ ansible-playbook secretservice.yml
```

{{% /details %}}

### Task 5

* Decrypt the file `secret_vars.yml`.
* Encrypt the values of the variables `username` and `password` and put them into the `secret_vars.yml` file.

{{% alert title="Note" color="primary" %}}
Look for an option to `ansible-vault` to give the name of the variable while encrypting the value. This makes it easier to copy-paste the output later!
{{% /alert %}}

{{% details title="Solution Task 5" %}}

```bash
ansible-vault decrypt secret_vars.yml
echo "---" > secret_vars.yml
ansible-vault encrypt_string jamesbond -n var_username >> secret_vars.yml
ansible-vault encrypt_string miss_moneypenny -n var_password >> secret_vars.yml
```

Content of secret_vars.yml
```yaml
---
var_username: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          65336662623334393265373462616231323635623034653534393861666637333232383438393534
          3264376362633566313337333835313832376566343362330a636639346263323961636232306134
          35393462343935653031353430636666326232343565383330386339646436376265316264376366
          3336326566663033300a396666316461356336313564323236333138623465373439343032333930
          6664
var_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          33366638383438373238333335663933323663326630356564626139323135306563343335613331
          6534373239393234366431656234386232373331316634660a646665303838636465303638316366
          63393034643639393764666634303338636130326164366339303634643264646235323637326661
          3633393039613263390a653062383834323661386661313733393662393935663263633565396133
          3931
```
```bash
ansible-playbook secretservice.yml
```

{{% /details %}}

### Task 6

* Remove the `/etc/MI6` file on the nodes using an ad hoc command.

{{% details title="Solution Task 6" %}}
```bash
ansible node1,node2 -i hosts -b -m file -a "path=/etc/MI6 state=absent"
```

{{% alert title="Tip" color="info" %}}
Note that the `command` module is the `default` module and therefore has not to be specified here.
{{% /alert %}}

{{% /details %}}

### Task 7

* Encrypt another file `secret_vars2.yml`. Ensure it is encrypted with your vault password file `vaultpassword`
* Change the encryption of the file: encrypt it with another password provided at the command line.

{{% alert title="Note" color="primary" %}}
 Don't do this by decrypting & reencrypting but rather by using the `rekey` option.
 There's a trap hidden here. Double check if everything worked as you expected.
{{% /alert %}}

* Check the content of `secret_vars2.yml` by viewing it and providing the password at the command line.

{{% details title="Solution Task 7" %}}

```bash
ansible-vault encrypt secret_vars2.yml
```

Be sure to use `rekey` with `--new-vault-id`. By using `--vault-id`, `ansible-vault` would use the value from `vaultpasswordfile` and not the one asked for by using `@prompt`. This could be quite misleading... You can check the same unexpected behavior when trying to view an encrypted file with providing a wrong password at command line. Giving a wrong password after `ansible-vault view secret_vars2.yml --vault-id @prompt` still results in showing the decrypted content of the file when `ansible.cfg` points to the correct `vaultpasswordfile`.

There is an open [issue](https://github.com/ansible/ansible/issues/33831) about this topic on github.

```bash
ansible-vault rekey secret_vars2.yml --new-vault-id @prompt
ansible-vault view secret_vars2.yml --vault-id @prompt
```

{{% /details %}}

### Task 8

* What can you do, to avoid Ansible to print out sensitive data at runtime?

{{% alert title="Tip" color="info" %}}
Take a look at [docs.ansible.com](https://docs.ansible.com)
{{% /alert %}}

{{% details title="Solution Task 8" %}}
{{% alert title="Tip" color="info" %}}
See [Ansible Docs: Logging](https://docs.ansible.com/ansible/devel/reference_appendices/logging.html) and [Ansible Docs: FAQ - How do I keep secret data in my playbook?](https://docs.ansible.com/ansible/devel/reference_appendices/faq.html#keep-secret-data)
{{% /alert %}}

```bash
no_log: true
```

{{% /details %}}

### All done?

* [Ansible User Guide - Encrypting Content](https://docs.ansible.com/ansible/latest/user_guide/vault.html#vault)
* [generate encrypted passwords for the user module](https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#how-do-i-generate-encrypted-passwords-for-the-user-module)

---
title: "4.2 - Ansible Playbooks - Templates"
weight: 42
---

In this lab we start to use templates!

### Task 1

- Rewrite your playbook `motd.yml` without using the `copy` module, but rather using the `template` module.
- Use a jinja2 template file called `motd.j2` which uses the variable `motd_content`.

### Task 2

- Improve the template `motd.j2` by adding the default IP address of the server to the template.
- Add the installed operating system to the motd file aswell.

{{% notice tip %}}
  Remember using the setup module to get a list of all facts!
{{% /notice %}}

### Task 3 (Advanced)

Create a variable `users` like the following:

```yaml
users:
  - name: jim
    food: pizza
  - name: sabrina
    food: burger
  - name: hans
    food: vegan
  - name: eveline
    food: burger
  - name: santos
    food: kebab
```
Put the variable in an appropiate place of your choice.

Create a playbook userplay.yml doing the following on node1:

- Create a file /etc/dinner.txt with the content below by using the ansible module `template`:
  ```
  <name_of_user> <food_for_user>`
  ```
- There should be a entry in the file /etc/dinner.txt for each user in the variable users (use a for-loop in the template)
- If a user has no food specified, use kebab (have a look at "playbooks_filters" in the online docs)
- On node2 the same playbook userplay.yml should create a (linux) group for every different food specified in the variable users. If a user has no food defined, create the group kebab instead
- Create a user on node2 for every entry in the users variable. Ensure that this user is also in the group with the same name as his food. Again, if no food defined for this user, add group kebab

#### Bonus 1

- set the loginshell to /bin/zsh

#### Bonus 2
- if (and only if) the user is santos, disable login (means set the shell to /usr/sbin/nologin and use a if/else statement in the template to do so)

#### Bonus 3 
- Set the default password on all servers to "`N0t_5o_s3cur3!`"
- Once the password was set, your playbook should not set it again or set it back to the default value once changed.
- Hash the password using the sha512 algorithm.
- Don’t define a salt for the password.
- Verify that you are able to login as one of the users via ssh and providing the password.

{{% notice warning %}}
Be aware that it is NOT a good idea to set passwords in cleartext. We will learn in the lab about ansible-vault how to handle this in a better way. Never ever do this in a productive environment.
{{% /notice %}}

### Task 4 (Advanced)

Create a playbook serverinfo.yml that does the following:

- Place a file /root/serverinfo.txt on all nodes with a line like follows for each and every server in the inventory:
```  
server_hostname: OS: <operating system> IP: <IP address> Virtualization Role: <hardware type>
``` 

- Replace `operating system`, `IP address` and `hardware type` with a reasonable fact.
- Run your playbook and check on all servers (by using an ansible ad hoc command) if the content of the file `/root/serverinfo.txt` is as expected.


## Solutions

{{% collapse solution-1 "Solution 1" %}}

Create the file `motd.j2` with the following one liner:

```bash
$ cat motd.j2
{{ motd_content }}
```

Edit your `motd.yml` playbook to something like this:

```yaml
---
- hosts: all
  become: yes
  tasks:
    - name: set content of /etc/motd
        template:
        src: motd.j2
        dest: /etc/motd
```

Run the playbook again.
```bash
$ ansible-playbook motd.yml -l node1,node2
```
{{% /collapse %}}

{{% collapse solution-2 "Solution 2" %}}

Add IP and OS to `motd.j2`:

```bash
$ cat motd.j2
{{ motd_content }}
IP ADDRESS: {{ ansible_default_ipv4.address }}
OS:         {{ ansible_os_family }}
```

Rerun the playbook and login to a node to check if the text has been changed accordingly:

```bash
$ ansible-playbook motd.yml -l node1,node2
$ ssh -l ansible <node1-ip>
[3~Last login: Fri Nov  1 14:39:53 2019 from 5-102-146-174.cust.cloudscale.ch
This is node2

IP ADDRESS:     5.102.146.204
OS:             RedHat
[ansible@node2 ~]$
``` 
{{% /collapse %}}

{{% collapse solution-3 "Solution 3" %}}

{{% notice note %}}
Be aware that there are multiple possible solutions.
{{% /notice %}}

```bash
$ pwd
/home/ansible/techlab

$ cat uservars.yml
users:
  - name: jim
    food: pizza
  - name: sabrina
    food: burger
  - name: hans
    food: vegan
  - name: eveline
    food: burger
  - name: santos
    food: kebab

$ cat userplay.yml
---
- hosts: node1
  become: yes
  vars_files:
    - uservars.yml
  tasks:
    - name: put template
      template:
        src: user_template.j2
        dest: /etc/dinner.txt

- hosts: node2
  become: yes
  vars_files:
    - uservars.yml
  tasks:
    - name: create groups
      group:
        name: "{{ item.food | default('kebab') }}"
      with_items: "{{ users }}"
    - name: ensure zsh is installed
      yum:
        name: zsh
        state: installed
    - name: create users
      user:
        name: "{{ item.name }}"
        group: "{{ item.food | default('kebab') }}"
        append: yes
        shell: "{% if item.name == 'santos' %}/usr/sbin/nologin{% else %}/usr/bin/zsh{% endif %}"
        password: "{{ 'N0t_5o_s3cur3!' | password_hash('sha512') }}"
        update_password: on_create
      with_items: "{{ users }}"

$ cat user_template.j2
{% for person in users %}
{{ person.name }}               {{ person.food | default('kebab') }}
{% endfor %}
```

{{% notice tip %}}
See the user-module for how to set the password and search for a link to additional documentation about how to set passwords in Ansible.
{{% /notice %}}

Check on node1 (as user root) if everthing is as expected:

    # cat /etc/dinner.txt
    jim         pizza
    sabrina     burger
    hans        vegan
    eveline     burger
    santos      kebab

Check as well on node2 (as user root):
```bash
# grep  'jim\|sabrina\|hans\|eveline\|santos' /etc/passwd
jim:x:1002:1002::/home/jim:/usr/bin/zsh
sabrina:x:1003:1003::/home/sabrina:/usr/bin/zsh
hans:x:1004:1004::/home/hans:/usr/bin/zsh
eveline:x:1005:1003::/home/eveline:/usr/bin/zsh
santos:x:1006:1005::/home/santos:/usr/sbin/nologin

# grep  'pizza\|burger\|vegan\|kebab' /etc/group
pizza:x:1002:
burger:x:1003:
vegan:x:1004:
kebab:x:1005:
```

Login to node2 as user jim, providing the password via stdin:
```bash
$ ssh jim@node2
```


{{% /collapse %}}

{{% collapse solution-4 "Solution 4" %}}
Possible solution 1:
```bash
$ cat serverinfo.txt.j2 
{% for host in groups['nodes'] %}
{{ hostvars[host].ansible_hostname }}: OS: {{ hostvars[host].ansible_os_family }} IP {{ hostvars[host].ansible_default_ipv4.address }} Virtualization Role: {{ hostvars[host].ansible_virtualization_role }}
{% endfor %}

$ cat serverinfo.yml 
---
- hosts: all
  become: true
  tasks:
    - name: put serverinfo.txt
      template:
        src: serverinfo.txt.j2
        dest: /root/serverinfo.txt
```

Possible solution 2:
```bash
$ cat serverinfo.yml
---
- hosts: localhost
  tasks:
    - name: create the serverinfo file to be distributed later
      file:
        path: /home/ansible/techlab/serverinfo.txt
        state: touch

- hosts: all
  tasks:
    - name: fill in stuff to local serverinfo.txt
      lineinfile:
        path: /home/ansible/techlab/serverinfo.txt
        regexp: "^{{ ansible_hostname }}"
        line: "{{ ansible_hostname }}: OS: {{ ansible_os_family }} IP: {{ ansible_default_ipv4.address }} Virtualization Role: {{ ansible_virtualization_role }}"
      delegate_to: localhost

- hosts: all
  become: yes
  tasks:
    - name: place the file serverinfo.txt
      copy:
        src: /home/ansible/techlab/serverinfo.txt
        dest: /root/serverinfo.txt

$ ansible-playbook serverinfo.yml
$ ansible all -b -a "cat /root/serverinfo.txt"
```
{{% /collapse %}}
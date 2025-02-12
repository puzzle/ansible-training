# Ansible Techlab

### ansible.puzzle.ch

#### Lukas Grimm

<!-- #### Dominik Meisser -->

<!-- #### Lukas Preisig -->

<!-- #### Philippe Schmid -->

<!-- #### Rémy Keil -->

<!-- #### Daniel Kobras -->

<!-- #### Mark Pröhl -->

<!-- #### Florian Studer -->

<!-- .slide: class="master-cover" -->

***

## Nice to meet you

<!--
<div class="people" style="color: black;">
  <div>
    <div class="img" style="background-image: url(https://www.puzzle.ch/img/2024/06/Schmid_Philippe.jpg?w=900&h=900&fit=crop&fm=webp&q=90&sharp=4&s=f27e83a00061d8aa6266f3092b1b289c)" />
  </div>

  ### Philippe Schmid
  System Engineer

  pschmid@puzzle.ch
</div>

-->

![](https://www.puzzle.ch/img/2024/06/Grimm_Lukas.jpg?w=300&h=300&fit=crop&fm=webp&q=90&sharp=4&s=d42398d9832aa48066cb50daa8a895d6)

  ### Lukas Grimm
  Lead System Architect

  grimm@puzzle.ch

<!--
<div class="people">
  <div>
    <div class="img" style="background-image: url(https://www.puzzle.ch/wp-content/uploads/2020/08/Dominik_Meisser_wp-400x300.jpg)" />
  </div>

  ### Dominik Meisser
  System Engineer

  meisser@puzzle.ch
</div>

-->
<!--
<div class="people" style="color: black;">
<div>
    <div class="img" style="background-image: url(https://www.puzzle.ch/wp-content/uploads/2019/05/Preisig_Lukas-400x300.jpg)" />
    </div>

  ### Lukas Preisig
  System Engineer

  preisig@puzzle.ch
</div>
-->
<!--
<div>
    <div class="img" style="background-image: url(https://www.puzzle.ch/wp-content/uploads/2018/08/Test-Remy-Keil-Filter_2Option-400x300.jpg)" />
    </div>

  ### Rémy Keil
  System Engineer

  keil@puzzle.ch
</div>
-->

<!--
<div>
    <div class="img" style="background-image: url(https://www.puzzle.ch/wp-content/uploads/2022/06/Schmid_Philippe_wp.jpg)" />
    </div>

  ### Philippe Schmid
  System Engineer

  pschmid@puzzle.ch
</div>
-->

<!--
<div class="people">
  <div>
    <div class="img" style="background-image: url(https://www.puzzle.ch/wp-content/uploads/2019/06/Kobras_Daniel1-400x300.jpg)" />
  </div>

  ### Daniel Kobras
  Principal Architect

  kobras@puzzle-itc.de
</div>


<div class="people">
<div>
<div class="img" style="background-image: url(https://www.puzzle.ch/wp-content/uploads/2019/06/Proehl-Mark-400x300.jpg)" />
</div>

### Mark Pröhl
Principal Architect

proehl@puzzle-itc.de

</div>

-->
<!--
<div>
<div class="img" style="background-image: url(https://www.puzzle.ch/wp-content/uploads/2021/06/Florian_Studer_wp-400x300.jpg)" />
</div>

### Florian Studer
System Engineer

studer@puzzle.ch

</div>

-->
<!-- .slide: class="master-top-head" -->

***
## Alle Puzzler

![](https://www.puzzle.ch/img/2024/06/2024_Gruppenfoto_Puzzle-16x9-1000px-Breit.jpg?w=1000&h=561&fit=crop&fm=webp&q=90&sharp=4&s=5ec79746d78173920f663ca911d9ce86)"

  ### Members
  https://www.puzzle.ch/de/team

<!-- .slide: class="master-top-head" -->

***
## round of introductions

<div style="color: black;">

- Job? Ansible?
- Personal life?
- Hobbies?
</div>

<!-- .slide: class="master-top-head" -->

----
# Organization

- If you have Questions, ask!
<!-- .slide: class="master-content" -->

----
# Agenda
- Intro
- Basics
- Getting Help
- Ad hoc commands
- Plays
- Roles
- Ansible-Vault

<!-- .slide: class="master-agenda" -->

***
# Agenda
- Ansible Collections
- Lookup Plugins / Hashicorp Vault
- Ansible Automation Platform / AWX
- Demos
- Do It Yourself!

<!-- .slide: class="master-agenda" -->

----
<div>

# Labs
</div>
<div>

- always read all the tasks of a lab first
- do them one after the other (they depend on each other)
- copy-paste filenames and file content
- working directory: `/home/ansible/techlab/`
- solutions: web & folder
</div>
<!-- .slide: class="master-left-right" -->

***
<div>

# Labs
</div>
<div>

- The labs get harder quickly!
- You dont need to do all labs to understand the content
- Some labs are **HARD**!
- See "All done?" for more content
</div>
<!-- .slide: class="master-left-right" -->


***

<div>

# Labs
</div>
<div>

- Connect with ssh to servers
- Theia-IDE on controller: https://<dns-name>
- `ineedhelp` → tmux session and gotty

</div>
<!-- .slide: class="master-left-right" -->

----

# Intro

<!-- .slide: class="master-title"> -->

***
<div>

## Ansible @ Puzzle

- «Wartungsfenster» script
- automation cluster setup
- cloud-migration
- Techlab setup
</div>
<div>

![ansible-logo](ansible-techlab/img/ansible-logo.png)
</div>

<!-- .slide: class="master-left-right"> -->

Note:
Automatisierung unserer monatlichen Updates/Restart
SLOG Cluster Automatisierung
Migration von RZ in die Cloud mit Wechsel von Puppet auf Ansible
Eure Lab-VMs werden vollautomatisch mit Ansible Deployed und provisioniert

***
<div class="small">

## Ansible history

- 1966 Ursula K.Le Guin «Rocannon's World»
→ instant communication system
- 2012 Michael DeHaan (Cobbler, Puppet)
- 2015 RedHat acquires Ansible Inc.
- 2019 Ansible 2.9
- 2020-08-13 Ansible-Base 2.10
- 2021-02-18 Ansible 3.0
</div>
<div>

![rocannons world](ansible-techlab/img/rocannonsworld.jpg)
</div>
<!-- .slide: class="master-left-right" -->

***
<div class="small">

## Rocannon's World

“You remember the ansible, the big machine I showed you in the ship, which can speak instantly to other worlds, with no loss of years—it was that that they were after, I expect. It was only bad luck that my friends were all at the ship with it. Without it I can do nothing.”
</div>
<div>

![rocannons world](ansible-techlab/img/rocannonsworld.jpg)
</div>
<!-- .slide: class="master-left-right" -->

***

## Ansible Versions

- Ansible 2.9   -->   one thing! (Collections as preview)
- Ansible 2.10  -->   Ansible-Base 2.10 + Collections
- Ansible 2.11  -->   (not available, naming changes to Ansible 3.0)
- Ansible 3.0   -->   Ansible-Core 2.10 + Collections v3
- Ansible 4.0   -->   Ansible-Core 2.11 + Collections v4
- [..]
- Ansible 10.0  -->   Ansible-Core 2.17 + Collections v10
- Ansible 11.0  -->   Ansible-Core 2.18 + Collections v11 (Current, not working with EL8)
- Ansible 12.0  -->   Ansible-Core 2.19 + Collections v12 (In development, unreleased)

<!-- .slide: class="master-content" > -->
<!-- .slide: class="master-content" > -->
----

# Basics

<!-- .slide: class="master-title"> -->

***
## How stuff works?


<img alt='workflow1' src="ansible-techlab/img/ansible_workflow_1.png" width="600"/>

<!-- .slide: class="master-content" > -->
***

## How stuff works?

<img alt='workflow2' src="ansible-techlab/img/ansible_workflow_2.png" width="600"/>

<!-- .slide: class="master-content" > -->

Note:
- ssh to client
- copy python script (/tmp)
- run python script
- delete python script
- python2 or python3

***

## How stuff works?

- Common Setup
  - One control node
  - One or many nodes to configure
  - (pull vs push)

<!-- .slide: class="master-content" > -->

Note:
Zentraler Controlnode erleichtert das auswerten von Logs im Team
pull (Puppet way) vs push (ansible way) --> push braucht weder daemon noch sonst was

***

## Requirements

- Control Node
  - ansible installed (newer versions via «pip»)
  - Nice to have: AWX / AAP / CI/CD-Pipeline
- Client
  - ssh, python


<!-- .slide: class="master-content" > -->

***

## Many possibilities...

- Transporters:
`ssh`, `local`, `winrm`, `docker`,...
- Modules:
`file`, `template`, `firewalld`, `service`, `yum`,...
- Dynamic inventories:
`vmware`, `cloudscale`, `foreman`, `azure`, `aws`,...

<img alt='azure' src="ansible-techlab/img/azure.png" width="52"/> <img alt='aws' src="ansible-techlab/img/aws.png" width="52"/> <img alt='cloudscale' src="ansible-techlab/img/cloudscale.png" width="52"/> <img alt='vmware' src="ansible-techlab/img/vmware.png" width="52"/> <img alt='foreman' src="ansible-techlab/img/foreman.png" width="52"/>
<!-- .slide: class="master-content" > -->

***

## Why Ansible?

- Simple setup (yum install ansible)
- Agentless
- Standard transport (ssh)
- Easy (relatively), yaml
- Many modules (~~2834~~, ~~3387~~, ~~4573~~, ∞ )
<!-- .slide: class="master-content" > -->

***

## Why cows?
```
 __________________
< PLAY [localhost] >
 ------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
<!-- .slide: class="master-content" > -->
***

## Why cows?

- programm "cowsay"
- was default configuration
- → Ansibull → The Bullhorn, ansibullbot
- still can be enabled:

"$ ANSIBLE_NOCOWS=0 ansible-playbook plays/site.yml"

<!-- .slide: class="master-content" > -->

***

## Commands

What do we use on cmdline?
- `ansible` (ad hoc execution)
- `ansible-playbook`
- `ansible-doc`
- `ansible-vault` (secrets management)
- `ansible-config`
<!-- .slide: class="master-content" > -->

***

## Commands (cont.)

- `ansible-galaxy` (roles/collection management)
- `ansible-inventory`
- `ansible-lint` (syntax check)
- `ansible-pull`
<!-- .slide: class="master-content" > -->

***

## Important Parts
- inventory
- ansible.cfg
- ssh-keys
- best practice:
`user ansible + sudo`

<!-- .slide: class="master-content" > -->

***

## File formats

- **YAML**  (tasks, vars, playbooks... | .yml, .yaml)
- JSON (returned stuff, custom fact | .json)
- INI (inventory | .ini)
- jinja2 (templates | .j2)
<!-- .slide: class="master-content" > -->

***

## YAML

```yaml
---
execution:
- concurrency: 10
  hold-for: 5m
  ramp-up: 2m
  scenario: yaml_example

scenarios:
  yaml_example:
    retrieve-resources: false
    requests:
      - http://example.com/

reporting:
- module: final-stats
- module: console

settings:
  check-interval: 5s
  default-executor: jmeter

provisioning: local
```
<!-- .slide: class="master-content" > -->

***
## json

```json
{
    "execution": [
        {
            "concurrency": 10,
            "hold-for": "5m",
            "ramp-up": "2m",
            "scenario": "json_example"
        }
    ],
    "scenarios": {
        "json_example": {
            "retrieve-resources": false,
                "requests": [
                    "http://example.com/"
                ]
        }
    },
    "reporting": [
        {
            "module": "final-stats"
        },
        {
            "module": "console"
        }
    ],
    "settings": {
        "check-interval": "5s",
        "default-executor": "jmeter"
    },
    "provisioning": "local"
}
```
<!-- .slide: class="master-content" > -->

***

## Security

- SSH
- root privileges
- Malware in ansible-code? → opensource...
<!-- .slide: class="master-content" > -->

***

## Tooling

- Linux: Help yourself!
- Windows:
  - VS Code + Git for Windows
  - WSL

<img alt="vscode" src="ansible-techlab/img/vscode.png" width="52"/> <img alt="gitforwin" src="ansible-techlab/img/gitforwin.png" width="52"/>
<!-- .slide: class="master-content" > -->
***
## Lab Environment

- Linux: Help yourself!
- Theia-IDE: Short Introduction

<!-- .slide: class="master-content" > -->

***

# Lab 1: Setting up Ansible

<!-- .slide: class="master-title" > -->
----

# Getting Help

<!-- .slide: class="master-title"> -->
***
## Documentation

- https://docs.ansible.com/
- `ansible-doc -l`

  `ansible-doc <module>`

  `ansible-doc -s <module>`

<!-- .slide: class="master-content"> -->
***
## Documentation Example
  - part of ansible-doc

  `ansible-doc <module> | grep -A20 EXA`
- `/usr/share/doc`
<!-- .slide: class="master-content" > -->
***
## Troubleshoot

- Read the output :-)
- Increase verbosity (`-vvvv`)
- Google it :-)
- `ansible-lint` (install via package manager)
- `ansible-playbook --syntax-check`
- `ansible-playbook --check`
- AI -> ChatGPT can fix, but isn't good at writing -> More AI later
<!-- .slide: class="master-content" > -->
***
## Common Mistakes
### Indentation
wrong:
```yaml
- ansible.builtin.yum:
  name: httpd
  state: installed
```
right:
```yaml
- ansible.builtin.yum:
    name: httpd
    state: installed
```

<!-- .slide: class="master-content" > -->
***
## Common Mistakes
### quoting of variables or spacing
wrong:
```yaml
- ansible.builtin.service:
    name: {{ item }}
    state: started
  loop: "{{my_services}}"
```
right:
```yaml
- ansible.builtin.service:
    name: "{{ item }}"
    state: started
  loop: "{{ my_services }}"
```
<!-- .slide: class="master-content" > -->
***
## Common Mistakes
### Become root if necessary!

`become: true`

to install packages, create users, etc...
<!-- .slide: class="master-content" > -->
***
<div>

## Feel nerdy? Devel docs!
Documentation in development:

https://docs.ansible.com/ansible/devel/

→ learn about the future of ansible
</div>
<div>

![nerd](ansible-techlab/img/nerd.png)
</div>
<!-- .slide: class="master-left-right" > -->
***
# Lab 2: Documentation

<!-- .slide: class="master-title" > -->
----
# Ad hoc
### (+ inventory)


<!-- .slide: class="master-title"> -->
***
## Ad hoc commands
- «single task», «cluster ssh»
- specify:
  - node(s) / group(s)
  - (inventory)
  - (what module)
  - (options to module)

<!-- .slide: class="master-content" > -->
***
## Ad hoc commands
Examples:
- `ansible all -m ansible.builtin.ping`
- `ansible all -m ansible.builtin.setup`

ansible.builtin.setup → get «facts»
<!-- .slide: class="master-content" > -->
***
## Ad hoc flags
- `man ansible`
- `-m` module (get list with ansible-doc -l)
- `-b` become (mostly root)
- `-i` inventory
- `-C` check mode
- `-l` limit to (groups or hosts)
- `-v` verbose
<!-- .slide: class="master-content" > -->
***
## Ad hoc commands
Examples:
- `ansible all -b -m ansible.builtin.yum -a "name=httpd state=present"`
- `ansible all -b -m ansible.builtin.service -a "name=httpd state=started"`
- `ansible all -a "uptime"`

<!-- .slide: class="master-content" > -->
***
## Inventories

Mandatory!

Example (ini format:)
```ini
[control]
control0
[web]
node1
node2
[db]
node[3:99]
```
<!-- .slide: class="master-content" > -->
***
## Inventories
- We use INI format
- YAML possible
- Static inventory (file)
- Dynamic inventory (get info from azure, vmware, foreman... )
- Can be folder with multiple inv-files (static & dynamic)
- Location can be defined in `ansible.cfg`
<!-- .slide: class="master-content" > -->

***
# Lab 3: Setup and Ad Hoc Commands

<!-- .slide: class="master-title" > -->
----
# Plays
### (+ Variables + Templates)


<!-- .slide: class="master-title"> -->
***
## Plays / Playbook

playbook → collection of plays

<img alt='playbook' src='ansible-techlab/img/playbook.png' width="200em" />
<!-- .slide: class="master-content" > -->

Note:
Kommt aus dem Eishockey: Spielablauf
Das gleiche bei Ansible

***
## Plays

> What to do where and how

Very simple example:

```yaml
---
- hosts: web
  tasks:
  - name: install httpd
    ansible.builtin.yum:
      name: httpd
      state: installed
```
To use `name` is a best practice
<!-- .slide: class="master-content" > -->

Note:
Ein Play ist was, wo, wie gmacht wird

***
## Plays
"Baby-JSON" possible

same as before:

```yaml
---
- hosts: web
  tasks:
  - name: install httpd
    yum: name=httpd state=installed
```

Not Best Practice!
<!-- .slide: class="master-content" > -->

Note:
Syntax ist anders als bei Ad-Hoc Befehl, also Best Practice kein Baby Json

***
## Plays

A bit more complex:

```yaml
- hosts: database
  become: true
  tasks:
    - name: install mariadb
      ansible.builtin.yum:
        name: mariadb
        state: installed
    - name: start mariadb
      ansible.builtin.service:
        name: mariadb
        state: started
```
<!-- .slide: class="master-content" > -->

***
## Plays

- YAML
- Idempotent!

Note:

Play sollten immer in YAML geschrieben werden
Idempotent: Man sollte es mehrmals ausführen können und das gleiche dabei rauskommen. Wikipedia:

Idempotence (UK: /ˌɪdɛmˈpoʊtəns/, US: /ˌaɪdəm-/) is the property of certain operations in mathematics and computer science whereby they can be applied multiple times without changing the result beyond the initial application. The concept of idempotence arises in a number of places in abstract algebra (in particular, in the theory of projectors and closure operators) and functional programming (in which it is connected to the property of referential transparency).

The term was introduced by Benjamin Peirce in the context of elements of algebras that remain invariant when raised to a positive integer power, and literally means "(the quality of having) the same power", from idem + potence (same + power).

***
# Lab 4.0: Ansible Playbooks - Basics

<!-- .slide: class="master-title" > -->
***
## Variables
Why? Where to define variables?
- on cmdline
- in playbook
- group_vars and host_vars
- default/vars file of role (see later...)
- starts with letter or underscore
<!-- .slide: class="master-content" > -->

***
## Where to put variables
defined in playbook:

```yaml
---
- hosts: web
  become: true
  vars:
    my_package: nginx
  tasks:
  - name: install nginx
    ansible.builtin.yum:
      name: "{{ my_package }}"
      state: installed
```

<!-- .slide: class="master-content" > -->

***
## Where to put variables

`ansible-playbook myplay.yml --extra-vars my_package="nginx"`

<!-- .slide: class="master-content" > -->

Note:

-- extra-vars für Command "vars", always win precedence

***
## Where to put variables
group_vars and host_vars
```
inventory/
├── group_vars/
│ └── web.yml
├── hosts
└── host_vars/
  └── node2.yml
```
Name of file in group_vars / host_vars
**MUST** match name of group / host in
inventory!
<!-- .slide: class="master-content" > -->

Note:
die vars-Ordner müssen im selben Ordner liegen wie das Inventory

***
## Variables

Complex variables possible!

```yaml [1-8|9-14]
- name: win1
  ip: 10.20.30.40
  ram: 24576
  partitions:
    - name: C
      size: 100G
    - name: D
      size: 60G
- name: win2
  ip: 10.20.30.50
  ram: 24576
  partitions:
    - name: C
      size: 100G
```
<!-- .slide: class="master-content" > -->

***
## Magic Variables

- special variables:
    - google «ansible special variables»
- inventory_hostname
(The inventory name for the ‘current’ host
being iterated over in the play)
- group_names
(List of groups the current host is part of)
<!-- .slide: class="master-content" > -->

Note:
variable precedence
https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#understanding-variable-precedence

Don't name your Variables after Magic Variables

***

## Bonus Level: Loops!
```yaml
- name: start and enable two services
  ansible.builtin.service:
    name: "{{ item }}"
    state: started
    enabled: yes
  loop:
    - nginx
    - firewalld
```

Note:

"with_items" & "loop" possible, "with_*" is discouraged in favor of "loop"
https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html#migrating-to-loop

<!-- .slide: class="master-content" > -->

***

# Lab 4.1: Ansible Playbooks - Variables and Loops

<!-- .slide: class="master-title" > -->

***

## Templates

- "template" is a module
- Jinja2 → .j2 file ending
- Easy access of variables: `"{{ my_variable }}"`
- Access to the same variables as the play itself
- Easy if-else statements, for-loops etc.
<!-- .slide: class="master-content" > -->

Note:
Templates sind dafür da, um komplexe Files zu erstellen (Variabeln sowie `if` / `else` / `for` sind möglich)

***

## Templates

- template task hosts.yml

```yaml
---
- name: Building /etc/hosts from template with variables
  ansible.builtin.template:
    src: hosts.j2
    dest: "/etc/hosts"
    mode: "0644"
```

- `cat hosts.j2`

```jinja
{% for vm in virtualmachines %}
{{ vm.ip }}  {{ vm.name }}
{% endfor %}
```
<!-- .slide: class="master-content" > -->
***

## Tags
- run only specific parts of a playbook
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html

<!-- .slide: class="master-content" > -->
***
## Tags
Example:
```yaml
- hosts: all
  become: true
  tasks:
    - name: Install ntp
      ansible.builtin.yum:
        name: ntp
        state: present
      tags: ntp
    - name: Install figlet
      ansible.builtin.yum:
        name: figlet
        state: present
      tags: figlet
```
ansible-playbook -t ntp myplaybook.yml

<!-- .slide: class="master-content" > -->
***
# Lab 4.2: Ansible Playbooks - Templates

<!-- .slide: class="master-title" > -->
***
## Registering output into variable

Use `register` to put output command into variable
```yaml
- name: output ls -lah to variable
  ansible.builtin.command: 
    cmd: "ls -lah"
    chdir: /home/ansible
  register: output_var
```

Show content of variable using debug. Note that you can use return
values `stdout`, `stderr` and more when processing the output

```yaml
- ansible.builtin.debug:
    var: output_var
- ansible.builtin.debug:
    msg: "{{ output_var.stdout }}"
```
<!-- .slide: class="master-content" > -->
***
## Conditionals

- Use `when` to run a task only on certain conditions

```yaml
- name: run command only when...
  ansible.builtin.command: "uptime"
  when: ansible_hostname == "servername1"
```

- Use `failed_when` to define a task as «failed»

```yaml
- name: fails when error in stdout
  ansible.builtin.command: "grep -i error /var/log/mylog"
  register: output
  failed_when: " 'error' in output.stdout"
```

- Use `changed_when` to define a task as «changed»

<!-- .slide: class="master-content" > -->

Note:
Nicht nur in Templates sind `when` Conditions möglich

***

# Lab 4.3: Ansible Playbooks - Output

<!-- .slide: class="master-title" > -->
***

## Ansible-pull
- Inverted Architecture:
- pull playbook and inventory from git repo and apply it
- no local config used
- git repo mandatory
- no stuff stored locally
- yum install ansible → ansible-pull
<!-- .slide: class="master-content" > -->

***

## Ansible-pull Example

```bash
$ ansible-pull \
-U https://github.com/puzzle/ansible-techlab \
-i <inventory> \
<playbookname.yml>
```
default playbook: `local.yml`
<!-- .slide: class="master-content" > -->

Note:
Pull kehrt einfach die Logik um. Man holt sich die Befehle und schickt sie nicht.

***

# Lab 4.4: Ansible-Pull

<!-- .slide: class="master-title" > -->
***

## Task control

- «async»: define how long to wait at max for a task to finish. (ad hoc → -B)
- «poll»: Interval at which ansible checks back if task has finished. Default: 10sec (ad hoc → -P)
-  Fire and forget: «async = x » AND «poll = 0»

<!-- .slide: class="master-content" > -->

Note:
Mit Task Kontrolle kann man definieren, wie Ansible auf die Nodes zugreift.

***

## Task control Examples:

Ad-Hoc command:

```bash
ansible node1 -i hosts -B 10 -P 2 -m ansible.builtin.yum -a "name=my_package state=present"
```

Task:

```yaml
- name: fire and forget
  ansible.builtin.yum:
    name: my_package
    state: installed
  async: 60 #← needed as well
  poll: 0
```
<!-- .slide: class="master-content" > -->
***

## Task control
Retrieve status of a command that was fired and forgotten → module `ansible.builtin.async_status`

→ module docs

Only works when async = x and poll = 0 !
<!-- .slide: class="master-content" > -->
***
## Task control

Define batch size in play:

```yaml
- hosts: all
  serial: 5
- hosts: all
  serial:
    - 1
    - 10
    - 100%
```
<!-- .slide: class="master-content" > -->
***
## Task control
max_fail_percentage:

```yaml
- hosts: all
  serial: 10
  max_fail_percentage: 49
```
→ stops when 5 nodes fail

If set to 50 it would stop if 6 nodes fail...
<!-- .slide: class="master-content" > -->
***
## Task control

Forks:

Default: 5 forks

```bash
$ ansible all -i hosts -m ansible.builtin.ping -f 50
```
Ansible.cfg:

```ini
[defaults]
forks = 30
```

But → mind your controller's processing power...

<!-- .slide: class="master-content" > -->

Note:
Mit Forks könnt ihr den Control Node in die Knie zwingen

***
## Task control

Fact gathering:

```yaml
- hosts: all
  gather_facts: no
...
```

Ansible.cfg:

```ini
gathering = implicit (default, bedeutet gather_facts: yes)
```

explicit → gather_facts: no
<!-- .slide: class="master-content" > -->
***
# Lab 4.5: Task control
<!-- .slide: class="master-title" > -->

----

## Bonus Level: Ansible on Windows
- No Windows as ansible control host! cygwin etc not supported...
- But: Works on WSL...
- Maaaaaany modules for win
  - win_service
  - win_updates
  - win_chocolatey
  - win_shell
<!-- .slide: class="master-content" > -->
***
## Bonus Level: Ansible on Windows
- Connection via winrm → somewhat complicated...
- OpenSSH available as "installable feature" on WinServer2019 / Win10
```powershell
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
```
<!-- .slide: class="master-content" > -->
***
## Bonus Level: Ansible on Network Devices
- Many vendors supported ( 490... «ios» modules)
- ssh connection still needed...
----
# Roles

### (+ galaxy + handlers + errorhandling)


<!-- .slide: class="master-title"> -->
***
## Roles

- Why?
  - bundle tasks, reuse stuff
  - Make «tasks» independent from inventory
  - info in playbooks:
- what (roles) is run where (inventory)
  - Example roles:
  - base
  - httpd
  - mariadb

<!-- .slide: class="master-content" > -->
***
## Roles
Example (no roles yet):

```yaml
- hosts: web
  become: true
  tasks:
    - ansible.builtin.yum:
        name: httpd
        state: installed
    - service:
        name: httpd
        state: started
```
<!-- .slide: class="master-content" > -->
***
## Roles

Example:

```yaml
- hosts: web
  become: true
  roles:
    - httpd
```
<!-- .slide: class="master-content" > -->
***
## Roles
- roles_path in ansible.cfg (default /etc/ansible/roles)
- Well defined structure (see later)
- Use only parts of the structure you really need!
- ansible-galaxy:

online collection of roles (and more)

https://galaxy.ansible.com/

(github as well!)
<!-- .slide: class="master-content" > -->
***
## Roles
Quite handy:
```bash
ansible-galaxy role init <rolename>
```

→ creates default folder-structure
<!-- .slide: class="master-content" > -->
***
## Roles

```
Base/
├── defaults
│ └── main.yml
├── files
├── handlers
│ └── main.yml
├── meta
│ └── main.yml
├── README.md
├── tasks
│ └── main.yml
├── templates
├── tests
│ ├── inventory
│ └── test.yml
└── vars
  └── main.yml
```
Remember: only use folders/files you really need!
<!-- .slide: class="master-content" > -->
***
## Roles
- defaults/ default values of vars if not defined somewhere else
- meta/ additional information (f.e. dependencies to other roles)
- test/ testing your roles against a «test» inventory
- vars/ variables (precedence over group_vars / host_vars)
<!-- .slide: class="master-content" > -->
***
## Lab 5: Ansible Roles - Basics
<!-- .slide: class="master-title" > -->
***

## Handlers

Do stuff when state changed after task...

Example:
- restart service after change of config file...
- custom scripts after software upgrade...
- Handler is not a roles feature. Can be used in playbooks as well.
<!-- .slide: class="master-content" > -->
***
## Handlers
Which handler is triggered?
The task's value of `notify` must match the handler's value of `name` or `listen`
<!-- .slide: class="master-content" > -->
***
## Handlers
Example Playbook:

```yaml [1|2-8|9-12]
- hosts: all
  tasks:
    - name: put configuration file
      ansible.builtin.template:
        src: templates/sshd_config.j2
        path: /etc/ssh/sshd_config
        validate: sshd -t %s
        mode: "0644"
      notify: restart sshd
  handlers:
    - name: restart sshd
      ansible.builtin.service:
        name: sshd
        state: restarted
```
<!-- .slide: class="master-content" > -->
***
## Handlers
Example Playbook:

```yaml [8|10|13]
- hosts: all
  tasks:
    - name: put configuration file
      ansible.builtin.template:
        src: templates/sshd_config.j2
        path: /etc/ssh/sshd_config
        validate: sshd -t %s
        mode: "0644"
      notify: restart sshd
  handlers:
    - name: sshd restart
      ansible.builtin.service:
        name: sshd
        state: restarted
      listen: restart sshd
```
<!-- .slide: class="master-content" > -->
***
## Handlers
Caveat:
- Are only run once at the end of play-run (not playbook-run) → Use "flush_handlers":

```yaml
- ansible.builtin.meta: flush_handlers
```
<!-- .slide: class="master-content" > -->
***
## Handlers
Caveat:

- If multiple handlers have the same name:

only the last will be run
- But: each handler that has a matching «listen» is triggered

→ best practice: use «listen»
<!-- .slide: class="master-content" > -->
***
## Handlers
Only second handler will run when a task notifies `restart web services`

```yaml
handlers:
  - name: restart web services
    ansible.builtin.service:
      name: memcached
      state: restarted
  - name: restart web services
    ansible.builtin.service:
      name: apache
      state: restarted
```
<!-- .slide: class="master-content" > -->
***
## Handlers
Both handlers are run when a task notifies `restart web services`
```yaml[6,11]
handlers:
  - name: Restart memcached
    ansible.builtin.service:
      name: memcached
      state: restarted
    listen: "restart web services"
  - name: Restart apache
    ansible.builtin.service:
      name: apache
      state: restarted
    listen: "restart web services"
```
<!-- .slide: class="master-content" > -->
***
## Handlers
Last slide not entirely true...
```yaml
- hosts: all
  become: true
  pre_tasks:
    - name: ...
  tasks:
    - name: ...
  post_tasks:
    - name: ...
```

Handlers are triggered after pre_tasks, tasks, post_tasks...
<!-- .slide: class="master-content" > -->
***
## Error-Handling
Continue even when task failed:

`ignore_errors: yes`

(status is still failed, but run continues)

`failed_when: true`

(status always failed)

<!-- .slide: class="master-content" > -->
***
## Error-Handling
Define failed from output of command:

```yaml
- name: my task
  ansible.builtin.command: my_status_cmd
  register: cmd_result
  failed_when: "'FAILED' in cmd_result.stdout"
```
https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html
<!-- .slide: class="master-content" > -->
***
## Bonus Level: Blocks!

```yaml
- block:
    # do stuff 
  rescue:
    # do this if block failed
  always:
    # do this always
```
<!-- .slide: class="master-content" > -->
***
## Bonus Level: Blocks!

```yaml
- block:
    - name: i force a failure
      ansible.builtin.command: /bin/false
    - ansible.builtin.debug:
        msg: i will not run because false before
  rescue:
    - ansible.builtin.debug:
        msg: i will run
  always:
    - ansible.builtin.debug:
        msg: i will always run
```
<!-- .slide: class="master-content" > -->
***
## Bonus Level: Blocks!
Blocks can come in handy to group `when` clauses:
```yaml
- block:
    - ansible.builtin.debug:
        msg: 'this task...'
    - ansible.builtin.debug:
        msg: '...and this task will run if the host is in the web group'
  when: 'web' in groups
```

But: no loops over `block`. Use loops with `ansible.builtin.include_tasks` instead
<!-- .slide: class="master-content" > -->
***
# Lab 5.1: Ansible Roles - Handlers and Blocks

<!-- .slide: class="master-title" > -->
----
# AnsibleVault


<!-- .slide: class="master-title"> -->
***
## Ansible Vault
- How to store sensitive stuff?
  - Passwords in git-repo?
  - Private keys?
  - Certificates?

→ Ansible Vault !

<!-- .slide: class="master-content" > -->
***
## Ansible Vault
- command: `ansible-vault`
- options:
  - encrypt, encrypt-string, decrypt
  - view, edit, rekey
- also tasks, handlers can be encrypted...
<!-- .slide: class="master-content" > -->
***
## Ansible Vault
- via input
- uses a password(-file)
- via location of file in ansible.cfg
<!-- .slide: class="master-content" > -->
***
## Ansible Vault
Multiple passwords possible:
- `ansible-vault encrypt --vault-id label1@vaultfile1 foo.yml`

or

- `ansible-vault encrypt --vault-id label2@vaultfile2 foo.yml`

<!-- .slide: class="master-content" > -->
***
## Ansible Vault
Example:
```bash
$ ansible-vault encrypt_string --vault-id dev@vaultfile 'mystring' --name 'mysecret'
mysecret: !vault |
    $ANSIBLE_VAULT;1.2;AES256;dev
    430616365613033383736613138383335656536353531
    662376365373339383063313833393532653632396439
    39666639386530626330633337633833
```

<!-- .slide: class="master-content" > -->
***
## Ansible Vault
- Attention: Password in Output?
- Use `no_log: true` !
<!-- .slide: class="master-content" > -->
***
# Lab 6: Managing Secrets with Ansible Vault

<!-- .slide: class="master-title" > -->

***
## Hashicorp Vault
- high availability
- different permissions for different users and groups
- centralized place to store secrets

<img alt='hashivault' src='ansible-techlab/img/hashivault.png' height="100em" />

<!-- .slide: class="master-content" > -->
***
## Hashicorp Vault
- ansible can use Hashicorp vault secrets
- python library needed: `hvac`

```yaml
ansible.builtin.debug:
  msg: "{{ lookup('hashi_vault',<params>) }}"

vs

debug:
ansible.builtin.debug:
  msg: "{{ my_encrypted_var }}"
```

<!-- .slide: class="master-content" > -->

***
## Lookup Plugins
- access data from outside sources
- files, databases, key/value stores, APIs, Password-Managers, etc.
- ansible-doc -t lookup -l
- https://docs.ansible.com/ansible/latest/plugins/lookup.html


<!-- .slide: class="master-content" > -->
***
## Lookup Plugins Examples
```yaml
vars:
  file_contents: "{{ lookup('file', 'path/to/file.txt') }}"
  ipv4: "{{ lookup('dig', 'example.com.')}}"

```

<!-- .slide: class="master-content" > -->

***
## Hashicorp Vault
```yaml
debug:
  msg: "{{ lookup('hashi_vault', \
           'secret=secret/hello:value \
           token=c975b7...0f9b688a5 \
           url=http://myvault:8200' \
        )}}"
```

<!-- .slide: class="master-content" > -->

***
## Hashicorp Vault

Simpler: set Environment Variables
```
VAULT_ADDR=https://vault.puzzle.ch
VAULT_TOKEN=<your token>
```
<!-- .slide: class="master-content" > -->
***
## Hashicorp Vault
```
base_root_pw: "{{ lookup('community.hashi_vault.hashi_vault', \
                  'secret=kv/data/spaces/company/prod/root:rootpw_crypted') }}"
```

<!-- .slide: class="master-content" > -->

***
# CI/CD Pipelines DEMO

<!-- .slide: class="master-title" > -->

----
# Ansible Collections


<!-- .slide: class="master-title" > -->

***
## Collections
- What is a Collection?
- different kind of ansible content ( playbooks, roles, modules, plugins...)
- Well defined structure (see later)
<!-- .slide: class="master-content" > -->

Note:
Ist eine Zusammenzug von verschiedenen Ansible komponenten

***

## Collections
-  Why Collections?

Problem:
- High numbers of modules increases complexity of release
- New features of plugins only in new ansible release

Solution:
- With collections, plugins (modules) can have their own release cycle

<!-- .slide: class="master-content" > -->

***
## Collections

- Since Ansible 2.9 as Tech-Preview:
- Ansible 2.10 comes as ACD (Ansible Community Distribution)
- ACD consists of:
  - Ansible-Base (~70 core plugins)
  - Collections (additional stuff)

<!-- .slide: class="master-content" > -->

Note:
Bei 2.9 nur Techpreview dann ab 2.10 Bestanteil

***
## Collections
- Ansible 2.9 → one thing! (Collections as preview)
- Ansible 2.10 → Ansible-Base 2.10 + Collections
- Ansible 2.11 → (not available, naming changes to Ansible 3.0)
- Ansible 3.0 → Ansible-Base 2.10 + Collections
- Ansible 4.0 → Ansible-Core 2.11 + Collections

<!-- .slide: class="master-content" > -->

Note:
Version Chaos
Bei Enterprise OS habt ihr ziemlich sicher 2.9

***
## Collections
-  companies offer support for their collections:

Red Hat, Azure, VMWare, Cisco, Checkpoint, F5, IBM, NetApp...

<!-- .slide: class="master-content" > -->


***
## Collections
- Name of collection is always like:

  "namespace.collectionname"

Example:
- `community.kubernetes`
- `puzzle.puzzle_collection`
  -> FQCN

<!-- .slide: class="master-content" > -->

***
## Collections
-  Creation of Namespace:
  - first login into Galaxy with GitHub credentials →
  - namespace created automatically (username)
- Github issues for other namespaces

<!-- .slide: class="master-content" > -->

***
## Collections

Example structure:
```
$ ansible-galaxy collection init puzzle.puzzle_collection
puzzle
└── puzzle_collection
├── docs
├── galaxy.yml
├── plugins
│
 └── README.md
├── README.md
└── roles
```

Details about structure in
https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html#collection-structure

<!-- .slide: class="master-content" > -->

***
## Collections
Where to get collections?

When using local collections:

Set `COLLECTIONS_PATHS` in ansible.cfg

(use `ansible-config dump` to what is set)

<!-- .slide: class="master-content" > -->

***
## Collections

Where to get collections?

Configure your servers in ansible.cfg:

```ini
[galaxy]
server_list = automation_hub, puzzle_hub, release_galaxy, test_galaxy
[galaxy_server.puzzle_hub]
url=https://hub.puzzle.ch/
username=<username>
password=<secret_password>
```

Note:
Man zeht sich in der Regel Collection von einem Hub/Github
Red Hat Automation Hub Beispiel

<!-- .slide: class="master-content" > -->

***
## Collections

Where to get collections?

Configure automation hub in ansible.cfg:

```ini
[galaxy]
server_list = automation_hub, puzzle_hub, release_galaxy, test_galaxy
[galaxy_server.automation_hub]
url=https://cloud.redhat.com/api/automation-hub/
auth_url=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
token=dumdidupdiduuuuuuperduuuups...
```

Get token from:

https://cloud.redhat.com/ansible/automation-hub/token/

<!-- .slide: class="master-content" > -->

***
## Collections

Where to get collections?

Configure automation hub in ansible.cfg:

→ not enough when using AAP

Settings → Jobs →
```
url=      → PRIMARY GALAXY SERVER URL
auth_url= → PRIMARY GALAXY AUTHENTICATION URL
token=    → PRIMARY GALAXY SERVER TOKEN
```

<!-- .slide: class="master-content" > -->

***
## Collections

Where to get collections?

Tower:

collections/requirements.yml

→ needed for Tower to download collections
→ AAP uses EE's

<!-- .slide: class="master-content" > -->

***
## Collections

How to use collections?

Use collection in playbook:

```yaml
---
- hosts: puzzle_nodes
  collections:
    - puzzle.puzzle_collection
  tasks:
    - name: use my module
      my_module:
        option: bliblub
...

OR:

---
- hosts: puzzle_nodes
  tasks:
    - name: use my module
      puzzle.puzzle_collection.my_module:
        option: bliblub
...
```

<!-- .slide: class="master-content" > -->

***
## Collections
How to use collections?

Install collection:
```bash
ansible-galaxy collection install puzzle.puzzle_collection
ansible-galaxy collection install puzzle.puzzle_collection-1.0.0.tar.gz
```

Initialize collection:
```bash
ansible-galaxy collection init puzzle.puzzle_collection
```

<!-- .slide: class="master-content" > -->

***
## Collections

How to use collections?

Build collection:
```bash
ansible-galaxy collection build puzzle.puzzle_collection
```

Must have: galaxy.yml with infos!

Results in a tar.gz of the collection

<!-- .slide: class="master-content" > -->

***
## Collections

How to use collections?

Publish collection:
```bash
ansible-galaxy collection publish puzzle.puzzle_collection
```

Nota Bene: Collection is published with the namespace and name defined in
galaxy.yml!

<!-- .slide: class="master-content" > -->

***
## Automation Hub

official location to discover and download supported (by RH) collections

part of the Red Hat Ansible Automation Platform subscription

https://cloud.redhat.com/api/automation-hub/ (token required)

Red Hat Ansible Automation Platform subscription ≃ Red Hat Ansible Tower subscription

<!-- .slide: class="master-content" > -->

***
# Lab 8. Ansible Collections

<!-- .slide: class="master-title" > -->
----
# Ansible-Navigator

### (+ Ansible-Builder)


<!-- .slide: class="master-title"> -->
***

## New terms

- execution environment
- ansible-runner
- ansible-navigator
- ansible-builder

<!-- .slide: class="master-content" > -->

***
## Execution Environments

- it's a container!
- place where ansible is run
  (vs. local python)
- Advantage:
  it's a container!

<!-- .slide: class="master-content" > -->

***


## Execution Environments

Container with:
- ansible
- ansible collections
- python
- python modules
- binaries

<!-- .slide: class="master-content" > -->

***
## Execution Environments

- built with ansible-builder
- (uses different containers)
- beware of transparent proxy :-/

<!-- .slide: class="master-content" > -->

***

## ansible-runner

3 things:

1. tool
2. container and
3. python library

Goal:
- stable and consistent interface to Ansible


<!-- .slide: class="master-content" > -->

***

## ansible-runner

- Interface accepts multiple kinds of input:
  - python module parameters
  - cmdline arguments (like ansible-playbook)
  - can be a directory structure
    [ansible runner introduction](https://ansible-runner.readthedocs.io/en/stable/intro/)
    [ansible runner demonstration](https://github.com/ansible/ansible-runner/tree/devel/demo)

<!-- .slide: class="master-content" > -->

***

## ansible-runner

- runs ansible and ansible-playbook tasks
- gathers information of ansible runs

<!-- .slide: class="master-content" > -->

***

## ansible-runner

- Container:
  https://quay.io/repository/ansible/ansible-runner

- Docs:
  https://ansible-runner.readthedocs.io/en/stable/


<!-- .slide: class="master-content" > -->

***

## ansible-navigator

It's a text-based user interface (TUI)!

- wraps old functionality
- adds new stuff

<!-- .slide: class="master-content" > -->

***
## ansible-navigator

- available through Red Hat subscription (repo) or pip
- needs `podman` (default) or `docker`
- initial download of demo Execution Environment (EE)
- configuration per project possible

<!-- .slide: class="master-content" > -->
***

## ansible-navigator subcommands

Known functionality:
- config
- doc
- run
- inventory

<!-- .slide: class="master-content" > -->
***
## ansible-navigator subcommands

New functionality:
- collections
- images
- replay
- log

<!-- .slide: class="master-content" > -->
***


## ansible-navigator config file

- `ansible-navigator.yml`

Options:
- https://readthedocs.org/projects/ansible-navigator/ and
- `ansible-navigator --help`

BEWARE: set `remote_user` when using EE!

<!-- .slide: class="master-content" > -->
***

# Lab 10.0: Ansible-Navigator

<!-- .slide: class="master-title" > -->
***

## ansible-builder

Tool to build your own EE

- local config file
- creates podman context and runs it
- uses two other containers:
  ansible-builder and ansible-runner

<!-- .slide: class="master-content" > -->
***

## ansible-builder config files

- your-ee.yml for your ee
- requirements.txt for python
- requirements.yml for collections
- bindep.txt for system binaries
- ansible.cfg
- additional_build_steps


<!-- .slide: class="master-content" > -->
***

# Lab 10.1: Ansible-Builder

<!-- .slide: class="master-title" > -->
***


# Ansible Automation Platform


<!-- .slide: class="master-title" > -->
***
## Naming
- Ansible Tower --> Ansible Controller
- python venv   --> Execution Environments
- Automation Platform =

  Ansible Controller +
  Execution Environment +
  Automation Hub (private)

<!-- .slide: class="master-content" > -->

***

## Ansible Controller
- Central place to run playbooks
- Gets information from git repo
- Same result as running on command line
- Community project: AWX

![awx](ansible-techlab/img/awx.png)

<!-- .slide: class="master-content" > -->

***

## Ansible Controller
Watch out:

Some configs from ansible.cfg not taken!

<!-- .slide: class="master-content" > -->

***

## Ansible Controller
- Pros:
  - «who run what job where?» vs «root access»
  - scheduling, notifications
  - Execution Environments (vs. pipenv)
  - teams with different permissions
  - teams can use credentials without knowing them
  - Controller can be configured using ansible modules :-)
    (awx.awx)
- Cons:
  - price?

<!-- .slide: class="master-content" > -->

***

## Ansible Controller

- why no AWX?

- Install somewhat complicated
- Upgrade Paths available


<!-- .slide: class="master-content" > -->

***

## Ansible Controller

- Install:
  - Download tar.gz. contains a setup.sh
  - setup.sh does ansible magic! :-)
  - Standalone or bundled installer
  - Need for a license file! (no subscription)

<!-- .slide: class="master-content" > -->

***

## AWX
- Install:
- Supports only installation via Operator on
  - OpenShift
  - Kubernetes
  - Docker Compose (also possible but not really supported)

<!-- .slide: class="master-content" > -->

***
## Alternatives to AAP/AWX?

- Cron
- Jenkins
- Gitlab
- Github
- ...

<!-- .slide: class="master-content" > -->

----
# Event Driven Ansible

<!-- .slide: class="master-title" > -->

***
## History

- Feb 2022: ansible-rulebook on Github
- Dec 2022: Dev Preview RH
- Mai 2023: Part of AWX/AAP 2.4

<!-- .slide: class="master-content" > -->

***
## Basics

- if-then logic
- cli component of EDA: ansible-rulebook

<!-- .slide: class="master-content" > -->

***
## Playbook vs Rulebook

- ansible-runner, ansible-playbok
  - starts when defined by user
- ansible-rulebook
  - daemon, waits for event

<!-- .slide: class="master-content" > -->

***
## Getting Info

- https://ansible-rulebook.readthedocs.io
- https://www.redhat.com/en/interactive-labs/
- https://www.ansible.com/blog
- https://ansible.puzzle.ch

<!-- .slide: class="master-content" > -->

***
## Glossary

- Rulebook: one ore many Rulesets
- Ruleset:  Source(s), Rule(s)
- Rule:     Condition(s) (IF), Action(s) (THEN)

<!-- .slide: class="master-content" > -->

***
## Sources

- alertmanager, zabbix, sensu
- Paolo Alto, F5, Cisco
- Azure, GCP, AWS
- many more to come...

<!-- .slide: class="master-content" > -->

***
## Conditions

"if-part"
- int, strings, bools, floats, null
- regexp

<!-- .slide: class="master-content" > -->

***
## Actions

"then-part"
- run_playbook
- run_job_template
- debug, set_fact, run_module,...

<!-- .slide: class="master-content" > -->

***
## Getting Info

- https://ansible-rulebook.readthedocs.io
- https://www.redhat.com/en/interactive-labs/
- https://www.ansible.com/blog
- https://ansible.puzzle.ch

<!-- .slide: class="master-content" > -->

***
## Installation

- ansible-rulebook (python package)
- ansible.eda (collection)
- java17 / drools

<!-- .slide: class="master-content" > -->

***
## How to use it

ansible-rulebook --rulebook my_rb.yml -i hosts

<!-- .slide: class="master-content" > -->

***
## Sample Rulebook

- name: rebuild webservers if site down
  hosts: web
  sources:
    - ansible.eda.url_check:
        urls:
          - http://<servername>:80/
  rules:
    - condition: event.url_check.status == "down"
      action:
        run_playbook:

<!-- .slide: class="master-content" > -->

***
## Event-Source Information

- events -> json
- accessible inside playbook with:
  "{{ ansible_eda.event(s) }}"

<!-- .slide: class="master-content" > -->

***
## Events vs Facts

- technically the same
- events are discarded right after condition met
- facts are longlived events

<!-- .slide: class="master-content" > -->

***
## Facts

- set with set_facts action
- retracted with retract_facts action
- only valid per ruleset (!!!)

<!-- .slide: class="master-content" > -->

----
# Best Practices

<!-- .slide: class="master-title" > -->

***
## Ansible Docs:
- Have a look at the EXAMPLE section in the module documentation
- Very interesting tips:

https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html

<!-- .slide: class="master-content" > -->

***
## Infrastructure:
- install ansible from package manager, not pip (because of virtenv)
- keep your ansible-stuff in a git repository
- Use ssh connection to clients, use ssh-keys
- Connect as user ansible, use sudo for privilege escalation

<!-- .slide: class="master-content" > -->

***
## Infrastructure:
- Start doing config changes only through ansible, limit root access to servers if possible
- Use controllers to run ansible on your infrastructure, dont run from your laptop
- Use a tool like Ansible Controller, AWX, Jenkins, GitLab, Github...

<!-- .slide: class="master-content" > -->

***
## Migration to Ansible (from Puppet?):
- You can run both tools at the same time if people fear they are not ready yet
- Keep puppet infrastructure working but disable it
- Migrate the puppet-modules to ansible-roles step by step. You DONT have to have ALL content ready from start (it probably not realistic)

<!-- .slide: class="master-content" > -->

***
## Ansible Content:

- Use `name` in all your tasks! Be specific enough...
- Booleans:

  Use `true` / `false` (yaml 1.2 supports only this)

- Handlers: use «listen»

<!-- .slide: class="master-content" > -->

***
## Ansible Content:
Roles:
- Prefix all variables of a role with its role-name (possible exception: base role)
- Put all used variables in your defaults-folder , even if not yet defined
- Use «meta: flush_handler» at the end of a role to be sure all role-related stuff is run even if a later applied role fails.
- when many import_tasks: prefix name with filename

<!-- .slide: class="master-content" > -->

***
## Ansible Content:
Templates:
- Use `{{ ansible_managed | comment }}` at the beginning of the template to indicate, that the file is managed by
ansible

Files:
- Use a comment at the beginning of the file to indicate, that the file is managed by ansible

<!-- .slide: class="master-content" > -->

***
## Ansible Content:

Ansible-Vault:
-  Use encrypt_string to encrypt each variable seperately and not a complete vars-file.

   Reason being: You still see which variable has changed in your git repo

<!-- .slide: class="master-content" > -->

***
## Ansible Content:
When writing ansible-content in a team:
- Define some standards (role-prefixed variables, snake_case for variables/handlers ...)
- **But**: dont discuss too much about how a problem is solved. There are simply different kind of views.

<!-- .slide: class="master-content" > -->

***
## Ansible Content:
- Always set file permissions explicitly
- Use file/template instead of lineinfile/blockinfile

<!-- .slide: class="master-content" > -->

***
## AI and Ansible
- Copilot is apperantly pretty good in helping you write ansible
- ChatGPT is good in fixing syntax and logic errors
- Ansible-Lightspeed -> 60d Trial, after that AAP and IBM watsonx Subscription

----
# Do it yourself!

<!-- .slide: class="master-title" > -->

----
# And now?
-  https://www.ansible.com/blog
-  https://www.meetup.com/Ansible-Bern
-  https://ansible.puzzle.ch/ (more content to come...)
-  https://www.puzzle.ch/de/blog/categories/technologien/ansible
-  → Feedback

<!-- .slide: class="master-content" > -->

----
# Merci!
### Mehr Informationen zu Puzzle:
### www.puzzle.ch

<!-- .slide: class="master-thanks"> -->

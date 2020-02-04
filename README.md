# Puzzle ITC Ansible Techlab

In the guided hands-on techlab, we show the participants the Ansible basics.

For more see [Puzzle Ansible Techlabs online](https://ansible.puzzle.ch/).

:rocket: Changing IT for the better with Ansible!

## Content Sections

The Techlab content resides within the [content](content) directory.

The main part are the labs, which can be found at [content/labs](content/labs).

## Hugo

Ansible Techlab is built using the static page generator [Hugo](https://gohugo.io/) and published under [ansible.puzzle.ch](https://ansible.puzzle.ch/).

The page uses the [dot theme](https://github.com/themefisher/dot) which is included as a Git Submodule.

After cloning the main repo, you need to initialize the submodule like this: 

```bash
git submodule update --init --recursive
``` 

## Build using Docker

Build the image:

```bash
docker build --build-arg HUGO_BASE_URL=http://localhost:8080/ -t puzzle/ansible-techlab:latest .
```

Run it locally:

```bash
docker run -i -p 8080:8080 puzzle/ansible-techlab
```

## Contributions

If you find errors, bugs or missing information please help us improve our techlab and have a look at the [Contribution Guide](CONTRIBUTING.md).

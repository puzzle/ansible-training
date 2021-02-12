# Puzzle ITC Ansible Training

In the guided hands-on training, participants are able to learn the basics of [Ansible](https://www.ansible.com/).

For more see [Puzzle Ansible Training online](https://ansible.puzzle.ch/).

:rocket: Changing IT for the better with Ansible!

## Content Sections

The training content resides within the [content](content) directory.

The main part are the labs, which can be found at [content/en/docs](content/en/docs).

## Hugo

This site is built using the static page generator [Hugo](https://gohugo.io/).

The page uses the [docsy theme](https://github.com/google/docsy) which is included as a Git Submodule.
Docsy is being enhanced using [docsy-plus](https://github.com/puzzle/docsy-plus/) as well as [docsy-puzzle](https://github.com/puzzle/docsy-puzzle/).

After cloning the main repo, you need to initialize the submodules:

```bash
git submodule update --init --recursive
```

In order to update all submodules, run the following command:

```bash
git pull --recurse-submodules
```

### Docsy Theme Usage

* [Official docsy documentation](https://www.docsy.dev/docs/)
* [Docsy Plus](https://github.com/puzzle/docsy-plus/)

### Update submodules for theme updates

Run the following command to update all submodules with their newest upstream version:

```bash
git submodule update --remote
```

## Build using Docker

Build the image:

```bash
docker build . -t puzzle/ansible-techlab:latest
```

Run it locally:

```bash
docker run -i -p 8080:8080 puzzle/ansible-techlab
```

## Contributions

If you find errors, bugs or missing information, please help us improve our training and have a look at the [Contribution Guide](CONTRIBUTING.md).

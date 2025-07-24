# Puzzle ITC Ansible Training

In the guided hands-on training, participants are able to learn the basics of [Ansible](https://www.ansible.com/).

For more see [Puzzle Ansible Training online](https://ansible.puzzle.ch/).

:rocket: Changing IT for the better with Ansible!

## Content Sections

The training content resides within the [content](content) directory.

The main part are the labs, which can be found at [content/en/docs](content/en/docs).

## Hugo

This site is built using the static page generator [Hugo](https://gohugo.io/).

The page uses the [docsy theme](https://github.com/google/docsy).
Docsy is being enhanced using [docsy-plus](https://github.com/acend/docsy-plus/) as well as [docsy-puzzle](https://github.com/puzzle/docsy-puzzle/).

### Docsy Theme Usage

* [Official docsy documentation](https://www.docsy.dev/docs/)
* [Docsy Plus](https://github.com/acend/docsy-plus/)

## Build using Docker

Build the image:

```bash
docker build . -t puzzle/ansible-techlab:latest
```

Run it locally:

```bash
docker run -i -p 8080:8080 puzzle/ansible-techlab
```

## Maintenance

This project is actively maintained by the Puzzle ITC team. We aim to:

* Respond to issues and pull requests within one week
* Make decisions on contributions within one month
* Keep dependencies up to date
* Address security vulnerabilities promptly

## Support

For questions or support, please [open an issue](https://github.com/puzzle/ansible-training/issues).

## Contributions

If you find errors, bugs or missing information, please help us improve our training and have a look at the [Contribution Guide](CONTRIBUTING.md).

## Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Security

For security-related concerns, please see our [Security Policy](SECURITY.md).

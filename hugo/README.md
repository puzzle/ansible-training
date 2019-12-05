### Puzzle Ansible Techlab Hugo Setup 

This page uses the [dot theme](https://github.com/themefisher/dot).

Add the theme as git submodul:
```bash
git submodule add git@github.com:themefisher/dot-hugo-documentation-theme.git themes/dot
```

## Docker

Build the image:

```bash
docker build --build-arg HUGO_BASE_URL=https://ansible.puzzle.ch/ -t puzzle/ansible-techlab:latest .
```

Run:

```bash
docker run -i -p 8080:8080  puzzle/ansible-techlab
```

Push:

```bash
docker push puzzle/ansible-techlab:latest
```

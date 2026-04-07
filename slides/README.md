# Ansible Training Slides

```
podman build . -t ansible-slides:latest -f slides/Dockerfile
podman run -ti --rm -p 1948:8000 ansible-slides
```

<http://localhost:1948>

## Rendering using mkslides

```
pipx install mkslides
mkslides serve -f metadata.yaml ansible-techlab/
```

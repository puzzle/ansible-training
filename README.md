# Docsy Puzzle

Additions for the [docsy theme](https://github.com/google/docsy) for [Hugo](https://gohugo.io/), used for [Puzzle](https://puzzle.ch/) training content.
The docsy-acend theme inherites from the docsy theme through Hugos [Theme Components](https://gohugo.io/hugo-modules/theme-components/).

The theme adds the following to the standard docsy theme:

* Puzzle ITC colors scheme and fonts
* Puzzle ITC logo

## Installation

To add the [docsy](https://github.com/google/docsy), [docsy-plus](https://github.com/puzzle/docsy-plus) and docsy-puzzle themes to an existing Hugo project, run the following commands from your project’s root directory:

```sh
git submodule add https://github.com/google/docsy.git themes/docsy
git submodule add https://github.com/puzzle/docsy-plus.git themes/docsy-plus
git submodule add https://github.com/puzzle/docsy-puzzle.git themes/docsy-puzzle
git submodule update --init --recursive
```

Reference both themes in your configuration, the docsy-puzzle theme needs to come before docsy.

Example config.toml:

```toml
theme = ["docsy-puzzle", "docsy-plus", "docsy"]
```

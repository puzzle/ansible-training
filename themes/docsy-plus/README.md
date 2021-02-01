# Docsy Plus

Additions for the [docsy theme](https://github.com/google/docsy) for [Hugo](https://gohugo.io/), used for training content.
The docsy-plus theme inherites from the docsy theme through Hugos [Theme Components](https://gohugo.io/hugo-modules/theme-components/).

## Installation

To add the docsy and docsy-plus themes to an existing Hugo project, run the following commands from your project’s root directory:

```sh
git submodule add https://github.com/google/docsy.git themes/docsy
git submodule add https://github.com/puzzle/docsy-plus.git themes/docsy-plus
git submodule update --init --recursive
```

Reference both themes in your configuration, the docsy-plus needs to come first.

Example config.toml:

```toml
theme = ["docsy-plus", "docsy"]
```

## Shortcodes

For docsy shortcodes see here: [Docsy Shortcodes](https://www.docsy.dev/docs/adding-content/shortcodes/).

## Enhanced Cover Block

The blocks/cover shortcode from [docsy](https://www.docsy.dev/docs/adding-content/iconsimages/#add-images) has been enhanced in order to support config-dependend background an logo images.

If you add an imagePrefix setting under your site params, this prefix is used to search for background and logo images.

As example with the following setting...

```toml
[params]
imagePrefix = "fancy_"
```

... background images which contain "fancy_background" and logo images with "fancy_logo" in the filename are detected.

## Details

A shortcode to generate HTML _details_ and _summary_ tags, which is handy to make solutions-sections foldable.

Usage:

```html
{{% details title="Lab 1" %}}
Lab 1 solution
{{% /details %}}
```

## OnlyWhen and OnlyWhenNot

This shortcode is used to display or hide content based on enabled modules.

Example module configuration within your sites config.toml:

```toml
enabledModule = "base extra"
```

Use the shortcode as follows:

```html
{{% onlyWhen extra %}}
This is only displayed if extra is enabled.
{{% /onlyWhen %}}

{{% onlyWhenNot extra %}}
This only shown if extra is NOT enabled.
{{% /onlyWhenNot %}}
```

Use `{{< onlyWhen extra >}}` in plain HTML files

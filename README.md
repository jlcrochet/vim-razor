# vim-razor

This plugin provides filetype support &mdash; including syntax highlighting and indentation &mdash; for [Razor](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/razor) markup files. Out of the box, it detects `*.cshtml` and `*.razor` file extensions.

## Installation

This is a standard Vim plugin which can be installed using your plugin manager of choice. If you do not already have a plugin manager, I recommend [vim-plug](https://github.com/junegunn/vim-plug).

Alternatively, if you are using Vim 8 or NeoVim, you can install this plugin as a package; see `:h packages` for instructions.

## Configuration

#### `g:razor_cs_shiftwidth`

If defined, overrides `shiftwidth` for C# lines; this is useful if you want HTML and C# in the same file to be indented differently.

As an example, if your `shiftwidth` for HTML is 2 but you want to use 4 spaces for C#: `let g:razor_cs_shiftwidth = 4`.

If you want to use *tabs* instead of spaces for C#: `let g:razor_cs_shiftwidth = 0`.

#### `g:razor_js_shiftwidth`

If defined, overrides `shiftwidth` for JavaScript lines.

#### `g:razor_css_shiftwidth`

If defined, overrides `shiftwidth` for CSS lines.

#### `g:razor_fold`

If true, Razor blocks will be folded.

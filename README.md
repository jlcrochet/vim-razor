## Introduction

This plugin provides filetype support &mdash; including syntax highlighting and indentation &mdash; for [Razor](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/razor) markup files. Out of the box, it detects `*.cshtml` and `*.razor` files.

Custom highlighting is defined for HTML and C# by this plugin in order to ensure that they are properly integrated; this highlighting will only affect Razor files, not regular HTML and C# files. If you'd like to use the C# highlighting for regular C# files as well, you can install my [vim-cs](https://github.com/jlcrochet/vim-cs) plugin.

## Installation

This is a standard Vim plugin which can be installed using your plugin manager of choice. If you do not already have a plugin manager, I recommend [vim-plug](https://github.com/junegunn/vim-plug).

## Configuration

#### `g:razor_cs_shiftwidth`

If defined, overrides `shiftwidth` for C# lines; this is useful if you want HTML and C# in the same file to be indented differently.

As an example, if your `shiftwidth` for HTML is 2 but you want to use 4 spaces for C#:
    let g:razor_cs_shiftwidth = 4
If you want to use *tabs* instead of spaces for C#:
    let g:razor_cs_shiftwidth = 0

#### `g:razor_js_shiftwidth`

If defined, overrides `shiftwidth` for JavaScript lines; this is useful if you want HTML and JavaScript in the same file to be indented differently.

As an example, if your `shiftwidth` for HTML is 2 but you want to use 4 spaces for JavaScript:
    let g:razor_js_shiftwidth = 4
If you want to use *tabs* instead of spaces for JavaScript:
    let g:razor_js_shiftwidth = 0

#### `g:razor_css_shiftwidth`

If defined, overrides `shiftwidth` for CSS lines; this is useful if you want HTML and CSS in the same file to be indented differently.

As an example, if your `shiftwidth` for HTML is 2 but you want to use 4 spaces for CSS:
    let g:razor_css_shiftwidth = 4
If you want to use *tabs* instead of spaces for CSS:
    let g:razor_css_shiftwidth = 0

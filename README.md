# vim-razor

![vim-razor demo](demo.png)

## Description

This plugin provides filetype support -- including syntax highlighting and indentation -- for [Razor](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/razor) markup files. Out of the box, it detects `*.cshtml` and `*.razor` file extensions.

## Configuration

`g:razor_indent_shiftwidth`:
* If defined, overrides `shiftwidth` for C# lines; this is useful if you want HTML and C# in the same file to be indented differently.

`g:razor_fold`:
* If true, Razor blocks will be folded.

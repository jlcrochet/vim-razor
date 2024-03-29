## Introduction

This plugin provides filetype support &mdash; including syntax highlighting and indentation &mdash; for [Razor](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/razor) markup files. Out of the box, it detects `*.cshtml` and `*.razor` files.

Custom highlighting is defined for HTML and C# by this plugin in order to ensure that they are properly integrated; this highlighting will only affect Razor files, not regular HTML and C# files. If you'd like to use the C# highlighting for regular C# files as well, you can install my [vim-cs](https://github.com/jlcrochet/vim-cs) plugin.

## Installation

This is a standard Vim plugin which can be installed using your plugin manager of choice. If you do not already have a plugin manager, I recommend [vim-plug](https://github.com/junegunn/vim-plug).

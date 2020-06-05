# Description

This plugin provides syntax highlighting and indentation for [Razor](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/razor) markup files. Out of the box, it detects `*.cshtml` and `*.razor` file extensions.

This is only configured to work with the default HTML and C# plugins that are delivered with Vim; it is not guaranteed to work if the default plugins have been modified, replaced, or removed for whatever reason.

This plugin is likely incomplete in its current state, but it is already better than any other Razor plugin I've found. I will continue to update it as I learn more about Razor.

# Configuration

`g:razor_highlight_cs`: (WIP)
* `"full"`: Highlight C# tokens in both expressions and blocks (default)
* `"half"`: Highlight C# tokens in blocks, but not expressions
* `"none"`: Do not highlight C# tokens in either expressions or blocks

Any C# tokens that are not highlighted will receive the `razorExpression` highlighting, which defaults to `PreProc`.

`g:razor_indent_shiftwidth`:
* If defined, overrides `shiftwidth` for C# lines; this is useful if you want HTML and C# to be indented differently.

`g:razor_fold`:
* If defined, razor blocks will be folded.

# TODO

* Finish `g:razor_highlight_cs`
* Improve highlighting and indentation to cover more cases

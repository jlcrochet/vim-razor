" Vim autoload file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Caching important highlight ID's for faster lookup
const g:razor#indent#comment = hlID("razorComment")
const g:razor#indent#comment_delimiter = hlID("razorCommentDelimiter")
const g:razor#indent#cs_string = hlID("razorcsString")
const g:razor#indent#cs_comment = hlID("razorcsComment")
const g:razor#indent#cs_comment_delimiter = hlID("razorcsCommentDelimiter")
const g:razor#indent#html_comment = hlID("razorhtmlComment")
const g:razor#indent#html_tag = hlID("razorhtmlTag")
const g:razor#indent#html_end_tag = hlID("razorhtmlEndTag")
const g:razor#indent#delimiter = hlID("razorDelimiter")
const g:razor#indent#block = hlID("razorBlock")
const g:razor#indent#cs_block = hlID("razorcsBlock")
const g:razor#indent#html_script = hlID("razorhtmlScript")
const g:razor#indent#html_style = hlID("razorhtmlStyle")
const g:razor#indent#html_attribute = hlID("razorhtmlAttribute")

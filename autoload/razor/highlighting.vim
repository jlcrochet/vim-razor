" Vim autoload file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Caching important highlight ID's for faster lookup
const g:razor#highlighting#comment = hlID("razorComment")
const g:razor#highlighting#comment_end = hlID("razorCommentEnd")
const g:razor#highlighting#cs_string = hlID("razorcsString")
const g:razor#highlighting#cs_string_end = hlID("razorcsStringEnd")
const g:razor#highlighting#cs_comment = hlID("razorcsComment")
const g:razor#highlighting#cs_comment_end = hlID("razorcsCommentEnd")
const g:razor#highlighting#html_comment = hlID("razorhtmlComment")
const g:razor#highlighting#html_tag = hlID("razorhtmlTag")
const g:razor#highlighting#html_end_tag = hlID("razorhtmlEndTag")
const g:razor#highlighting#delimiter = hlID("razorDelimiter")
const g:razor#highlighting#cs_delimiter = hlID("razorcsDelimiter")
const g:razor#highlighting#block = hlID("razorBlock")
const g:razor#highlighting#cs_block = hlID("razorcsBlock")
const g:razor#highlighting#html_script = hlID("razorhtmlScript")
const g:razor#highlighting#html_style = hlID("razorhtmlStyle")
const g:razor#highlighting#html_attribute = hlID("razorhtmlAttribute")

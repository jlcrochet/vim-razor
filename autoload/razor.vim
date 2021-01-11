" Vim autoload file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@hey.com>
" URL: github.com/jlcrochet/vim-razor

" Caching important highlight ID's for faster lookup
const g:razor#comment = hlID("razorComment")
const g:razor#comment_delimiter = hlID("razorCommentDelimiter")
const g:razor#cs_string = hlID("razorcsString")
const g:razor#cs_comment = hlID("razorcsComment")
const g:razor#cs_comment_delimiter = hlID("razorcsCommentDelimiter")
const g:razor#html_comment = hlID("razorhtmlComment")
const g:razor#html_tag = hlID("razorhtmlTag")
const g:razor#html_end_tag = hlID("razorhtmlEndTag")
const g:razor#delimiter = hlID("razorDelimiter")
const g:razor#block = hlID("razorBlock")
const g:razor#cs_block = hlID("razorcsBlock")
const g:razor#html_script = hlID("razorhtmlScript")
const g:razor#html_style = hlID("razorhtmlStyle")
const g:razor#html_attribute = hlID("razorhtmlAttribute")

" Vim autoload file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Caching important highlight ID's for faster lookup

const g:razor#html_tag = hlID("razorhtmlTag")
const g:razor#delimiter = hlID("razorDelimiter")
const g:razor#cs_brace = hlID("razorcsBrace")
const g:razor#comment = hlID("razorComment")
const g:razor#cs_comment = hlID("razorcsComment")

" Vim autoload file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Caching important highlight ID's for faster lookup

let g:razor#hl_razorHTMLTag = hlID("razorHTMLTag")
let g:razor#hl_razorDelimiter = hlID("razorDelimiter")
let g:razor#hl_razorCSBrace = hlID("razorCSBrace")

lockvar g:razor#hl_razorHTMLTag g:razor#hl_razorDelimiter g:razor#hl_razorCSBrace

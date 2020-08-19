" Vim autoload file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Caching important highlight ID's for faster lookup

let g:razor#hl_razorComment = hlID("razorComment")
let g:razor#hl_razorCSComment = hlID("razorCSComment")
let g:razor#hl_razorHTMLComment = hlID("razorHTMLComment")
let g:razor#hl_razorHTMLTag = hlID("razorHTMLTag")
let g:razor#hl_razorDelimiter = hlID("razorDelimiter")
let g:razor#hl_razorCSBrace = hlID("razorCSBrace")
let g:razor#hl_razorBlock = hlID("razorBlock")
let g:razor#hl_razorCSBlock = hlID("razorCSBlock")
let g:razor#hl_razorInnerHTML = hlID("razorInnerHTML")

lockvar
      \ g:razor#hl_razorComment g:razor#hl_razorCSComment
      \ g:razor#hl_razorHTMLComment g:razor#hl_razorHTMLTag
      \ g:razor#hl_razorDelimiter g:razor#hl_razorCSBrace
      \ g:razor#hl_razorBlock g:razor#hl_razorCSBlock
      \ g:razor#hl_razorInnerHTML

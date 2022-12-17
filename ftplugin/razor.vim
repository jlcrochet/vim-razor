" Vim ftplugin file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Only do this when not done yet for this buffer
if get(b:, "did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

runtime! ftplugin/html.vim

setlocal
      \ comments=s1:@*,mb:*,ex:*@,:///,://
      \ commentstring=@*\ %s\ *@
      \ suffixesadd=.cshtml,.razor

let b:undo_ftplugin = "setlocal comments< commentstring< suffixesadd<"

" Change the :browse filter to primarily show HTML-related files.
"
" NOTE: Modified from ftplugin/html.vim to include Razor files
if has("gui_win32")
  if exists("b:browsefilter")
    let b:browsefilter = "Razor Files (*.cshtml,*.razor)\t*.cshtml;*.razor\n"..b:browsefilter
  else
    let b:browsefilter = "Razor Files (*.cshtml,*.razor)\t*.cshtml;*.razor\n"
  endif

  let b:undo_ftplugin ..= " | unlet b:browsefilter"
endif

" Vim ftplugin file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

runtime! ftplugin/html.vim

" Change the :browse e filter to primarily show HTML-related files.
"
" NOTE: Modified from ftplugin/html.vim to include Razor files
if has("gui_win32")
    let  b:browsefilter="Razor Files (*.cshtml,*.razor)\t*.cshtml;*.razor\n" .
		\	"HTML Files (*.html,*.htm)\t*.htm;*.html\n" .
		\	"JavaScript Files (*.js)\t*.js\n" .
		\	"Cascading StyleSheets (*.css)\t*.css\n" .
		\	"All Files (*.*)\t*.*\n"
endif

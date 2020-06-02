" Vim indent file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Setup {{{1
" =====

if exists("b:did_indent")
  finish
endif

if !exists("*HtmlIndent")
  runtime! indent/html.vim
  unlet! b:did_indent
endif

if !exists("*GetCSIndent")
  runtime! indent/cs.vim
  unlet! b:did_indent
endif

setlocal indentexpr=GetRazorIndent(v:lnum)
exec "setlocal indentkeys=<>>,".&cinkeys

let b:did_indent = 1

" Only define the function once per session
if exists("*GetRazorIndent")
  finish
endif

" Return the value of a single shift-width
if exists("*shiftwidth")
  let s:sw = function("shiftwidth")
else
  function! s:sw() abort
    return &shiftwidth
  endfunction
endif

if exists("g:razor_indent_shiftwidth")
  function! s:cs_sw() abort
    return g:razor_indent_shiftwidth
  endfunction
else
  let s:cs_sw = function("s:sw")
endif

" Helper functions and variables {{{1
" ==============================

" Determine whether or not the character at the given position should be
" ignored when searching for Razor block delimiters.
function! s:ignored_brace(lnum, col) abort
  return synIDattr(synID(a:lnum, a:col, 1), "name") !~# '^\%(razorDelimiter\|csBraces\)$'
endfunction

function! s:is_html(lnum, col) abort
  return synIDattr(synID(a:lnum, a:col, 1), "name") =~# '^html'
endfunction

let s:skip_expr = 's:ignored_brace(line("."), col("."))'

" GetRazorIndent {{{1
" ==============

function! GetRazorIndent(...) abort
  let v:lnum = a:0 ? a:1 : v:lnum

  let open_lnum = searchpair("{", "", "}", "bW", s:skip_expr)

  if open_lnum
    " Inside of a Razor/C# block

    " If this line is the closing brace, do nothing.
    if getline(v:lnum) =~# '\_^\s*}'
      return indent(open_lnum)
    endif

    let prev_lnum = prevnonblank(v:lnum - 1)

    if open_lnum == prev_lnum
      " First line of the block
      return indent(prev_lnum) + s:cs_sw()
    else
      let prev_line = getline(prev_lnum)

      " Do not indent this line if the previous line was a oneline
      " embedded HTML line.
      if prev_line =~# '\_^\s*\%(@:\|<.\{-1,}/>\|<\([[:alnum:]-]\+\).\{-}>.*</\1>\)'
        return indent(prev_lnum)
      endif

      " Otherwise, we need to check if we are inside of an embedded
      " multiline HTML block.
      call cursor(v:lnum, 1)

      let open_tag = searchpair(
            \ '\_^\s*<[[:alnum:]-]\+.\{-}>',
            \ '',
            \ '</[[:alnum:]-]\+>',
            \ "b", "", open_lnum)

      if open_tag
        " Inside of an HTML block

        if open_tag == prev_lnum
          " First line of the block
          return indent(prev_lnum) + s:sw()
        endif

        " Use HTML indentation
        return HtmlIndent()
      endif

      " If none of the above exceptions were encountered, then fall back
      " to C# indentation.
      return GetCSIndent(v:lnum)
    endif
  endif

  return HtmlIndent()
endfunction

" }}}

" vim:fdm=marker

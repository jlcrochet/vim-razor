" Vim indent file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Setup {{{1
" =====

if exists("b:did_indent")
  finish
endif

" indent/html.vim has to be source for each buffer since it requires
" a lot of buffer-local configuration.
runtime! indent/html.vim
unlet! b:did_indent

" indent/cs.vim does not, so we only have to source it once per session.
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

" Determine whether or not the character at the given position should be
" ignored when searching for HTML tags.
function! s:ignored_tag(lnum, col) abort
  return synIDattr(synID(a:lnum, a:col, 1), "name")[:3] !=# "html"
endfunction

let s:cs_skip = 's:ignored_brace(line("."), col("."))'
let s:html_skip = 's:ignored_tag(line("."), col("."))'

" GetRazorIndent {{{1
" ==============

function! GetRazorIndent(lnum) abort
  let open_lnum = searchpair("{", "", "}", "bW", s:cs_skip)

  if open_lnum
    " Inside of a Razor/C# block

    " If this line is the closing brace, do nothing.
    if getline(a:lnum) =~# '\_^\s*}'
      return indent(open_lnum)
    endif

    let prev_lnum = prevnonblank(a:lnum - 1)

    if open_lnum == prev_lnum
      " First line of the block
      return indent(open_lnum) + s:cs_sw()
    else
      let prev_line = getline(prev_lnum)

      " Otherwise, we need to check if we are inside of an embedded
      " multiline HTML block.
      call cursor(a:lnum, 1)

      let open_tag = searchpair('<\w', '', '</\w', "b", s:html_skip, open_lnum)

      if open_tag
        " Inside of an HTML block

        if open_tag == prev_lnum
          " First line of the block
          return indent(open_tag) + s:sw()
        endif

        if getline(a:lnum) =~# '\_^\s*</\w'
          " Closing tag
          return indent(open_tag)
        endif

        " Use HTML indentation
        return HtmlIndent()
      endif

      " Do not indent this line if the previous line was a oneline
      " embedded HTML line.
      if prev_line =~# '\_^\s*\%(@:\|<\w\)'
        return indent(prev_lnum)
      endif

      " If none of the above exceptions were encountered, then fall back
      " to C# indentation.
      return GetCSIndent(a:lnum)
    endif
  endif

  return HtmlIndent()
endfunction

" }}}

" vim:fdm=marker

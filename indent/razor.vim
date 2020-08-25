" Vim indent file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Setup {{{1
" =====

if exists("b:did_indent")
  finish
endif

let b:did_indent = 1

setlocal indentexpr=GetRazorIndent(v:lnum)
execute "setlocal indentkeys=<>>,".&cinkeys

" Only define the function once per session
if exists("*GetRazorIndent")
  finish
endif

let s:cs_sw = get(g:, "razor_indent_shiftwidth", shiftwidth())

" Helper variables and function {{{1
" =============================

let s:skip_bracket =
      \ "synID(line('.'), col('.'), 1) != g:razor#hl_razorHTMLTag"

let s:skip_tag = s:skip_bracket .
      \ " || index(s:void_elements, expand('<cword>')) > -1" .
      \ " || searchpair('<', '', '/>', 'nz', s:skip_bracket, line('.'))"

let s:void_elements = [
      \ "area", "base", "br", "col", "command", "embed", "hr", "img",
      \ "input", "keygen", "link", "meta", "param", "source", "track",
      \ "wbr"
      \ ]

function! s:skip_brace(lnum, col) abort
  let synid = synID(a:lnum, a:col, 1)
  return synid != g:razor#hl_razorDelimiter && synid != g:razor#hl_razorCSBrace
endfunction

" GetRazorIndent {{{1
" ==============

" TODO: Add support for embedded JS/CSS

" If the current line is inside a Razor or C# block:
"   If it is between a pair of HTML tags, use HTML indentation.
"   Else, use C indentation.
" Else, use HTML indentation.
function! GetRazorIndent(lnum) abort
  let s:plnum = prevnonblank(a:lnum - 1)

  if !s:plnum
    return 0
  endif

  let s:line = getline(a:lnum)
  let s:first_idx = match(s:line, '\S')
  let s:first_char = s:line[s:first_idx]

  let in_razor = searchpair("{", "", "}", "bnW", "s:skip_brace(line('.'), col('.'))")

  if in_razor
    if s:first_char == "}"
      return indent(in_razor)
    endif

    if in_razor == s:plnum
      return indent(s:plnum) + s:cs_sw
    endif

    let in_html = searchpair('<\zs\a', "", '</\zs\a', "bn", s:skip_tag, in_razor)

    if in_html
      if s:first_char == "<" && s:line[s:first_idx + 1] == "/"
        return indent(in_html)
      endif

      if in_html == s:plnum
        return indent(s:plnum) + shiftwidth()
      endif

      return s:get_html_indent(a:lnum)
    endif

    let pline = getline(s:plnum)
    let first_idx = match(pline, '\S')
    let first_char = pline[first_idx]

    if first_char == "["
      " After attribute
      return indent(s:plnum)
    endif

    if first_char == "@" && pline[first_idx + 1] == ":"
      " After HTML escape sequence
      return indent(s:plnum)
    endif

    let old_sw = &shiftwidth
    let &shiftwidth = s:cs_sw
    let ind = cindent(a:lnum)
    let &shiftwidth = old_sw

    return ind
  endif

  return s:get_html_indent(a:lnum)
endfunction

function! s:get_html_indent(lnum) abort
  let shift = 0

  call cursor(s:plnum, 0)
  call cursor(0, col("$"))

  if searchpair('<\zs\a', "", '</\zs\a', "b", s:skip_tag, s:plnum)
    let shift = 1
  endif

  if s:first_char == "<" && s:line[s:first_idx + 1] == "/"
    let shift -= 1
  endif

  return indent(s:plnum) + shiftwidth() * shift
endfunction

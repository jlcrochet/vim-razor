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

let s:cs_sw = get(g:, "razor_indent_shiftwidth", &shiftwidth)

" Helper variables and function {{{1
" =============================

let s:skip_bracket =
      \ "synID(line('.'), col('.'), 1) != g:razor#hl_razorHTMLTag"

let s:skip_tag = s:skip_bracket .
      \ " || index(s:void_elements, expand('<cword>')) > -1" .
      \ " || searchpair('<', '', '/>', 'z', s:skip_bracket, line('.'))"

let s:void_elements = [
      \ "area", "base", "br", "col", "command", "embed", "hr", "img",
      \ "input", "keygen", "link", "meta", "param", "source", "track",
      \ "wbr"
      \ ]

function! s:skip_brace(lnum, col) abort
  let synid = synID(a:lnum, a:col, 1)
  return synid != g:razor#hl_razorDelimiter && synid != g:razor#hl_razorCSBrace
endfunction

" " Given a line range, determine whether or not the tags in that range
" " will produce an indent on the following line.
" function! s:html_shift(start, end) abort
"   let shift = 0

"   " Count the opening tags:

"   call cursor(a:start, 1)

"   while search('<\zs\a', "cz", a:end)
"     " Do not count this match unless:
"     "
"     " 1. It is an actual HTML tag
"     " 2. It is not a void element
"     " 3. It is not a self-closing tag
"     if synID(line("."), col("."), 1) == g:razor#hl_razorHTMLTag &&
"           \ index(s:void_elements, expand("<cword>")) == -1 &&
"           \ !searchpair("<", "", "/>", "z", s:skip_bracket)
"       let shift += 1
"     endif
"   endwhile

"   " Count the closing tags:

"   call cursor(a:end, 0)
"   call cursor(0, col("$"))

"   while shift > 0 && search("</", "b", a:start)
"     " Do not count this match unless it is an actual HTML tag.
"     if synID(line("."), col("."), 1) == g:razor#hl_razorHTMLTag
"       let shift -= 1
"     endif
"   endwhile

"   return shift > 0
" endfunction

" GetRazorIndent {{{1
" ==============

" TODO: Add support for embedded JS/CSS

" If the current line is inside a Razor or HTML comment, do nothing.
"
" If the current line is:
"   1. a closing Razor or C# brace
"   2. an ending HTML tag
" remove an indent.
"
" If the previous line is:
"   1. a closing brace
"   2. an ending tag
"   3. a one-line Razor-style HTML line (@:)
" do nothing.
"
" If the previous line is an opening tag and is:
"   1. not a void element
"   2. not a self-closing tag
"   3. not followed by an ending tag on the same line
" add an indent; else, do nothing.
"
" If the current line is inside of a Razor block but is *not* inside of
" an inner HTML block, use C indentation.

function! GetRazorIndent(lnum) abort
  let plnum = prevnonblank(a:lnum - 1)

  if !plnum
    return 0
  endif

  " Current line {{{2
  " ------------

  let line = getline(a:lnum)
  let first_idx = match(line, '\S')
  let first_char = line[first_idx]
  let synid = synID(a:lnum, first_idx + 1, 1)

  if synid == g:razor#hl_razorComment || synid == g:razor#hl_razorHTMLComment
    return indent(".")
  endif

  if first_char == "}"
    let synid = synID(a:lnum, first_idx + 1, 1)

    if synid == g:razor#hl_razorDelimiter
      return indent(plnum) - s:cs_sw
    endif
  elseif first_char == "<" && line[first_idx + 1] == "/"
    if synID(a:lnum, first_idx + 1, 1) == g:razor#hl_razorHTMLTag
      return indent(plnum) - &shiftwidth
    endif
  endif

  " Previous line {{{2
  " -------------

  let pline = getline(plnum)
  let first_idx = match(pline, '\S')
  let synid = synID(plnum, first_idx + 1, 1)

  while synid == g:razor#hl_razorComment || synid == g:razor#hl_razorCSComment || synid == g:razor#hl_razorHTMLComment
    let plnum = prevnonblank(plnum - 1)

    if !plnum
      return 0
    endif

    let pline = getline(plnum)
    let first_idx = match(pline, '\S')
    let synid = synID(plnum, first_idx + 1, 1)
  endwhile

  let first_char = pline[first_idx]

  if first_char == "<"
    if pline[first_idx + 1] == "/"
      return indent(plnum)
    endif

    call cursor(plnum, first_idx + 2)

    if index(s:void_elements, expand("<cword>")) == -1 &&
          \ !searchpair("<", "", "/>", "z", s:skip_bracket, plnum) &&
          \ !searchpair('<\zs\a', "", '</\zs\a', "z", s:skip_tag, plnum)
      return indent(plnum) + &shiftwidth
    else
      return indent(plnum)
    endif
  endif

  call cursor(plnum, 0)
  call cursor(0, col("$"))

  if searchpair("}", "", "{", "b", "s:skip_brace(line('.'), col('.'))", plnum)
    return indent(plnum)
  endif

  " C# {{{2
  " --

  call cursor(a:lnum, 1)

  let in_cs = searchpair("{", "", "}", "bW", "s:skip_brace(line('.'), col('.'))")

  if in_cs
    if in_cs == plnum
      return indent(plnum) + s:cs_sw
    endif

    if first_char == "@" && pline[first_idx + 1] == ":"
      return indent(plnum)
    endif

    if first_char == "["
      return indent(plnum)
    endif

    let old_sw = &shiftwidth
    let &shiftwidth = s:cs_sw
    let ind = cindent(a:lnum)
    let &shiftwidth = old_sw

    return ind
  endif

  " }}}2

  return indent(plnum)
endfunction

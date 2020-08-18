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

" Return the value of a single shift-width
if exists("*shiftwidth")
  let s:sw = function("shiftwidth")
else
  function! s:sw() abort
    return &shiftwidth
  endfunction
endif

let s:cs_sw = get(g:, "razor_indent_shiftwidth", s:sw())

" Helper functions and variables {{{1
" ==============================

function! s:ignored_tag(ignore_void) abort
  if a:ignore_void && s:is_void(expand("<cword>"))
    return 1
  endif

  let lnum = line(".")
  let col = col(".")

  if getline(lnum)[col:] =~ '^.*/>'
    return 1
  endif

  return synIDattr(synID(lnum, col, 1), "name") !=# "razorHTMLTag"
endfunction

function! s:is_void(tag_name) abort
  return index(s:void_elements, a:tag_name) > -1
endfunction

" List of void elements retrieved from
" <https://html.spec.whatwg.org/multipage/syntax.html#void-elements>.
let s:void_elements = [
      \ "area", "base", "br", "col", "command", "embed", "hr", "img",
      \ "input", "keygen", "link", "meta", "param", "source", "track",
      \ "wbr"
      \ ]

let s:sol = '\_^\s*'
let s:eol = '\s*\%(\%(//\|[/@]\*\).*\)\=\_$'

" GetRazorIndent {{{1
" ==============

function! GetRazorIndent(lnum) abort
  let v:lnum = a:lnum
  let s:prev_lnum = prevnonblank(v:lnum - 1)

  if s:prev_lnum == 0
    return 0
  endif

  " Do nothing if we are inside of a Razor comment.
  if s:syngroup_at_cursor() ==# "razorComment"
    return indent(".")
  endif

  call cursor(v:lnum, 1)
  let open_lnum = searchpair("{".s:eol, "", s:sol."}", "bnW")

  if open_lnum
    " Inside of a Razor/C# block

    let curr_line = getline(v:lnum)

    " If this line is a closing brace, align with the line that has the
    " opening brace.
    if curr_line =~ s:sol."}"
      return indent(open_lnum)
    endif

    if open_lnum == s:prev_lnum
      " First line of the block
      return indent(open_lnum) + s:cs_sw
    else
      " Otherwise, we need to check if we are inside of an embedded
      " multiline HTML block.
      let open_tag = searchpair('<\zs\a', '', '</\a', "b", "s:ignored_tag(1)", open_lnum)

      if open_tag
        " Inside of an HTML block

        if curr_line =~# s:sol.'</\a'
          " Closing tag
          return indent(open_tag)
        endif

        if open_tag == s:prev_lnum
          " First line of the block
          return indent(open_tag) + s:sw()
        endif

        " Use HTML indentation
        return s:get_razor_html_indent()
      endif

      " If we have gotten this far, then we are not inside of HTML.

      let prev_line = getline(s:prev_lnum)
      let idx = match(prev_line, '\S')

      " Do not indent if the previous line was:
      "
      " 1. A closing brace.
      " 2. An attribute.
      " 3. A oneline embedded HTML line.
      " 4. A closing HTML tag.
      " 5. A comment.
      if prev_line[idx] == "}" ||
            \ prev_line[idx] == "[" ||
            \ strpart(prev_line, idx, 2) == "@:" ||
            \ strpart(prev_line, idx, 3) =~ '^</\=\a' ||
            \ prev_line =~ '//.*\_$' ||
            \ prev_line =~ '\*[/@]\s*\_$'
        return indent(s:prev_lnum)
      endif

      " If none of the above exceptions were encountered, then fall back
      " to C# indentation.
      let old_sw = &shiftwidth

      let &shiftwidth = s:cs_sw
      let ind = cindent(v:lnum)
      let &shiftwidth = old_sw

      return ind
    endif
  endif

  return s:get_razor_html_indent()
endfunction

function! s:get_razor_html_indent() abort
  let ind = indent(s:prev_lnum)

  " First, check for a line continuation

  call cursor(s:prev_lnum, 0)
  call cursor(0, col("$"))

  if searchpair('<', "", '>', "bz", "s:ignored_tag(0)", s:prev_lnum)
    normal! ww
    return col(".") - 1
  endif

  " Next, check if we are after a line continuation

  call cursor(s:prev_lnum, 1)

  let [lnum, col] = searchpairpos('<', "", '>', "c", "s:ignored_tag(0)", s:prev_lnum)

  if lnum
    let self_closing_tag = getline(lnum)[col - 2] == "/"

    let lnum = searchpair('<\zs\a', "", '>', "bzW", "s:ignored_tag(0)")

    if self_closing_tag
      return indent(lnum)
    else
      let tag_name = expand("<cword>")

      if s:is_void(tag_name)
        return indent(lnum)
      else
        return indent(lnum) + s:sw()
      endif
    endif
  endif

  " If no line continuations were found, proceed normally

  let ind = indent(s:prev_lnum)

  call cursor(0, col("$"))

  let shift = searchpair('<\zs\a', "", '</\a', "bz", "s:ignored_tag(1)", s:prev_lnum)
        \ ? 1 : 0

  call cursor(v:lnum, 1)

  let shift -= searchpair('<\zs\a', "", '</\a', "c", "s:ignored_tag(1)", v:lnum)
        \ ? 1 : 0

  return ind + s:sw() * shift
endfunction

" }}}

" vim:fdm=marker

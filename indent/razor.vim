" Vim indent file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Setup {{{1
" =====

if exists("b:did_indent")
  finish
endif

" " " indent/html.vim has to be sourced for each buffer since it requires
" " " a lot of buffer-local configuration.
" " runtime! indent/html.vim
" " unlet! b:did_indent
"
" if !exists("*XmlIndentGet")
"   runtime! indent/xml.vim
"   unlet! b:did_indent
" endif
"
" " indent/cs.vim does not, so we only have to source it once per session.
" if !exists("*GetCSIndent")
"   runtime! indent/cs.vim
"   unlet! b:did_indent
" endif

setlocal indentexpr=GetRazorIndent(v:lnum)
execute "setlocal indentkeys=<>>,".&cinkeys

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

let s:cs_sw = get(g:, "razor_indent_shiftwidth", s:sw())

" Helper functions and variables {{{1
" ==============================

" Determine whether or not the character at the cursor position should
" be ignored when searching for Razor block delimiters.
function! s:ignored_brace() abort
  return synIDattr(synID(line("."), col("."), 1), "name") !~# '^\%(razorDelimiter\|csBraces\)$'
endfunction

" Determine whether or not the character at the cursor position should
" be ignored when searching for HTML tags.
function! s:ignored_tag() abort
  if index(s:void_elements, expand("<cword>")) > -1
    return 1
  endif

  let syn_name = synIDattr(synID(line("."), col("."), 1), "name")

  return strpart(syn_name, 0, 4) !=# "html" ||
        \ syn_name ==# "htmlComment" ||
        \ syn_name ==# "htmlString"
endfunction

" List of void elements retrieved from
" <https://html.spec.whatwg.org/multipage/syntax.html#void-elements>.
let s:void_elements = [
      \ "area", "base", "br", "col", "embed", "hr", "img", "input",
      \ "link", "meta", "param", "source", "track", "wbr"
      \ ]

" GetRazorIndent {{{1
" ==============

function! GetRazorIndent(lnum) abort
  let open_lnum = searchpair("{", "", "}", "bW", "s:ignored_brace()")

  if open_lnum
    " Inside of a Razor/C# block

    " If this line is the closing brace, do nothing.
    if getline(a:lnum) =~# '\_^\s*}'
      echo "foo"
      return indent(open_lnum)
    endif

    let prev_lnum = prevnonblank(a:lnum - 1)

    if open_lnum == prev_lnum
      " First line of the block
      echo "bar"
      return indent(open_lnum) + s:cs_sw
    else
      let prev_line = getline(prev_lnum)

      " Otherwise, we need to check if we are inside of an embedded
      " multiline HTML block.
      call cursor(a:lnum, 1)

      let open_tag = searchpair('<\zs\a', '', '</\a', "b", "s:ignored_tag()", open_lnum)

      if open_tag
        " Inside of an HTML block

        if getline(a:lnum) =~# '\_^\s*</\a'
          " Closing tag
          echo "baz"
          return indent(open_tag)
        endif

        if open_tag == prev_lnum
          " First line of the block
          echo "qux"
          return indent(open_tag) + s:sw()
        endif

        " Use HTML indentation
        echo "bleh"
        return GetRazorHtmlIndent(a:lnum)
      endif

      " Do not indent this line if the previous line was a oneline
      " embedded HTML line or a closing HTML tag.
      if prev_line =~# '\_^\s*\%(@:\|</\=\a\)'
        echo "bloo"
        return indent(prev_lnum)
      endif

      " If none of the above exceptions were encountered, then fall back
      " to C# indentation.
      let old_sw = &shiftwidth

      let &shiftwidth = s:cs_sw
      " let ind = GetCSIndent(a:lnum)
      let ind = cindent(a:lnum)
      let &shiftwidth = old_sw

      echo "blerp"
      return ind
    endif
  endif

  echo "default"
  return GetRazorHtmlIndent(a:lnum)
endfunction

" GetRazorHtmlIndent {{{1
" ==================

function! GetRazorHtmlIndent(lnum) abort
  let prev_lnum = prevnonblank(a:lnum - 1)

  if prev_lnum == 0
    return 0
  endif

  let ind = indent(prev_lnum)

  call cursor(prev_lnum, 0)
  call cursor(0, "$")

  let shift = searchpair('<\zs\a', "", '</\a', "bz", "s:ignored_tag()", prev_lnum) ? 1 : 0

  call cursor(a:lnum, 1)

  let shift -= searchpair('<\zs\a', "", '</\a', "c", "s:ignored_tag()", a:lnum) ? 1 : 0

  return ind + s:sw() * shift

  " let ind = 0
  "
  " " If the previous line had an opening tag that was not followed by
  " " a corresponding closing tag, add an indent.
  "
  " " First, find an opening tag
  " call cursor(prev_lnum, 1)
  "
  " let found = search('<\zs\a', "", prev_lnum)
  "
  " while found && s:ignored_tag()
  "   let found = search('<\zs\a', "", prev_lnum)
  " endwhile
  "
  " if !found
  "   return -1
  " endif
  "
  " let element = expand("<cword>")
  "
  " " Next, find its closing tag, if it exists
  " call search()
endfunction

" }}}

" vim:fdm=marker

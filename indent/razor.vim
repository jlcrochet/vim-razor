" Vim indent file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Setup {{{1
" =====

if get(b:, "did_indent")
  finish
endif

" Only define the function once per session
if exists("*GetRazorIndent")
  let b:did_indent = 1

  setlocal indentexpr=GetRazorIndent()
  let &indentkeys = &cinkeys .. ",<>>"

  finish
endif

runtime! indent/javascript.vim | unlet b:did_indent
let s:js_indentexpr = &indentexpr

runtime! indent/css.vim
let s:css_indentexpr = &indentexpr

setlocal indentexpr=GetRazorIndent()
let &indentkeys = &cinkeys .. ",<>>"

if has_key(g:, "razor_cs_shiftwidth")
  let s:cs_sw = g:razor_cs_shiftwidth
else
  let s:cs_sw = &shiftwidth
endif

if has_key(g:, "razor_js_shiftwidth")
  let s:js_sw = g:razor_js_shiftwidth
else
  let s:js_sw = &shiftwidth
endif

if has_key(g:, "razor_css_shiftwidth")
  let s:css_sw = g:razor_css_shiftwidth
else
  let s:css_sw = &shiftwidth
endif

" Helper variables and functions {{{1
" ==============================

let s:void_elements = {
      \ "area": 1,
      \ "base": 1,
      \ "br": 1,
      \ "col": 1,
      \ "command": 1,
      \ "embed": 1,
      \ "hr": 1,
      \ "img": 1,
      \ "input": 1,
      \ "keygen": 1,
      \ "link": 1,
      \ "meta": 1,
      \ "param": 1,
      \ "source": 1,
      \ "track": 1,
      \ "wbr": 1
      \ }

" Get the last non-comment character in the given line, along with its
" index and the line itself; used for C# indentation.
"
" First, try to find a comment delimiter: if one is found, the
" non-whitespace character immediately before it is the last character;
" else, simply find the last non-whitespace character in the line.
function s:get_last_char(lnum) abort
  let found = 0

  call cursor(a:lnum, 1)

  let [_, col, p] = searchpos('\(/[/*]\)\|\(@\*\)', "cpz", a:lnum)

  while p
    let synid = synID(a:lnum, col, 0)

    if p == 2
      if synid == g:razor#highlighting#cs_comment
        let found = 1
        break
      endif
    elseif p == 3
      if synid == g:razor#highlighting#comment
        let found = 1
        break
      endif
    endif

    let [_, col, p] = searchpos('\(/[*/]\)\|\(@\*\)', "pz", a:lnum)
  endwhile

  let line = getline(a:lnum)

  if found
    let segment = line[:col - 2]
  else
    let segment = line
  endif

  let [char, idx, _] = matchstrpos(segment, '\S\s*$')

  return [char, idx, segment]
endfunction

function s:get_indent_info(lnum) abort
  let brackets = 0
  let pairs = 0

  for i in range(a:lnum, 1, -1)
    call cursor(i, 1)

    let [_, j, p] = searchpos('\(<\)\|\(>\)', "cpz", i)

    while p
      if p == 2  " <
        let synid = synID(i, j, 0)

        if synid == g:razor#highlighting#html_tag
          let brackets += 1

          let tag_name = expand("<cword>")

          if !get(s:void_elements, tolower(tag_name))
            let pairs += 1
          endif
        elseif synid == g:razor#highlighting#html_end_tag
          let brackets += 1
          let pairs -= 1
        endif
      elseif p == 3  " >
        let synid = synID(i, j, 0)

        if synid == g:razor#highlighting#html_tag
          let brackets -= 1

          if search('/\%#', "bn", i)
            let pairs -= 1
          endif
        elseif synid == g:razor#highlighting#html_end_tag
          let brackets -= 1
        endif
      endif

      let [_, j, p] = searchpos('\(<\)\|\(>\)', "pz", i)
    endwhile

    if brackets >= 0
      return [i, pairs]
    endif
  endfor

  return a:lnum, 0
endfunction

let s:skip_delimiter = "synID(line('.'), col('.'), 1) != g:razor#highlighting#delimiter"
let s:skip_cs_delimiter = "synID(line('.'), col('.'), 1) != g:razor#highlighting#cs_delimiter"

" GetRazorIndent {{{1
" ==============

function GetRazorIndent() abort
  let prev_lnum = prevnonblank(v:lnum - 1)

  if !prev_lnum
    return 0
  endif

  let synid = synID(v:lnum, 1, 0)

  " Is this line inside of a multiline region?
  if synid == g:razor#highlighting#comment || synid == g:razor#highlighting#comment_end || synid == g:razor#highlighting#html_comment || synid == g:razor#highlighting#cs_comment || synid == g:razor#highlighting#cs_comment_end || synid == g:razor#highlighting#cs_string || synid == g:razor#highlighting#cs_string_end
    return -1
  endif

  let line = getline(v:lnum)
  let idx = match(line, '\S')

  if synid
    " Does this line begin with the closing tag for a style or script
    " element?
    if strpart(line, idx, 3) ==# "</s"
      if strpart(line, idx + 3, 6) ==# "cript>" || strpart(line, idx + 3, 5) ==# "tyle>"
        return indent(prev_lnum) - shiftwidth()
      endif
    endif

    " Is this line inside of a script element?
    if synid == g:razor#highlighting#html_script || synIDattr(synid, "name")[:9] ==# "javascript"
      " Is the previous line the beginning tag of the element?
      let prev_line = getline(prev_lnum)
      let idx = -1

      while 1
        let idx = stridx(prev_line, "<script", idx + 1)

        if idx == -1 || prev_line[idx + 7] !~# '[[:alnum:]_.:-]' && synID(prev_lnum, idx + 1, 0) == g:razor#highlighting#html_tag
          break
        endif
      endwhile

      if idx != -1
        return idx + shiftwidth()
      endif

      " Otherwise, use JS indentation.
      let old_sw = &shiftwidth
      let &shiftwidth = s:js_sw

      let ind = eval(s:js_indentexpr)
      let &shiftwidth = old_sw

      return ind
    endif

    " Is this line inside of a style element?
    if synid == g:razor#highlighting#html_style || synIDattr(synid, "name")[:2] ==# "css"
      " Is the previous line the beginning tag of the element?
      let prev_line = getline(prev_lnum)
      let idx = -1

      while 1
        let idx = stridx(prev_line, "<style", idx + 1)

        if idx == -1 || prev_line[idx + 6] !~# '[[:alnum:].:_-]' && synID(prev_lnum, idx + 1, 0) == g:razor#highlighting#html_tag
          break
        endif
      endwhile

      if idx != -1
        return idx + shiftwidth()
      endif

      " Otherwise, use CSS indentation.
      let old_sw = &shiftwidth
      let &shiftwidth = s:css_sw

      let ind = eval(s:css_indentexpr)
      let &shiftwidth = old_sw

      return ind
    endif

    " Is this line inside of a multiline tag?
    if line[idx] !=# "<" && synid == g:razor#highlighting#html_tag || synid == g:razor#highlighting#html_attribute
      let prev_line = getline(prev_lnum)
      let idx = match(prev_line, '\S')

      if prev_line[idx] ==# "<"
        let idx = stridx(prev_line, " ", idx + 1)
        let idx = match(prev_line, '\S', idx + 1)
      endif

      return idx
    endif

    " Is this line inside of a Razor block?
    if synid == g:razor#highlighting#delimiter || synid == g:razor#highlighting#block || synid == g:razor#highlighting#cs_block || synIDattr(synid, "name")[:6] ==# "razorcs"
      " If the current line begins with a closing bracket, use
      " C indentation.
      if getline(v:lnum) =~# '^\s*[)\]}]'
        let old_sw = &shiftwidth
        let &shiftwidth = s:cs_sw

        let ind = cindent(v:lnum)
        let &shiftwidth = old_sw

        return ind
      endif

      " If the previous line was a preprocessor directive or was inside of
      " a multiline region, find the nearest previous line that wasn't.
      let prev_line = getline(prev_lnum)
      let first_idx = match(prev_line, '\S')
      let first_char = prev_line[first_idx]
      let synid = synID(prev_lnum, 1, 1)

      while first_char ==# "#" || synid == g:razor#highlighting#comment || synid == g:razor#highlighting#comment_end || synid == g:razor#highlighting#cs_comment || synid == g:razor#highlighting#cs_comment_end || synid == g:razor#highlighting#cs_string || synid == g:razor#highlighting#cs_string_end
        let prev_lnum = prevnonblank(prev_lnum - 1)

        if prev_lnum == 0
          return 0
        endif

        let prev_line = getline(prev_lnum)
        let first_idx = match(prev_line, '\S')
        let first_char = prev_line[first_idx]
        let synid = synID(prev_lnum, 1, 1)
      endwhile

      " If the previous line was one of the following:
      " 1. An attribute
      " 2. A comment
      " 3. An HTML line
      " 4. The closing delimiter of a Razor block
      " align with the previous line.
      if first_char ==# "["
        call cursor(prev_lnum, first_idx + 1)

        if searchpair('\[', "", '\]', "z", s:skip_cs_delimiter, prev_lnum)
          return first_idx
        endif
      elseif first_char ==# "]"
        call cursor(prev_lnum, first_idx + 1)

        let [_, col] = searchpairpos('\[', "", '\]', "bW", s:skip_cs_delimiter)

        return col - 1
      elseif first_char ==# "/"
        let second_char = prev_line[first_idx + 1]

        if second_char ==# "/" || second_char ==# "*"
          return first_idx
        endif
      elseif first_char ==# "@"
        let second_char = prev_line[first_idx + 1]

        if second_char ==# ":" || second_char ==# "*"
          return first_idx
        endif

        " Check to see if this is a Razor attribute inside of
        " a multiline HTML tag.
        if first_idx > 0
          let synid = synID(prev_lnum, 1, 0)

          if synid == g:razor#highlighting#html_tag || synid == g:razor#highlighting#html_end_tag
            call cursor(prev_lnum, 1)

            let [lnum, col] = searchpos("<", "bW")
            let synid = synID(lnum, col, 1)

            while synid != g:razor#highlighting#html_tag && synid != g:razor#highlighting#html_end_tag
              let [lnum, col] = searchpos("<", "bW")
              let synid = synID(lnum, col, 1)
            endwhile

            return col - 1
          endif
        endif
      elseif first_char ==# "<"
        let synid = synID(prev_lnum, first_idx + 1, 1)

        if synid == g:razor#highlighting#html_tag || synid == g:razor#highlighting#html_end_tag
          return first_idx
        endif
      elseif first_char ==# "}"
        let synid = synID(prev_lnum, first_idx + 1, 1)

        if synid == g:razor#highlighting#delimiter
          " If there are unpaired opening brackets on the same line,
          " indent; otherwise, align with the previous line.
          call cursor(prev_lnum, strlen(prev_line))

          if searchpair("{", "", "}", "bc", s:skip_delimiter, prev_lnum)
            return first_idx + s:cs_sw
          else
            return first_idx
          endif
        endif
      endif

      " Otherwise, fall back to C indentation.
      "
      " TODO: In the future, this should probably be replaced with custom
      " logic.
      let old_sw = &shiftwidth
      let &shiftwidth = s:cs_sw

      let ind = cindent(v:lnum)
      let &shiftwidth = old_sw

      return ind
    endif
  endif

  " Special case: if we aren't inside of a syngroup, make sure that the
  " previous character isn't a Razor delimiter.
  let [last_char, last_idx, prev_line] = s:get_last_char(prev_lnum)

  if last_char ==# "{" && synID(prev_lnum, last_idx + 1, 0) == g:razor#highlighting#delimiter
    return indent(prev_lnum) + s:cs_sw
  endif

  " Otherwise, proceed with normal HTML indentation.
  let shift = 0

  if strpart(line, idx, 2) ==# "</"
    let shift -= 1
  endif

  let [start_lnum, pairs] = s:get_indent_info(prev_lnum)

  if pairs > 0
    let shift += 1
  endif

  return indent(start_lnum) + shift * shiftwidth()
endfunction
" }}}1

" vim:fdm=marker

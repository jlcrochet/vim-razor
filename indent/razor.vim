" Vim indent file
" Language: Razor (https://docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-razor

if get(b:, "did_indent")
  finish
endif

if exists("*GetRazorIndent")
  setlocal
      \ indentexpr=GetRazorIndent()
      \ cinoptions+=j1,J1

  let &indentkeys = &cinkeys..",<>>"
  let b:did_indent = 1

  finish
endif

runtime! indent/javascript.vim indent/javascript.lua | unlet! b:did_indent
let s:js_indentexpr = &indentexpr

runtime! indent/css.vim indent/css.lua
let s:css_indentexpr = &indentexpr

setlocal
    \ indentexpr=GetRazorIndent()
    \ cinoptions+=j1,J1

let &indentkeys = &cinkeys..",<>>"
let b:did_indent = 1

const s:skip_delimiter = 'synID(line("."), col("."), 0)->synIDattr("name") !~# ''^razor\%(cs\)\=Delimiter$'''

let s:line = 0
let s:first_char = 0
let s:first_idx = 0
let s:prev_lnum = 0

function GetRazorIndent() abort
  let s:prev_lnum = prevnonblank(v:lnum - 1)

  if s:prev_lnum == 0
    return 0
  endif

  let s:line = getline(v:lnum)
  let s:first_idx = indent(v:lnum)
  let s:first_char = s:line[s:first_idx]

  let shift = 0

  let stack = synstack(v:lnum, s:first_idx + 1)

  if stack->len() > 0
    call reverse(stack)

    let name = synIDattr(stack[0], 'name')

    if s:is_multiline(name)
      return -1
    elseif name ==# 'razorhtmlTagStart'
      if s:line[s:first_idx + 1] ==# '/'
        return s:html_indent() - shiftwidth()
      endif
    elseif name ==# 'razorhtmlTagEnd'
      let [l, c] = searchpos('<', "bW")
      let name = s:syn_name_at(l, c)

      while name !=# 'razorhtmlTagStart'
        let [l, c] = searchpos('<', "bW")
        let name = s:syn_name_at(l, c)
      endwhile

      return indent(l)
    elseif name ==# 'razorDelimiter' || name ==# 'razorcsDelimiter'
      if s:first_char ==# ')' || s:first_char ==# ']' || s:first_char ==# '}'
        return cindent(v:lnum)
      endif
    elseif name[:8] ==# 'razorhtml' && name[-9:] ==# 'Attribute'
      let [l, c] = searchpos('<', "bW", s:prev_lnum)

      if l == 0
        return indent(s:prev_lnum)
      endif

      let name = s:syn_name_at(l, c)

      while name !=# 'razorhtmlTagStart'
        let [l, c] = searchpos('<', "bW", s:prev_lnum)

        if l == 0
          return indent(s:prev_lnum)
        endif

        let name = s:syn_name_at(l, c)
      endwhile

      if l == 0
        return indent(s:prev_lnum)
      else
        let [_, space] = searchpos('\s', "z", s:prev_lnum)

        if space == 0
          return indent(l) + shiftwidth()
        else
          let [_, nonspace] = searchpos('\S', "z", s:prev_lnum)

          if nonspace == 0
            return indent(l) + shiftwidth()
          else
            return nonspace - 1
          endif
        endif
      endif
    endif

    for id in stack
      let name = synIDattr(id, 'name')

      if name ==# 'razorhtmlTagBlock'
        return s:html_indent()
      elseif name ==# 'razorhtmlScriptBlock'
        return s:js_indent()
      elseif name ==# 'razorhtmlStyleBlock'
        return s:css_indent()
      elseif name ==# 'razorInvocation' || name ==# 'razorIndex' || name ==# 'razorExplicitExpression' || name ==# 'razorcsAttributes'
        return cindent(v:lnum)
      elseif name ==# 'razorBlock' || name ==# 'razorcsTypeBlock'
        return s:cs_indent()
      endif
    endfor
  endif

  return s:html_indent()
endfunction

function s:html_indent() abort
  let [brackets, tags, _, closers] = s:get_html_line_info(s:prev_lnum)

  while brackets != 0 || closers > 0
    let s:prev_lnum = prevnonblank(s:prev_lnum - 1)

    if s:prev_lnum == 0
      return 0
    endif

    let [b, t, o, c] = s:get_html_line_info(s:prev_lnum)

    let brackets += b
    let tags += t
    let closers -= o
    let closers += c
  endwhile

  while s:is_multiline(s:syn_name_at(s:prev_lnum, 1))
    let s:prev_lnum = prevnonblank(s:prev_lnum - 1)
  endwhile

  if tags > 0
    return indent(s:prev_lnum) + shiftwidth()
  else
    return indent(s:prev_lnum)
  endif
endfunction

function s:get_html_line_info(lnum) abort
  let brackets = 0
  let tags = 0
  let openers = 0
  let closers = 0

  let line = getline(a:lnum)
  let [char, idx, col] = line->matchstrpos('[()[\]{}<>]')

  while idx != -1
    if char ==# '<'
      let name = s:syn_name_at(a:lnum, col)

      if name ==# 'razorhtmlComment'
        break
      elseif name ==# 'razorhtmlTagStart'
        let brackets += 1
        let tags += 1

        let next_char = line[col]

        if next_char ==# '/'
          let tags -= 2
        else
          let name = line->matchstr('^\a[^[:space:]/>]*', idx + 1)

          if name !=# ''
            if s:is_void_element(name)
              let tags -= 1
            endif

            let idx += len(name) - 1
          endif
        endif
      endif
    elseif char ==# '>'
      if s:syn_name_at(a:lnum, col) ==# 'razorhtmlTagEnd'
        let brackets -= 1

        if line[idx - 1] ==# '/'
          let tags -= 1
        endif
      endif
    elseif char ==# '(' || char ==# '[' || char ==# '{'
      let name = s:syn_name_at(a:lnum, col)

      if name ==# 'razorDelimiter' || name ==# 'razorcsDelimiter'
        let openers += 1
      endif
    elseif char ==# ')' || char ==# ']' || char ==# '}'
      let name = s:syn_name_at(a:lnum, col)

      if name ==# 'razorDelimiter' || name ==# 'razorcsDelimiter'
        if openers > 0
          let openers -= 1
        else
          let closers += 1
        endif
      endif
    endif

    let [char, idx, col] = line->matchstrpos('[()[\]{}<>]', idx + 1)
  endwhile

  return [brackets, tags, openers, closers]
endfunction

function s:is_void_element(name) abort
  return
      \ a:name ==? 'area' ||
      \ a:name ==? 'base' ||
      \ a:name ==? 'br' ||
      \ a:name ==? 'col' ||
      \ a:name ==? 'embed' ||
      \ a:name ==? 'hr' ||
      \ a:name ==? 'input' ||
      \ a:name ==? 'link' ||
      \ a:name ==? 'meta' ||
      \ a:name ==? 'param' ||
      \ a:name ==? 'source' ||
      \ a:name ==? 'track' ||
      \ a:name ==? 'wbr'
endfunction

function s:cs_indent() abort
  let prev_line = getline(s:prev_lnum)
  let first_idx = indent(s:prev_lnum)
  let first_char = prev_line[first_idx]

  while first_char ==# '#' || s:is_multiline(s:syn_name_at(s:prev_lnum, 1))
    let s:prev_lnum = prevnonblank(s:prev_lnum - 1)

    if s:prev_lnum == 0
      return 0
    endif

    let prev_line = getline(s:prev_lnum)
    let first_idx = indent(s:prev_lnum)
    let first_char = prev_line[first_idx]
  endwhile

  if first_char ==# '[' || first_char ==# ']'
    if s:syn_name_at(s:prev_lnum, first_idx + 1) ==# 'razorcsAttributeDelimiter'
      return indent(s:prev_lnum)
    endif
  elseif first_char ==# '}'
    let name = s:syn_name_at(s:prev_lnum, first_idx + 1)

    if name ==# 'razorDelimiter' || name ==# 'razorcsDelimiter'
      if searchpair('[([{]', '', '[)\]}]', 'b', s:skip_delimiter, s:prev_lnum)
        return indent(s:prev_lnum) + shiftwidth()
      else
        return indent(s:prev_lnum)
      endif
    endif
  elseif first_char ==# '/'
    let second_char = prev_line[first_idx + 1]

    if second_char ==# '/' || second_char ==# '*'
      if s:syn_name_at(s:prev_lnum, first_idx + 1) ==# 'razorcsCommentStart'
        return indent(s:prev_lnum)
      endif
    endif
  elseif first_char ==# '@'
    let name = s:syn_name_at(s:prev_lnum, first_idx + 1)

    if name ==# 'razorStart'
      if searchpair('[([{]', '', '[)\]}]', 'b', s:skip_delimiter, s:prev_lnum)
        return indent(s:prev_lnum) + shiftwidth()
      else
        return indent(s:prev_lnum)
      endif
    elseif name ==# 'razorHTMLLineStart' || name ==# 'razorCommentStart'
      return indent(s:prev_lnum)
    endif
  elseif first_char ==# '<'
    if s:syn_name_at(s:prev_lnum, first_idx + 1) ==# 'razorhtmlTagStart'
      return indent(s:prev_lnum)
    endif
  elseif first_char ==# '>'
    if s:syn_name_at(s:prev_lnum, first_idx + 1) ==# 'razorhtmlTagEnd'
      return indent(s:prev_lnum)
    endif
  endif

  return cindent(v:lnum)
endfunction

function s:css_indent() abort
  if s:line->strpart(s:first_idx + 1, 8) ==? '</style>'
    return indent(s:prev_lnum) - shiftwidth()
  endif

  while search('\c<style[[:space:]>]\@=', "b", s:prev_lnum)
    if s:syn_name_at(s:prev_lnum, col('.')) ==# 'razorhtmlTagStart'
      return indent(s:prev_lnum) + shiftwidth()
    endif
  endwhile

  return eval(s:css_indentexpr)
endfunction

function s:js_indent() abort
  if s:line->strpart(s:first_idx + 1, 9) ==? '</script>'
    return indent(s:prev_lnum) - shiftwidth()
  endif

  while search('\c<script[[:space:]>]\@=', "b", s:prev_lnum)
    if s:syn_name_at(s:prev_lnum, col('.')) ==# 'razorhtmlTagStart'
      return indent(s:prev_lnum) + shiftwidth()
    endif
  endwhile

  return eval(s:js_indentexpr)
endfunction

function s:syn_name_at(lnum, col)
  return synID(a:lnum, a:col, 0)->synIDattr('name')
endfunction

function s:is_multiline(name) abort
  return
      \ a:name ==# 'razorComment' ||
      \ a:name ==# 'razorCommentEnd' ||
      \ a:name ==# 'razorhtmlComment' ||
      \ a:name ==# 'razorhtmlCommentEnd' ||
      \ a:name ==# 'razorcsComment' ||
      \ a:name ==# 'razorcsCommentEnd' ||
      \ a:name ==# 'razorcsString' ||
      \ a:name ==# 'razorcsStringEnd'
endfunction

" vim:fdm=marker

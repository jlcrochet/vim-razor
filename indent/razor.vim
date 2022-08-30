" Vim indent file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@hey.com>
" URL: github.com/jlcrochet/vim-razor

" Setup {{{1
" =====
if get(b:, "did_indent")
  finish
endif

if has("nvim-0.5")
  lua require "vim-razor/get_razor_indent"

  setlocal
        \ indentexpr=v:lua.get_razor_indent()
        \ cinoptions+=j1,J1

  let &indentkeys = &cinkeys..",<>>"

  let b:did_indent = 1

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

runtime! indent/javascript.vim | unlet! b:did_indent
let s:js_indentexpr = &indentexpr

runtime! indent/css.vim
let s:css_indentexpr = &indentexpr

setlocal
      \ indentexpr=GetRazorIndent()
      \ cinoptions+=j1,J1

let &indentkeys = &cinkeys..",<>>"

let s:cs_shiftwidth = get(g:, "razor_cs_shiftwidth", &shiftwidth)
let s:js_shiftwidth = get(g:, "razor_js_shiftwidth", &shiftwidth)
let s:css_shiftwidth = get(g:, "razor_css_shiftwidth", &shiftwidth)

" Helpers {{{1
" =======
let s:multiline_regions = #{
      \ razorInvocation: 1,
      \ razorSubscript: 1,
      \ razorComment: 1,
      \ razorCommentEnd: 1,
      \ razorhtmlComment: 1,
      \ razorhtmlCommentEnd: 1,
      \ razorhtmlCDATA: 1,
      \ razorhtmlCDATAEnd: 1,
      \ razorcsInvocation: 1,
      \ razorcsSubscript: 1,
      \ razorcsRHSInvocation: 1,
      \ razorcsRHSSubscript: 1,
      \ razorcsComment: 1,
      \ razorcsCommentEnd: 1
      \ }

function s:skip_line(lnum)
  let syngroup = synIDattr(synID(a:lnum, 1, 0), "name")
  return get(s:multiline_regions, syngroup) || (syngroup ==# "razorhtmlTag" && getline(a:lnum)[0] !=# "<")
endfunction

function s:get_start_line(lnum)
  let lnum = a:lnum

  while s:skip_line(lnum)
    let prev_lnum = prevnonblank(lnum - 1)

    if prev_lnum == 0
      return lnum
    endif

    lnum = prev_lnum
  endwhile

  return lnum
endfunction

function s:get_line_with_first_and_last_chars(lnum)
  let line = getline(a:lnum)
  let [first_char, first_idx, _] = matchstrpos(line, '\S')

  let [found_char, found_idx, _] = matchstrpos(line, '[/<@]', first_idx)

  if found_idx == -1
    let [last_char, last_idx, _] = matchstrpos(line, '\S\ze\s*$', first_idx)
    return [line, first_char, first_idx, last_char, last_idx]
  endif

  if found_char ==# "/"
    let target_syngroup = "razorcsCommentStart"
  elseif found_char ==# "<"
    let target_syngroup = "razorhtmlCommentStart"
  elseif found_char ==# "@"
    let target_syngroup = "razorCommentStart"
  endif

  while synIDattr(synID(a:lnum, found_idx + 1, 0), "name") !=# target_syngroup
    let [found_char, found_idx, _] = matchstrpos(line, '[/<@]', found_idx + 1)

    if found_idx == -1
      let [last_char, last_idx, _] = matchstrpos(line, '\S\ze\s*$', first_idx)
      return [line, first_char, first_idx, last_char, last_idx]
    endif

    if found_char ==# "/"
      let target_syngroup = "razorcsCommentStart"
    elseif found_char ==# "<"
      let target_syngroup = "razorhtmlCommentStart"
    elseif found_char ==# "@"
      let target_syngroup = "razorCommentStart"
    endif
  endwhile

  if found_idx == first_idx
    return [line, first_char, first_idx, 0, -1]
  endif

  let [last_char, last_idx, _] = matchstrpos(line, '\S\ze\s*$', first_idx)
  return [line, first_char, first_idx, last_char, last_idx]
endfunction

" GetRazorIndent {{{1
" ==============
function GetRazorIndent() abort
  let prev_lnum = prevnonblank(v:lnum - 1)

  if prev_lnum == 0
    return 0
  endif

  let syngroup = synIDattr(synID(v:lnum, 1, 0), "name")

  if syngroup ==# "razorComment" || syngroup ==# "razorCommentEnd"
    " Razor comment:
    " Do nothing.
    return -1
  elseif syngroup ==# "razorhtmlComment" || syngroup ==# "razorhtmlCommentEnd" || syngroup ==# "razorhtmlCDATA" || syngroup ==# "razorhtmlCDATAEnd"
    " HTML comment or CDATA:
    " Do nothing.
    return -1
  elseif syngroup ==# "razorcsComment" || syngroup ==# "razorcsCommentEnd"
    " C# comment:
    " Do nothing.
    return -1
  elseif syngroup ==# "razorhtmlScript" || syngroup[:9] ==# "javascript"
    " `script` tag:
    " Use JS indentation.
    if getline(v:lnum) =~# '^\s*</script>'
      return indent(prev_lnum) - shiftwidth()
    endif

    let [lnum, col] = searchpos('<script[[:space:]>]\@=', "b", prev_lnum)

    while lnum
      let syngroup = synIDattr(synID(lnum, col, 0), "name")

      if syngroup ==# "razorhtmlTag"
        return indent(prev_lnum) + shiftwidth()
      endif

      let [lnum, col] = searchpos('<script[[:space:]>]\@=', "b", prev_lnum)
    endwhile

    let old_sw = &shiftwidth
    let &shiftwidth = s:js_shiftwidth
    let ind = eval(s:js_indentexpr)
    let &shiftwidth = old_sw

    return ind
  elseif syngroup ==# "razorhtmlStyle" || syngroup[:2] ==# "css"
    " `style` tag:
    " Use CSS indentation.
    if getline(v:lnum) =~# '^\s*</style>'
      return indent(prev_lnum) - shiftwidth()
    endif

    let [lnum, col] = searchpos('<style[[:space:]>]\@=', "b", prev_lnum)

    while lnum
      let syngroup = synIDattr(synID(lnum, col, 0), "name")

      if syngroup == "razorhtmlTag"
        return indent(prev_lnum) + shiftwidth()
      endif

      let [lnum, col] = searchpos('<style[[:space:]>]\@=', "b", prev_lnum)
    endwhile

    let old_sw = &shiftwidth
    let &shiftwidth = s:css_shiftwidth
    let ind = eval(s:css_indentexpr)
    let &shiftwidth = old_sw

    return ind
  elseif syngroup ==# "razorhtmlAttribute"
    " Tag attribute:
    return s:get_html_attribute_indent(prev_lnum)
  elseif syngroup ==# "razorhtmlTag"
    " Multiline tag:
    let line = getline(v:lnum)
    let char = matchstr(line, '\S')

    if char ==# "/"
      let [lnum, col] = searchpos("<", "bW")

      while synIDattr(synID(lnum, col, 0), "name") !=# "razorhtmlTag"
        let [lnum, col] = searchpos("<", "bW")
      endwhile

      return indent(lnum)
    elseif char !=# "<"
      return s:get_html_attribute_indent(prev_lnum)
    endif
  elseif syngroup ==# "razorDelimiter"
    let char = getline(v:lnum)[0]

    if char ==# "@"
      let outer_synid = get(synstack(v:lnum, 1), -2)

      if outer_synid
        let outer_syngroup = synIDattr(outer_synid, "name")

        if outer_syngroup ==# "razorhtmlTag" || outer_syngroup ==# "razorInnerHTMLTag"
          return s:get_html_attribute_indent(prev_lnum)
        endif
      endif
    elseif char ==# "{"
      return indent(prev_lnum)
    elseif char ==# "}"
      return s:get_c_indent(v:lnum)
    endif
  elseif syngroup ==# "razorcsDelimiter"
    return s:get_c_indent(v:lnum)
  elseif syngroup ==# "razorInnerHTMLBlock"
    return s:get_html_indent(v:lnum, prev_lnum)
  endif

  let line = getline(v:lnum)
  let [char, idx, _] = matchstrpos(line, '\S')

  if char ==# "{"
    let syngroup = synIDattr(synID(v:lnum, idx + 1, 0), "name")

    if syngroup ==# "razorDelimiter"
      return indent(prev_lnum)
    elseif syngroup ==# "razorcsDelimiter"
      return s:get_c_indent(v:lnum)
    endif
  elseif char ==# "}"
    return s:get_c_indent(v:lnum)
  elseif char ==# "<" && line[idx + 1] ==# "/"
    return s:get_html_indent(v:lnum, prev_lnum)
  endif

  let [prev_line, prev_first_char, prev_first_idx, prev_last_char, prev_last_idx] = s:get_line_with_first_and_last_chars(prev_lnum)

  if prev_last_idx == -1
    " Previous line was a comment line.
    return indent(prev_lnum)
  endif

  if prev_last_char ==# "{"
    let syngroup = synIDattr(synID(prev_lnum, prev_last_idx + 1, 0), "name")

    if syngroup ==# "razorDelimiter" || syngroup ==# "razorcsDelimiter"
      return s:get_c_indent(v:lnum)
    endif
  elseif prev_last_char ==# "}"
    let syngroup = synIDattr(synID(prev_lnum, prev_last_idx + 1, 0), "name")

    if syngroup ==# "razorDelimiter"
      return s:get_html_indent(v:lnum, prev_lnum)
    elseif syngroup ==# "razorcsDelimiter"
      return s:get_c_indent(v:lnum)
    endif
  elseif prev_last_char ==# ">"
    let syngroup = synIDattr(synID(prev_lnum, prev_last_idx + 1, 0), "name")

    if syngroup ==# "razorhtmlTag" || syngroup ==# "razorhtmlEndTag" || syngroup == "razorInnerHTMLEndBracket"
      return s:get_html_indent(v:lnum, prev_lnum)
    else
      return s:get_c_indent(v:lnum)
    endif
  elseif prev_last_char ==# "]"
    return indent(s:get_start_line(prev_lnum))
  elseif prev_first_char ==# "@"
    return indent(s:get_start_line(prev_lnum))
  else
    return s:get_c_indent(v:lnum)
  endif

  return s:get_html_indent(v:lnum, prev_lnum)
endfunction

function s:get_html_indent(lnum, prev_lnum)
  let shift = 0

  if getline(a:lnum) =~# '^\s*</'
    let shift -= 1
  endif

  let start_lnum = s:get_start_line(a:prev_lnum)

  call cursor(a:lnum, 1)

  let [lnum, col, p] = searchpos('\(</\@!\)\|\(</\)', "bp", start_lnum)
  let pairs = 0

  while lnum
    if p == 2
      if synIDattr(synID(lnum, col, 0), "name") !=# "razorhtmlTag"
        let [lnum, col, p] = searchpos('\(</\@!\)\|\(</\)', "bp", start_lnum)
        continue
      endif

      let [l, c] = searchpos(">", "zW")

      while l
        let syngroup = synIDattr(synID(l, c, 0), "name")

        if syngroup ==# "razorhtmlTag" || syngroup ==# "razorInnerHTMLEndBracket"
          break
        endif

        let [l, c] = searchpos(">", "zW")
      endwhile

      if l
        call cursor(lnum, col)
      endif

      if getline(l)[c - 2] ==# "/"
        let [lnum, col, p] = searchpos('\(</\@!\)\|\(</\)', "bp", start_lnum)
        continue
      endif

      if pairs == 1
        break
      endif

      if strpart(getline(lnum), col) !~# '\v^%(area|base|br|col|embed|hr|img|input|keygen|link|meta|param|source|track|wbr)[[:space:]>]\@='
        let pairs += 1
      endif
    elseif p == 3
      if synIDattr(synID(lnum, col, 0), "name") ==# "razorhtmlEndTag"
        let pairs -= 1
      endif
    endif

    let [lnum, col, p] = searchpos('\(</\@!\)\|\(</\)', "bp", start_lnum)
  endwhile

  if pairs == 1
    let shift += 1
  endif

  return indent(start_lnum) + shift * shiftwidth()
endfunction

function s:get_html_attribute_indent(prev_lnum)
  " If the previous line began with an attribute, align with that
  " attribute; else, if it began with a tag, align with the first
  " attribute after that tag, unless there is no attribute after tag, in
  " which case add a shift.
  let line = getline(a:prev_lnum)
  let [char, idx, _] = matchstrpos(line, '\S')

  if char ==# "<"
    let idx2 = match(line, '\s', idx + 1)

    if idx2 == -1
      " Nothing after the tag name
      return idx + shiftwidth()
    endif

    let idx2 = match(line, '\S', idx2 + 1)

    if idx2 == -1
      " Nothing but whitespace after the tag name
      return idx + shiftwidth()
    endif

    return idx2
  else
    return idx
  endif
endfunction

function s:get_c_indent(lnum)
  let old_sw = &shiftwidth
  let &shiftwidth = s:cs_shiftwidth
  let ind = cindent(a:lnum)
  let &shiftwidth = old_sw

  return ind
endfunction
" }}}

" vim:fdm=marker

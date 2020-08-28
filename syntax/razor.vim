" Vim syntax file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Setup {{{1
" =====

if exists("b:current_syntax")
  finish
endif

let s:include_path = expand("<sfile>:p:h")."/../include"

if get(g:, "razor_fold")
  setlocal foldmethod=syntax
endif

" Syntax groups {{{1
" =============

" The syntax files for C# and HTML are kept in a separate directory so
" that they don't get picked up by Vim in other contexts.
execute "source ".s:include_path."/html.vim"
execute "syn include @razorCS ".s:include_path."/cs.vim"

syn cluster razorTop contains=TOP

syn match razorDelimiter /\%#=1\w\@1<!@/ display nextgroup=razorImplicitExpression,razorExplicitExpression,razorBlock,@razorStatements,razorDelimiterEscape
syn match razorDelimiter /\%#=1@/ display contained containedin=razorHTMLTag nextgroup=razorExplicitExpression,@razorDirectiveAttributes,razorDelimiterEscape
syn match razorDelimiter /\%#=1\w\@1<!@/ display contained containedin=razorHTMLValue nextgroup=razorImplicitExpression,razorExplicitExpression,razorDelimiterEscape

syn match razorDelimiterEscape /\%#=1@/ display contained

syn match razorImplicitExpression /\%#=1\h[[:alnum:].]*/ display contained nextgroup=razorParentheses,razorBrackets
syn region razorExplicitExpression matchgroup=razorDelimiter start=/(/ end=/)/ display contained oneline contains=@razorCS

syn region razorParentheses matchgroup=razorDelimiter start=/(/ end=/)/ display contained oneline nextgroup=razorBrackets
syn region razorBrackets matchgroup=razorDelimiter start=/\[/ end=/]/ display contained oneline nextgroup=razorBrackets

syn region razorLine start=// end=/\_$/ display contained oneline

syn region razorBlock matchgroup=razorDelimiter start=/{/ end=/}/ display contained contains=@razorTop,@razorCS,razorCSBlock,razorInnerHTML nextgroup=razorElse,razorWhile,razorCatch,razorFinally skipwhite

syn region razorInnerHTML matchgroup=razorDelimiter start=/\%#=1@:/ end=/\_$/ display contained oneline containedin=razorBlock,razorCSBlock contains=TOP
syn region razorInnerHTML start=/\%#=1<\a/ end=/\%#=1<\/\a[[:alnum:].-]*>/ display contained keepend extend contains=@razorTop,razorInnerHTML
syn match  razorInnerHTML /\%#=1<\a[^<]\{-}\/>/ display contained contains=razorHTMLTag
syn region razorInnerHTML start=/\%#=1<\%(area\|base\|br\|col\|command\|embed\|hr\|img\|input\|keygen\|link\|meta\|param\|source\|track\|wbr\)\>/ end=/>/ display contained oneline contains=razorHTMLTag

syn region razorCondition matchgroup=razorDelimiter start=/(/ end=/)/ display contained oneline contains=razorParentheses nextgroup=razorBlock skipwhite skipnl

syn keyword razorAwait     await       contained nextgroup=razorImplicitExpression  skipwhite
syn keyword razorIf        if          contained nextgroup=razorCondition           skipwhite
syn keyword razorElse      else        contained nextgroup=razorIf,razorBlock       skipwhite skipnl
syn keyword razorSwitch    switch      contained nextgroup=razorCondition           skipwhite
syn keyword razorFor       for foreach contained nextgroup=razorCondition           skipwhite
syn keyword razorWhile     while       contained nextgroup=razorCondition           skipwhite
syn keyword razorDo        do          contained nextgroup=razorBlock               skipwhite skipnl
syn keyword razorUsing     using       contained nextgroup=razorCondition,razorLine skipwhite
syn keyword razorTry       try         contained nextgroup=razorBlock               skipwhite skipnl
syn keyword razorCatch     catch       contained nextgroup=razorCondition           skipwhite
syn keyword razorFinally   finally     contained nextgroup=razorBlock               skipwhite skipnl
syn keyword razorLock      lock        contained nextgroup=razorCondition           skipwhite
syn keyword razorCode      code        contained nextgroup=razorBlock               skipwhite skipnl
syn keyword razorFunctions functions   contained nextgroup=razorBlock               skipwhite skipnl
syn keyword razorSection   section     contained nextgroup=razorIdentifier          skipwhite

syn keyword razorDirective contained nextgroup=razorLine
      \ attribute implements inherits inject layout model namespace page
      \ typeparam addTagHelper removeTagHelper tagHelperPrefix

syn cluster razorStatements contains=
      \ razorAwait,razorIf,razorElse,razorSwitch,razorFor,razorWhile,razorDo,
      \ razorUsing,razorTry,razorCatch,razorFinally,
      \ razorCode,razorFunctions,razorSection,razorDirective

syn match razorIdentifier /\%#=1\h[[:alnum:].]*/ display contained nextgroup=razorBlock skipwhite skipnl

syn keyword razorAttributes attributes contained nextgroup=razorHTMLAttributeOperator
syn match razorBind /bind\%(-\h\w*\)\=\%(:event\)\=\>/ display contained nextgroup=razorHTMLAttributeOperator

syn keyword razorEventAttribute contained nextgroup=razorHTMLAttributeOperator,razorEventModifier
      \ oncut oncopy onpaste
      \
      \ ondrag ondragstart ondragenter ondragleave ondargover ondrop
      \ ondragend
      \
      \ onerror
      \
      \ onactivate onbeforeactivate onbeforedeactivate ondeactivate
      \ onfullscreenchange onfullscreenerror onloadeddata
      \ onloadedmetadata onpointerlockchange onpointerlockerror
      \ onreadystatechange onscroll
      \
      \ onbeforecut onbeforecopy onbeforepaste
      \
      \ oninvalid onreset onselect onselectionchange onselectstart
      \
      \ oncanplay oncanplaythrough oncuechange ondurationchange
      \ onemptied onended onpause onplay onplaying onratechange onseeked
      \ onseeking onstalled onstop onsuspend ontimeupdate onvolumechange
      \ onwaiting
      \
      \ onfocus onblur onfocusin onfocusout
      \
      \ onchange oninput
      \
      \ onkeydown onkeypress onkeyup
      \
      \ onclick oncontextmenu ondblclick onmousedown onmouseup
      \ onmouseover onmousemove onmouseout
      \
      \ onpointerdown onpointerup onpointercancel onpointermove
      \ onpointerover onpointerout onpointerenter onpointerleave
      \ onpointercapture onlostpointercapture
      \
      \ onwheel onmousewheel
      \
      \ onabort onload onloadend onloadstart onprogress ontimeout
      \
      \ ontouchstart ontouchend ontouchmove ontouchenter ontouchleave
      \ ontouchcancel

syn match razorEventModifier /:\%(preventDefault\|stopPropagation\)\>/ display contained nextgroup=razorHTMLAttributeOperator
syn keyword razorKey key contained nextgroup=razorHTMLAttributeOperator
syn keyword razorRef ref contained nextgroup=razorHTMLAttributeOperator

syn cluster razorDirectiveAttributes contains=
      \ razorAttributes,razorBind,razorEventAttribute,razorKey,razorRef

syn region razorComment start=/\%#=1@\*/ end=/\*@/ display keepend contains=razorCSTodo containedin=ALL

" Default highlighting {{{1
" ====================

hi def link razorDefault PreProc

hi def link razorDelimiter razorDefault
hi def link razorKeyword razorDefault

hi def link razorParentheses razorDefault
hi def link razorBrackets razorDefault
hi def link razorCondition razorParentheses
hi def link razorLine razorDefault
hi def link razorImplicitExpression razorDefault
hi def link razorDelimiterEscape razorDelimiter
hi def link razorComment Comment
hi def link razorAwait razorKeyword
hi def link razorIf razorKeyword
hi def link razorElse razorKeyword
hi def link razorSwitch razorKeyword
hi def link razorFor razorKeyword
hi def link razorWhile razorKeyword
hi def link razorDo razorKeyword
hi def link razorUsing razorKeyword
hi def link razorTry razorKeyword
hi def link razorCatch razorKeyword
hi def link razorFinally razorKeyword
hi def link razorLock razorKeyword
hi def link razorCode razorKeyword
hi def link razorFunctions razorKeyword
hi def link razorSection razorKeyword
hi def link razorIdentifier razorDefault
hi def link razorDirective razorKeyword
hi def link razorAttributes razorKeyword
hi def link razorBind razorKeyword
hi def link razorEventAttribute razorKeyword
hi def link razorEventModifier razorEventAttribute
hi def link razorKey razorKeyword
hi def link razorRef razorKeyword

" }}}

unlet s:include_path

let b:current_syntax = "razor"

" vim:fdm=marker

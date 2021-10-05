" Vim syntax file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

if exists("b:current_syntax")
  finish
endif

let b:main_syntax = "razor"

let s:include_path = expand("<sfile>:p:h") .. "/../include"

if get(g:, "razor_fold")
  setlocal foldmethod=syntax
endif

" Syntax {{{1
" NOTE: The syntax files for C# and HTML are kept in a separate
" directory so that they don't get picked up by Vim in other contexts.
execute "source " .. s:include_path .. "/html.vim"

syn cluster razorTop contains=TOP

" These are regions where Razor interpolation can occur:
syn cluster razorInterpolation contains=razorhtmlValue,razorhtmlScript,razorhtmlStyle,javascriptString,cssValue

syn match razorDelimiter /\%#=1\w\@1<!@/ nextgroup=razorImplicitExpression,razorExplicitExpression,razorBlock,@razorStatements
syn match razorDelimiter /\%#=1\w\@1<!@/ contained containedin=@razorInterpolation nextgroup=razorImplicitExpression,razorExplicitExpression
syn match razorDelimiter /\%#=1@/ contained containedin=razorhtmlTag nextgroup=@razorDirectiveAttributes

syn match razorDelimiterEscape /\%#=1@@/ containedin=@razorInterpolation

syn match razorImplicitExpression /\%#=1\h\w*/ contained nextgroup=razorDot,razorParentheses,razorBrackets
syn region razorExplicitExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained oneline contains=@razorcsRHS

syn match  razorDot /\%#=1?\=\./ contained nextgroup=razorImplicitExpression
syn region razorParentheses matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained oneline nextgroup=razorDot,razorParentheses,razorBrackets
syn region razorBrackets matchgroup=razorDelimiter start=/\%#=1?\=\[/ end=/\%#=1]/ contained oneline nextgroup=razorDot,razorParentheses,razorBrackets

syn match razorLine /\%#=1\S.*/ contained

syn region razorBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorTop,@razorcs,razorHTML nextgroup=razorElse,razorWhile,razorCatch,razorFinally skipwhite

syn region razorHTML matchgroup=razorDelimiter start=/\%#=1@:/ end=/\%#=1$/ contained contains=TOP
syn region razorHTML start=/\%#=1<\a/ end=/\%#=1>/me=e-1 skip=/\%#=1\(['"]\).\{-}\1/ contained keepend contains=razorhtmlTag nextgroup=razorInnerHTML,razorhtmlTag skipnl
syn region razorInnerHTML matchgroup=razorhtmlTag start=/\%#=1>/ matchgroup=razorhtmlEndTag end=/\%#=1<\/.\{-}>/ contained contains=@razorTop,razorHTML
syn match razorhtmlTag /\%#=1\/\@1<=>/ contained
syn match razorhtmlTag /\%#=1><\/.\{-}>/ contained contains=razorhtmlEndTag
syn region razorHTML start=/\%#=1<\%(area\|base\|br\|col\|command\|embed\|hr\|img\|input\|keygen\|link\|meta\|param\|source\|track\|wbr\)\>/ end=/\%#=1>/ skip=/\%#=1\(['"]\).\{-}\1/ contained keepend contains=razorhtmlTag
syn region razorHTML matchgroup=razorhtmlTag start=/\%#=1<script\>/ end=/\%#=1>/ contains=razorhtmlAttribute nextgroup=razorhtmlScript,razorhtmlEndTag skipnl
syn region razorHTML matchgroup=razorhtmlTag start=/\%#=1<style\>/ end=/\%#=1>/ contains=razorhtmlAttribute nextgroup=razorhtmlStyle,razorhtmlEndTag skipnl

syn region razorCondition matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained oneline contains=razorParentheses nextgroup=razorBlock skipwhite skipnl

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

syn keyword razorDirective contained nextgroup=razorLine skipwhite
      \ attribute implements inherits inject layout model namespace page
      \ typeparam addTagHelper removeTagHelper tagHelperPrefix

syn cluster razorStatements contains=
      \ razorAwait,razorIf,razorElse,razorSwitch,razorFor,razorWhile,razorDo,
      \ razorUsing,razorTry,razorCatch,razorFinally,razorLock,
      \ razorCode,razorFunctions,razorSection,razorDirective

syn match razorIdentifier /\%#=1\h[[:alnum:]_.]*/ contained nextgroup=razorBlock skipwhite skipnl

syn keyword razorAttributes attributes contained nextgroup=razorhtmlAttributeOperator
syn match razorBind /\%#=1bind\%(-\h\w*\)\=\%(:\%(event\|format\)\)\=\>/ contained nextgroup=razorhtmlAttributeOperator

syn keyword razorEventAttribute contained nextgroup=razorhtmlAttributeOperator,razorEventModifier
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
      \ onsubmit
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

syn match razorEventModifier /\%#=1:\%(preventDefault\|stopPropagation\)\>/ contained nextgroup=razorhtmlAttributeOperator
syn keyword razorKey key contained nextgroup=razorhtmlAttributeOperator
syn keyword razorRef ref contained nextgroup=razorhtmlAttributeOperator

syn cluster razorDirectiveAttributes contains=
      \ razorAttributes,razorBind,razorEventAttribute,razorKey,razorRef

syn region razorComment start=/\%#=1@\*/ end=/\%#=1\*@/ contains=razorcsTodo containedin=ALLBUT,razorComment

" NOTE: The C# file is included last in order to take precedence over
" other patterns.
execute "syn include @razorcs " .. s:include_path .. "/cs.vim"

" Synchronization {{{1
syn sync fromstart

" Highlighting {{{1
hi def link razorDefault PreProc

hi def link razorDelimiter razorDefault
hi def link razorKeyword razorDefault

hi def link razorImplicitExpression razorDefault
hi def link razorDot razorImplicitExpression
hi def link razorParentheses razorImplicitExpression
hi def link razorBrackets razorImplicitExpression
hi def link razorCondition razorParentheses
hi def link razorLine razorDefault
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
" }}}1

unlet s:include_path

let b:current_syntax = "razor"

" vim:fdm=marker

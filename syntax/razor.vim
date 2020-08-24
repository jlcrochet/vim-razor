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

syn cluster razorTop contains=TOP,razorComment,razorEscapedDelimiter
syn cluster razorAllowed contains=@razorTop,razorHTMLValue

syn cluster razorStatement contains=
      \ razorAsync,razorExpression,razorConditional,razorRepeat,razorUsing,razorException,razorLock,
      \ razorAttribute,razorCode,razorFunctions,razorImplements,razorInherits,razorInject,razorLayout,
      \ razorModel,razorNamespace,razorPage,razorSection,razorRef,razorBind,razorAddTagHelper,razorRemoveTagHelper,
      \ razorTypeparam,razorEventAttribute,razorAttributes

syn match razorDelimiter /\%#=1\w\@1<!@/ containedin=@razorAllowed display nextgroup=@razorStatement,razorBlock

syn match razorExpression /\%#=1\h\w*\%(\.\h\w*\)*/ contains=@razorCS display contained nextgroup=razorBlock skipwhite skipnl
syn match razorExpression /\%#=1\h\w*\%(\.\h\w*\)*/ contains=@razorCS display contained nextgroup=razorParentheses,razorBrackets

syn keyword razorAsync await contained nextgroup=razorExpression skipwhite
syn keyword razorConditional if switch contained nextgroup=razorParentheses skipwhite
syn keyword razorConditional else contained nextgroup=razorConditional,razorBlock skipwhite skipnl
syn keyword razorRepeat for foreach while contained nextgroup=razorParentheses skipwhite
syn keyword razorRepeat do contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorUsing using contained nextgroup=razorIdentifier,razorParentheses skipwhite
syn keyword razorException try finally contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorException catch contained nextgroup=razorParentheses skipwhite
syn keyword razorLock lock contained nextgroup=razorParentheses skipwhite
syn keyword razorAttribute attribute contained nextgroup=razorCSBracketed skipwhite
syn keyword razorCode code contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorFunctions functions contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorImplements implements contained nextgroup=razorIdentifier skipwhite
syn keyword razorInherits inherits contained nextgroup=razorIdentifier skipwhite
syn keyword razorInject inject contained nextgroup=razorArea skipwhite
syn keyword razorLayout layout contained nextgroup=razorIdentifier skipwhite
syn keyword razorModel model contained nextgroup=razorIdentifier skipwhite
syn keyword razorNamespace namespace contained nextgroup=razorIdentifier skipwhite
syn keyword razorPage page contained nextgroup=razorCSString skipwhite
syn keyword razorSection section contained nextgroup=razorExpression skipwhite
syn keyword razorAddTagHelper addTagHelper contained nextgroup=razorArea skipwhite
syn keyword razorRemoveTagHelper removeTagHelper contained nextgroup=razorArea skipwhite
syn keyword razorTypeparam typeparam contained nextgroup=razorIdentifier skipwhite

syn region razorParentheses matchgroup=razorDelimiter start=/(/ end=/)/ display contained contains=@razorCS nextgroup=razorBlock skipwhite skipnl
syn region razorBrackets matchgroup=razorDelimiter start=/\[/ end=/]/ display contained contains=@razorCS nextgroup=@razorCSContainedOperators,razorHTMLTag skipwhite skipnl

syn match razorIdentifier /\%#=1\h\w*\%(\.\h\w*\)*/ display contained nextgroup=razorCSGeneric

syn keyword razorRef ref contained nextgroup=razorHTMLAttributeOperator

syn match razorBind /bind\%(-\h\w*\)\=\>/ display contained nextgroup=razorEventArg,razorHTMLAttributeOperator

syn keyword razorEventAttribute contained nextgroup=razorEventArg,razorHTMLAttributeOperator
      \ oncut oncopy onpaste ondrag ondragstart ondragenter ondragleave
      \ ondragover ondrop ondragend onerror onactivate onbeforeactivate
      \ onbeforedeactivate ondeactive onfullscreenchange
      \ onfullscreenerror onloadeddata onloadedmetadata
      \ onpointerlockchange onpointerlockerror onreadystatechange
      \ onscroll onbeforecut onbeforecopy onbeforepaste oninvalid
      \ onreset onselect onselectionchange onselectstart oncanplay
      \ oncanplaythrough oncuechange onemptied onended onpause onplay
      \ onplaying onratechange onseeked onseeking onstalled onstop
      \ onsuspend ontimeupdate onvolumechange onwaiting onfocus onblur
      \ onfocusin onfocusout onchange oninput onkeydown onkeypress
      \ onkeyup onclick oncontextmenu ondblclick onmousedown onmouseup
      \ onmouseover onmousemove onmouseout onpointerdown onpointerup
      \ onpointercancel onpointermove onpointerover onpointerout
      \ onpointerenter onpointerleave ongotpointercapture
      \ onlostpointercapture onwheel onmousewheel onabort onload
      \ onloadend onloadstart onprogress ontimeout ontouchstart
      \ ontouchend ontouchmove ontouchcenter ontouchleave ontouchcancel

syn match razorEventArg /:\%(event\|preventDefault\|stopPropagation\)\>/ display contained nextgroup=razorHTMLAttributeOperator

syn match razorAttributes /attributes\>/ display contained nextgroup=razorHTMLAttributeOperator

syn region razorArea start=// end=/\_$/ display oneline contained

syn region razorInnerHTML start=/\%#=1<\a/ end=/\%#=1<\/\a.*>/ display contained keepend extend contains=@razorTop,razorInnerHTML
syn match razorInnerHTML /\%#=1<\%(area\|base\|br\|col\|command\|embed\|hr\|img\|input\|keygen\|link\|meta\|param\|source\|track\|wbr\)\>.*>/ display contained contains=TOP
syn match razorInnerHTML /\%#=1<\a.*\/>/ display contained contains=TOP
syn region razorInnerHTML matchgroup=razorDelimiter start=/\%#=1@:/ end=/\_$/ display contained contains=TOP

syn region razorBlock matchgroup=razorDelimiter start=/{/ end=/}/ contains=@razorTop,@razorCS,razorCSBlock,razorInnerHTML contained display fold nextgroup=razorConditional,razorRepeat,razorException skipwhite skipnl

syn region razorExpression matchgroup=razorDelimiter start=/\%#=1@(/ end=/)/ contains=@razorCS containedin=@razorAllowed oneline display

syn match razorEscapedDelimiter /\%#=1@@/ containedin=@razorAllowed display

syn region razorComment start=/\%#=1@\*/ end=/\*@/ contains=razorTodo containedin=ALL display keepend
syn keyword razorTodo TODO NOTE XXX FIXME HACK TBD

" Default highlighting {{{1
" ====================

hi def link razorExpression       PreProc
hi def link razorDelimiter        razorExpression
hi def link razorIdentifier       razorExpression
hi def link razorEscapedDelimiter razorExpression
hi def link razorComment          Comment
hi def link razorArea             razorExpression
hi def link razorParentheses      razorExpression
hi def link razorEventArg         razorEventAttribute
hi def link razorKeyword          Keyword
hi def link razorAsync            razorKeyword
hi def link razorConditional      razorKeyword
hi def link razorRepeat           razorKeyword
hi def link razorUsing            razorKeyword
hi def link razorException        razorKeyword
hi def link razorLock             razorKeyword
hi def link razorAttribute        razorKeyword
hi def link razorCode             razorKeyword
hi def link razorFunctions        razorKeyword
hi def link razorImplements       razorKeyword
hi def link razorInherits         razorKeyword
hi def link razorInject           razorKeyword
hi def link razorLayout           razorKeyword
hi def link razorModel            razorKeyword
hi def link razorNamespace        razorKeyword
hi def link razorPage             razorKeyword
hi def link razorSection          razorKeyword
hi def link razorRef              razorKeyword
hi def link razorBind             razorKeyword
hi def link razorAddTagHelper     razorKeyword
hi def link razorRemoveTagHelper  razorKeyword
hi def link razorTypeparam        razorKeyword
hi def link razorEventAttribute   razorKeyword
hi def link razorAttributes       razorKeyword
" }}}

unlet s:include_path

let b:current_syntax = "razor"

" vim:fdm=marker

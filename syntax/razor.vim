" Vim syntax file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

" Setup {{{1
" =====

if exists("b:current_syntax")
  finish
endif

if get(g:, "razor_fold")
  setlocal foldmethod=syntax
endif

runtime! syntax/html.vim
unlet! b:current_syntax

let b:razor_highlight_cs = get(g:, "razor_highlight_cs", "full")

if type(b:razor_highlight_cs) != 1
  echoerr 'Valid values for razor_highlight_cs are "full", "half", "none"'
endif

" Syntax groups {{{1
" =============

syn cluster razorHTML contains=TOP

syn cluster razorAllowed contains=TOP,razorEscapedDelimiter,razorComment

syn region razorComment start=/@\*/ end=/\*@/ contains=razorTODO containedin=ALL display keepend
syn keyword razorTODO TODO NOTE XXX FIXME HACK TBD

" HTML tags for Razor
syn keyword htmlTagName text app component environment contained

" HTML args for ASP.NET
syn match htmlArg /\<asp-\a[[:alnum:]-]*/ display contained

" HACK: Redefine htmlString so that it can contain Razor expressions
syn region htmlString contained start=/"/ end=/"/ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc,razorDelimiter
syn region htmlString contained start=/'/ end=/'/ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc,razorDelimiter

if b:razor_highlight_cs !=# "none"
  syn include @razorCS syntax/cs.vim

  " HACK: The csNewType and csClassType groups delivered by the Vim's
  " syntax file are really slow and break Razor highlighting a lot, so we
  " are redefining them here.
  syn clear csNewType csClassType csNew csClass
  syn keyword csNew new nextgroup=csUserType skipwhite
  syn keyword csClass class
  syn cluster razorCS add=csNew,csClass
endif

" HACK: We need to define another csBracketed region for square brackets
" so that they will be highlighted properly inside of expressions.
syn region csBracketed matchgroup=csBraces start=/\[/ end=/]/ contains=@razorCS,csBracketed contained display transparent

syn region razorParentheses matchgroup=razorDelimiter start=/(/ end=/)/ contains=@razorCS,csBracketed display contained nextgroup=razorBlock skipwhite skipnl

" HACK: We need to define a fresh pattern for inner HTML regions so that
" they don't get clobbered by C# patterns that involve < and >.
"
" TODO: This could probably be improved
syn region razorInnerHTML start=/\_^\s*\zs<\z(\a[[:alnum:]-]*\)\>/ end=/<\/\z1>/ contains=@razorHTML,razorInnerHTML display contained transparent keepend extend
syn match  razorInnerHTML /\_^\s*\zs<\%(area\|base\|br\|col\|embed\|hr\|img\|input\|link\|meta\|param\|source\|track\|wbr\)\>.\{-}>/ display contained contains=htmlTag
syn match  razorInnerHTML /\_^\s*\zs<.\{-}\/>/ display contained contains=htmlTag
syn region razorInnerHTML matchgroup=razorDelimiter start=/@:/ end=/\_$/ contains=TOP containedin=@razorAllowed display oneline contained keepend

" Implicit expressions:
syn cluster razorStatement contains=
      \ razorAsync,razorExpression,razorConditional,razorRepeat,razorUsing,razorException,razorLock,
      \ razorAttribute,razorCode,razorFunctions,razorImplements,razorInherits,razorInject,razorLayout,
      \ razorModel,razorNamespace,razorPage,razorSection,razorBind,razorAddTagHelper,razorRemoveTagHelper,
      \ razorTypeparam,razorEventArg

syn match razorDelimiter /\%#=1\w\@1<!@/ containedin=@razorAllowed display nextgroup=@razorStatement,razorBlock

syn match razorExpression /\h\w*\%(\.\h\w*\)*/ contains=@razorCS display contained nextgroup=csBracketed,razorBrackets,razorBlock skipwhite skipnl

syn keyword razorAsync await contained nextgroup=razorExpression skipwhite
syn keyword razorConditional if switch contained nextgroup=razorParentheses skipwhite
syn keyword razorConditional else contained nextgroup=razorConditional,razorBlock skipwhite skipnl
syn keyword razorRepeat for foreach while contained nextgroup=razorParentheses skipwhite
syn keyword razorRepeat do contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorUsing using contained nextgroup=razorIdentifier skipwhite
syn keyword razorException try finally contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorException catch contained nextgroup=razorParentheses skipwhite
syn keyword razorLock lock contained nextgroup=razorParentheses skipwhite
syn keyword razorAttribute attribute contained nextgroup=razorBrackets skipwhite
syn keyword razorCode code contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorFunctions functions contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorImplements implements contained nextgroup=razorIdentifier skipwhite
syn keyword razorInherits inherits contained nextgroup=razorIdentifier skipwhite
syn keyword razorInject inject contained nextgroup=razorArea skipwhite
syn keyword razorLayout layout contained nextgroup=razorIdentifier skipwhite
syn keyword razorModel model contained nextgroup=razorIdentifier skipwhite
syn keyword razorNamespace namespace contained nextgroup=razorIdentifier skipwhite
syn keyword razorPage page contained nextgroup=csString skipwhite
syn keyword razorSection section contained nextgroup=razorExpression skipwhite
syn keyword razorAddTagHelper addTagHelper contained nextgroup=razorArea skipwhite
syn keyword razorRemoveTagHelper removeTagHelper contained nextgroup=razorArea skipwhite
syn keyword razorTypeparam typeparam contained nextgroup=razorIdentifier skipwhite

syn match razorBind /bind\>/ display contained
syn match razorBind /bind\%(-\h\w*\)\>/ display contained nextgroup=razorEventAttribute

syn keyword razorEventArg contained nextgroup=razorEventAttribute
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

syn match razorEventAttribute /:event\>/ display contained
syn match razorEventAttribute /:preventDefault\>/ display contained
syn match razorEventAttribute /:stopPropagation\>/ display contained

syn match razorIdentifier /\h\w*\%(\.\h\w*\)*/ display contained nextgroup=csGeneric

syn region razorArea start=// end=/\_$/ display oneline contained

let s:razor_block_string = "syn region razorBlock matchgroup=razorDelimiter start=/{/ end=/}/ contains=@razorCS,razorInnerBlock,razorInnerHTML,razorDelimiter contained display fold nextgroup=razorConditional,razorRepeat,razorException skipwhite skipnl"
let s:razor_inner_block_string = "syn region razorInnerBlock matchgroup=csBraces start=/{/ end=/}/ contains=@razorCS,razorInnerHTML,razorInnerBlock contained display"

if b:razor_highlight_cs !=# "none"
  let s:razor_block_string .= " transparent"
  let s:razor_inner_block_string .= " transparent"
endif

execute s:razor_block_string
execute s:razor_inner_block_string

unlet s:razor_block_string
unlet s:razor_inner_block_string

" Explicit expressions:
syn region razorExpression matchgroup=razorDelimiter start=/@(/ end=/)/ contains=@razorCS,csBracketed containedin=@razorAllowed,htmlString oneline display

" This is defined late in order to take precedence over other patterns
" that start with a @
syn match razorEscapedDelimiter /@@/ containedin=@razorAllowed display

" Default highlighting {{{1
" ====================

hi def link razorExpression       PreProc
hi def link razorDelimiter        razorExpression
hi def link razorEscapedDelimiter PreProc
hi def link razorComment          Comment
hi def link razorIdentifier       razorExpression
hi def link razorArea             razorExpression
hi def link razorParentheses      razorExpression
hi def link razorEventAttribute   razorEventArg

if b:razor_highlight_cs ==# "full"
  hi def link razorAsync           csAsync
  hi def link razorConditional     csConditional
  hi def link razorRepeat          csRepeat
  hi def link razorUsing           csUnspecifiedStatement
  hi def link razorException       csException
  hi def link razorLock            csUnspecifiedStatement
  hi def link razorAttribute       csUnspecifiedStatement
  hi def link razorCode            csUnspecifiedStatement
  hi def link razorFunctions       csUnspecifiedStatement
  hi def link razorImplements      csUnspecifiedStatement
  hi def link razorInherits        csUnspecifiedStatement
  hi def link razorInject          csUnspecifiedStatement
  hi def link razorLayout          csUnspecifiedStatement
  hi def link razorModel           csUnspecifiedStatement
  hi def link razorNamespace       csStorage
  hi def link razorPage            csUnspecifiedStatement
  hi def link razorSection         csUnspecifiedStatement
  hi def link razorBind            csUnspecifiedStatement
  hi def link razorAddTagHelper    csUnspecifiedStatement
  hi def link razorRemoveTagHelper csUnspecifiedStatement
  hi def link razorTypeparam       csUnspecifiedStatement
  hi def link razorEventArg        csUnspecifiedStatement
elseif b:razor_highlight_cs ==# "half"
  hi def link razorAsync           razorExpression
  hi def link razorConditional     razorExpression
  hi def link razorRepeat          razorExpression
  hi def link razorUsing           razorExpression
  hi def link razorException       razorExpression
  hi def link razorLock            razorExpression
  hi def link razorAttribute       razorExpression
  hi def link razorCode            razorExpression
  hi def link razorFunctions       razorExpression
  hi def link razorImplements      razorExpression
  hi def link razorInherits        razorExpression
  hi def link razorInject          razorExpression
  hi def link razorLayout          razorExpression
  hi def link razorModel           razorExpression
  hi def link razorNamespace       razorExpression
  hi def link razorPage            razorExpression
  hi def link razorSection         razorExpression
  hi def link razorBind            razorExpression
  hi def link razorAddTagHelper    razorExpression
  hi def link razorRemoveTagHelper razorExpression
  hi def link razorTypeparam       razorExpression
  hi def link razorEventArg        razorExpression
else
  hi def link razorAsync           razorExpression
  hi def link razorConditional     razorExpression
  hi def link razorRepeat          razorExpression
  hi def link razorUsing           razorExpression
  hi def link razorException       razorExpression
  hi def link razorLock            razorExpression
  hi def link razorAttribute       razorExpression
  hi def link razorCode            razorExpression
  hi def link razorFunctions       razorExpression
  hi def link razorImplements      razorExpression
  hi def link razorInherits        razorExpression
  hi def link razorInject          razorExpression
  hi def link razorLayout          razorExpression
  hi def link razorModel           razorExpression
  hi def link razorNamespace       razorExpression
  hi def link razorPage            razorExpression
  hi def link razorSection         razorExpression
  hi def link razorBind            razorExpression
  hi def link razorAddTagHelper    razorExpression
  hi def link razorRemoveTagHelper razorExpression
  hi def link razorTypeparam       razorExpression
  hi def link razorEventArg        razorExpression

  hi def link razorBlock      razorExpression
  hi def link razorInnerBlock razorBlock

  hi def link csParens razorDelimiter
  hi def link csBraces razorDelimiter
endif

" }}}

let b:current_syntax = "razor"

" vim:fdm=marker

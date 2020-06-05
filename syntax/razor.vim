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
  setl foldmethod=syntax
endif

runtime! syntax/html.vim
unlet! b:current_syntax

let b:razor_highlight_cs = get(g:, "razor_highlight_cs", "full")

" Syntax groups {{{1
" =============

if b:razor_highlight_cs !=# "none"
  syn include @cs syntax/cs.vim
else
  syn cluster cs contains=
endif

if b:razor_highlight_cs !=# "full"
  " Define replacements for certain regions like csBracketed to be used
  " in regions where we are not highlighting C# groups
  syn region csBracketed start=/(/ end=/)/ contains=csBracketed contained transparent
endif

syn cluster razorAllowed contains=TOP,razorEscapedDelimiter,razorComment

syn region razorComment start=/@\*/ end=/\*@/ contains=razorTODO containedin=@razorAllowed display keepend
syn keyword razorTODO TODO NOTE XXX FIXME HACK TBD

" We need to define a fresh pattern for inner HTML regions so that they
" don't get clobbered by C# patterns that involve < and >.
"
" TODO: This could probably be improved
syn region razorInnerHTML start=/\_^\s*\zs<\z([[:alnum:]-]\+\).\{-}>/ end=/<\/\z1>\ze\s*\_$/ contains=TOP contained display transparent keepend
syn region razorInnerHTML matchgroup=razorDelimiter start=/@:/ end=/\_$/ contains=TOP containedin=@razorAllowed display transparent keepend

" Unlike in plain HTML, the <text> tag means something in Razor, so
" let's highlight it like a proper tag.
syn keyword htmlTagName text contained

" HTML args for ASP.NET
syn match htmlArg /\<asp-\%(action\|route-id\|for\|validation-for\|validation-summary\)\>/ display contained

" HACK: Redefine htmlString so that it can contain Razor expressions
syn region htmlString contained start=/"/ end=/"/ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc,razorDelimiter
syn region htmlString contained start=/'/ end=/'/ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc,razorDelimiter

" HACK: We also need to define another csBracketed region for square
" brackets so that they will be highlighted properly inside of
" expressions.
syn region csBracketed matchgroup=csBraces start=/\[/ end=/]/ contained display transparent contains=@cs,csBracketed

" Implicit expressions:
syn cluster razorStatement contains=razorAsync,razorExpression,razorConditional,razorRepeat,razorUsing,razorException,razorLock,razorAttribute,razorCode,razorFunctions,razorImplements,razorInherits,razorInjects,razorLayout,razorModel,razorNamespace,razorPage,razorSection,razorBind

syn match razorDelimiter /\w\@1<!@/ containedin=@razorAllowed display nextgroup=@razorStatement,razorBlock

syn region razorExpression start=/[^@[:space:]]/ end=/\%(\_$\|["'<>[:space:]]\@=\)/ contains=@cs,csBracketed contained display nextgroup=razorBlock skipwhite skipnl

syn keyword razorAsync await contained nextgroup=razorExpression skipwhite
syn keyword razorConditional if switch contained nextgroup=razorExpression skipwhite
syn keyword razorConditional else contained nextgroup=razorConditional,razorBlock skipwhite skipnl
syn keyword razorRepeat for foreach while contained nextgroup=razorExpression skipwhite
syn keyword razorRepeat do contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorUsing using contained nextgroup=razorExpression skipwhite
syn keyword razorException try finally contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorException catch contained nextgroup=razorExpression skipwhite
syn keyword razorLock lock contained nextgroup=razorExpression skipwhite
syn keyword razorAttribute attribute contained nextgroup=razorExpression skipwhite
syn keyword razorCode code contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorFunctions functions contained nextgroup=razorBlock skipwhite skipnl
syn keyword razorImplements implements contained nextgroup=razorIdentifier skipwhite
syn keyword razorInherits inherits contained nextgroup=razorIdentifier skipwhite
syn keyword razorInjects injects contained nextgroup=razorInjectExpression skipwhite
syn keyword razorLayout layout contained nextgroup=razorExpression skipwhite
syn keyword razorModel model contained nextgroup=razorIdentifier skipwhite
syn keyword razorNamespace namespace contained nextgroup=razorIdentifier skipwhite
syn keyword razorPage page contained
syn keyword razorSection section contained nextgroup=razorExpression skipwhite
syn keyword razorBind bind contained

syn match razorIdentifier /\<\u[[:alnum:].><]*/ contains=csGeneric contained display
syn match razorInjectExpression /\<\u[[:alnum:].><]*\s*\u\[[:alnum:]]*/ contains=razorIdentifier contained transparent

syn region razorBlock matchgroup=razorDelimiter start=/{/ end=/}/ contains=@cs,razorDelimiter,razorInnerHTML,razorInnerBlock contained display transparent fold nextgroup=razorConditional,razorRepeat,razorException skipwhite skipnl
syn region razorInnerBlock matchgroup=csBraces start=/{/ end=/}/ contains=@cs,razorInnerHTML,razorInnerBlock contained display transparent

" Explicit expressions:
syn region razorExpression matchgroup=razorDelimiter start=/@(/ end=/)/ contains=@cs,csBracketed containedin=@razorAllowed oneline display

" This is defined late in order to take precedence over other patterns
" that start with a @
syn match razorEscapedDelimiter /@@/ containedin=@razorAllowed display

" Default highlighting {{{1
" ====================

hi def link razorExpression PreProc
hi def link razorDelimiter razorExpression
hi def link razorEscapedDelimiter PreProc
hi def link razorComment Comment

if b:razor_highlight_cs ==# "full"
  hi def link razorAsync csAsync
  hi def link razorConditional csConditional
  hi def link razorRepeat csRepeat
  hi def link razorUsing csUnspecifiedStatement
  hi def link razorException csException
  hi def link razorLock csUnspecifiedStatement
  hi def link razorAttribute csUnspecifiedStatement
  hi def link razorCode csUnspecifiedStatement
  hi def link razorFunctions csUnspecifiedStatement
  hi def link razorImplements csUnspecifiedStatement
  hi def link razorInherits csUnspecifiedStatement
  hi def link razorInjects csUnspecifiedStatement
  hi def link razorLayout csUnspecifiedStatement
  hi def link razorModel csUnspecifiedStatement
  hi def link razorNamespace csStorage
  hi def link razorPage csUnspecifiedStatement
  hi def link razorSection csUnspecifiedStatement
  hi def link razorBind csUnspecifiedStatement

  hi def link razorIdentifier razorExpression
  hi def link razorInjectExpression razorExpression
else
  hi def link razorAsync razorExpression
  hi def link razorConditional razorExpression
  hi def link razorRepeat razorExpression
  hi def link razorUsing razorExpression
  hi def link razorException razorExpression
  hi def link razorLock razorExpression
  hi def link razorAttribute razorExpression
  hi def link razorCode razorExpression
  hi def link razorFunctions razorExpression
  hi def link razorImplements razorExpression
  hi def link razorInherits razorExpression
  hi def link razorInjects razorExpression
  hi def link razorLayout razorExpression
  hi def link razorModel razorExpression
  hi def link razorNamespace razorExpression
  hi def link razorPage razorExpression
  hi def link razorSection razorExpression
  hi def link razorBind razorExpression

  hi def link razorIdentifier razorExpression
  hi def link razorInjectExpression razorExpression
endif

" }}}

let b:current_syntax = "razor"

" vim:fdm=marker

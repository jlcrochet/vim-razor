" Vim syntax file
" Language: Razor (https://docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-razor

if exists("b:current_syntax")
  finish
endif

syn sync fromstart

syn cluster razorTop contains=TOP

" HTML
syn include @razorhtmlCss syntax/css.vim | unlet! b:current_syntax
syn include @razorhtmlJavaScript syntax/javascript.vim | unlet! b:current_syntax

syn case ignore

syn match razorhtmlTagStart /\%#=1<!\=/ nextgroup=razorhtmlTagName containedin=razorcsBlock
syn match razorhtmlTagName /\%#=1\a[^[:space:]/>]*/ contained nextgroup=razorhtmlAttribute,razorhtmlRazorAttribute,razorhtmlTagEnd,razorhtmlTagBlock skipwhite skipempty
syn match razorhtmlAttribute /\%#=1[^[:space:]/>=]\+/ contained nextgroup=razorhtmlTagEnd,razorhtmlTagBlock,razorhtmlAttribute,razorhtmlRazorAttribute,razorhtmlAttributeOperator skipwhite skipempty
syn match razorhtmlAttributeOperator /\%#=1=/ contained nextgroup=razorhtmlValue skipwhite skipempty
syn match razorhtmlValue /\%#=1[^>=[:space:]]\+/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlAttribute,razorhtmlRazorAttribute,razorhtmlTagEnd,razorhtmlTagBlock skipwhite skipempty
syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1"/ end=/\%#=1"/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlAttribute,razorhtmlRazorAttribute,razorhtmlTagEnd,razorhtmlTagBlock skipwhite skipempty
syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1'/ end=/\%#=1'/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlAttribute,razorhtmlRazorAttribute,razorhtmlTagEnd,razorhtmlTagBlock skipwhite skipempty
syn match razorhtmlTagEnd /\%#=1\/\=>/ contained
syn region razorhtmlTagBlock matchgroup=razorhtmlTagEnd start=/\%#=1>/ matchgroup=razorhtmlTagStart end=/\%#=1<\/!\=/ contained contains=TOP,razorhtmlDoctype nextgroup=razorhtmlEndTagName
syn match razorhtmlEndTagName /\%#=1\a[^[:space:]/>]*/ contained nextgroup=razorhtmlTagEnd

syn match razorhtmlRazorAttribute /\%#=1@/ contained nextgroup=razorhtmlAttribute,razorhtmlAttributeExplicitExpression
syn region razorhtmlAttributeExplicitExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorhtmlTagEnd,razorhtmlTagBlock,razorhtmlAttribute,razorhtmlRazorAttribute,razorhtmlAttributeOperator skipwhite skipempty

hi def link razorhtmlDelimiter Delimiter
hi def link razorhtmlTagStart razorhtmlDelimiter
hi def link razorhtmlTagEnd razorhtmlTagStart
hi def link razorhtmlTagName Special
hi def link razorhtmlEndTagName razorhtmlTagName
hi def link razorhtmlAttribute Keyword
hi def link razorhtmlRazorAttribute razorStart
hi def link razorhtmlAttributeOperator Operator
hi def link razorhtmlValue String
hi def link razorhtmlValueDelimiter razorhtmlDelimiter

syn match razorhtmlTagName /\%#=1\%(area\|base\|br\|col\|command\|embed\|hr\|img\|input\|keygen\|link\|meta\|param\|source\|track\|wbr\)[[:space:]/>]\@=/ contained nextgroup=razorhtmlNoBlockAttribute,razorhtmlRazorNoBlockAttribute,razorhtmlTagEnd skipwhite skipempty
syn match razorhtmlNoBlockAttribute /\%#=1[^[:space:]/>=]\+/ contained nextgroup=razorhtmlTagEnd,razorhtmlNoBlockAttribute,razorhtmlRazorNoBlockAttribute,razorhtmlNoBlockAttributeOperator skipwhite skipempty
syn match razorhtmlNoBlockAttributeOperator /\%#=1=/ contained nextgroup=razorhtmlNoBlockValue skipwhite skipempty
syn match razorhtmlNoBlockValue /\%#=1[^>=[:space:]]\+/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlNoBlockAttribute,razorhtmlRazorNoBlockAttribute,razorhtmlTagEnd skipwhite skipempty
syn region razorhtmlNoBlockValue matchgroup=razorhtmlValueDelimiter start=/\%#=1"/ end=/\%#=1"/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlNoBlockAttribute,razorhtmlRazorNoBlockAttribute,razorhtmlTagEnd skipwhite skipempty
syn region razorhtmlNoBlockValue matchgroup=razorhtmlValueDelimiter start=/\%#=1'/ end=/\%#=1'/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlNoBlockAttribute,razorhtmlRazorNoBlockAttribute,razorhtmlTagEnd skipwhite skipempty

syn match razorhtmlRazorNoBlockAttribute /\%#=1@/ contained nextgroup=razorhtmlNoBlockAttribute,razorhtmlNoBlockAttributeExplicitExpression
syn region razorhtmlNoBlockAttributeExplicitExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorhtmlTagEnd,razorhtmlNoBlockAttribute,razorhtmlNoBlockAttributeOperator skipwhite skipempty

hi def link razorhtmlNoBlockAttribute razorhtmlAttribute
hi def link razorhtmlNoBlockAttributeOperator razorhtmlAttributeOperator
hi def link razorhtmlNoBlockValue razorhtmlValue
hi def link razorhtmlRazorNoBlockAttribute razorhtmlRazorAttribute

syn match razorhtmlTagName /\%#=1style[[:space:]/>]\@=/ contained nextgroup=razorhtmlStyleAttribute,razorhtmlRazorStyleAttribute,razorhtmlStyleBlock skipwhite skipempty
syn match razorhtmlStyleAttribute /\%#=1[^[:space:]/>=]\+/ contained nextgroup=razorhtmlStyleBlock,razorhtmlStyleAttribute,razorhtmlRazorStyleAttribute,razorhtmlStyleAttributeOperator skipwhite skipempty
syn match razorhtmlStyleAttributeOperator /\%#=1=/ contained nextgroup=razorhtmlStyleValue skipwhite skipempty
syn match razorhtmlStyleValue /\%#=1[^>=[:space:]]\+/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlStyleAttribute,razorhtmlRazorStyleAttribute,razorhtmlStyleBlock skipwhite skipempty
syn region razorhtmlStyleValue matchgroup=razorhtmlValueDelimiter start=/\%#=1"/ end=/\%#=1"/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlStyleAttribute,razorhtmlRazorStyleAttribute,razorhtmlStyleBlock skipwhite skipempty
syn region razorhtmlStyleValue matchgroup=razorhtmlValueDelimiter start=/\%#=1'/ end=/\%#=1'/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlStyleAttribute,razorhtmlRazorStyleAttribute,razorhtmlStyleBlock skipwhite skipempty
syn region razorhtmlStyleBlock matchgroup=razorhtmlTagEnd start=/\%#=1>/ matchgroup=razorhtmlTagStart end=/\%#=1<\/!\=\zestyle>/ contained keepend contains=@razorhtmlCss nextgroup=razorhtmlEndStyleBlock
syn keyword razorhtmlEndStyleBlock style contained nextgroup=razorhtmlTagEnd

syn match razorhtmlRazorStyleAttribute /\%#=1@/ contained nextgroup=razorhtmlStyleAttribute,razorhtmlStyleAttributeExplicitExpression
syn region razorhtmlStyleAttributeExplicitExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorhtmlTagEnd,razorhtmlNoBlockAttribute,razorhtmlNoBlockAttributeOperator skipwhite skipempty

hi def link razorhtmlStyleAttribute razorhtmlAttribute
hi def link razorhtmlStyleAttributeOperator razorhtmlAttributeOperator
hi def link razorhtmlStyleValue razorhtmlValue
hi def link razorhtmlRazorStyleAttribute razorhtmlRazorAttribute
hi def link razorhtmlEndStyleBlock razorhtmlEndTagName

syn match razorhtmlTagName /\%#=1script[[:space:]/>]\@=/ contained nextgroup=razorhtmlScriptAttribute,razorhtmlRazorScriptAttribute,razorhtmlScriptBlock skipwhite skipempty
syn match razorhtmlScriptAttribute /\%#=1[^[:space:]/>=]\+/ contained nextgroup=razorhtmlScriptBlock,razorhtmlScriptAttribute,razorhtmlRazorScriptAttribute,razorhtmlScriptAttributeOperator skipwhite skipempty
syn match razorhtmlScriptAttributeOperator /\%#=1=/ contained nextgroup=razorhtmlScriptValue skipwhite skipempty
syn match razorhtmlScriptValue /\%#=1[^>=[:space:]]\+/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlScriptAttribute,razorhtmlRazorScriptAttribute,razorhtmlScriptBlock skipwhite skipempty
syn region razorhtmlScriptValue matchgroup=razorhtmlValueDelimiter start=/\%#=1"/ end=/\%#=1"/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlScriptAttribute,razorhtmlRazorScriptAttribute,razorhtmlScriptBlock skipwhite skipempty
syn region razorhtmlScriptValue matchgroup=razorhtmlValueDelimiter start=/\%#=1'/ end=/\%#=1'/ contained contains=razorhtmlCharacterReference nextgroup=razorhtmlScriptAttribute,razorhtmlRazorScriptAttribute,razorhtmlScriptBlock skipwhite skipempty
syn region razorhtmlScriptBlock matchgroup=razorhtmlTagEnd start=/\%#=1>/ matchgroup=razorhtmlTagStart end=/\%#=1<\/!\=\zescript>/ contained keepend contains=@razorhtmlJavaScript nextgroup=razorhtmlEndScriptBlock
syn keyword razorhtmlEndScriptBlock script contained nextgroup=razorhtmlTagEnd

syn match razorhtmlRazorScriptAttribute /\%#=1@/ contained nextgroup=razorhtmlScriptAttribute,razorhtmlScriptAttributeExplicitExpression
syn region razorhtmlScriptAttributeExplicitExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorhtmlTagEnd,razorhtmlNoBlockAttribute,razorhtmlNoBlockAttributeOperator skipwhite skipempty

hi def link razorhtmlScriptAttribute razorhtmlAttribute
hi def link razorhtmlScriptAttributeOperator razorhtmlAttributeOperator
hi def link razorhtmlScriptValue razorhtmlValue
hi def link razorhtmlRazorScriptAttribute razorhtmlRazorAttribute
hi def link razorhtmlEndScriptBlock razorhtmlEndTagName

syn match razorhtmlCharacterReference /\%#=1&\%(\a\+\|#\%(\d\+\|[xX]\x\+\)\);/

syn region razorhtmlComment matchgroup=razorhtmlCommentStart start=/\%#=1<!--/ matchgroup=razorhtmlCommentEnd end=/\%#=1-->/
syn region razorhtmlDoctype start=/\%#=1<!doctype[[:space:]>]\@=/ end=/\%#=1>/ contains=razorhtmlCharacterReference

syn match razorhtmlError /\%#=1>/

hi def link razorhtmlCharacterReference SpecialChar
hi def link razorhtmlComment Comment
hi def link razorhtmlCommentStart razorhtmlComment
hi def link razorhtmlCommentEnd razorhtmlCommentStart
hi def link razorhtmlDoctype PreProc
hi def link razorhtmlError Error

syn case match

" Razor
syn include @razorcs include/razorcs.vim

syn match razorStart /\%#=1\k\@1<!@/ nextgroup=razorIdentifier,razorTypeof,razorStartEscape,razorHTMLLineStart,@razorDirectives,razorBlock containedin=razorhtmlValue,razorhtmlNoBlockValue,razorhtmlStyleValue,razorhtmlScriptValue
syn match razorStart /\%#=1@(\@=/ nextgroup=razorExplicitExpression containedin=razorhtmlValue,razorhtmlNoBlockValue,razorhtmlStyleValue,razorhtmlScriptValue
syn match razorStart /\%#=1@/ contained containedin=razorcsBlock nextgroup=razorIdentifier,razorTypeof,@razorDirectives

syn match razorHTMLLineStart /\%#=1@:/ contained containedin=razorBlock nextgroup=razorHTMLLine
syn match razorHTMLLine /\%#=1.*/ contained contains=TOP

syn match razorRHSStart /\%#=1@[$"]\@!/ contained nextgroup=razorhtmlTagStart
syn cluster razorcsRHS add=razorRHSStart

syn match razorStartEscape /\%#=1@/ contained

syn region razorComment matchgroup=razorCommentStart start=/\%#=1@\*/ matchgroup=razorCommentEnd end=/\%#=1\*@/ containedin=@razorcsExtra

syn match razorIdentifier /\%#=1\K\k*/ contained contains=razorType,razorcsKeywordError nextgroup=razorMemberOperator,razorInvocation,razorIndex
syn match razorMemberOperator /\%#=1?\=\./ contained nextgroup=razorIdentifier
syn region razorInvocation matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorMemberOperator,razorInvocation,razorIndex
syn region razorIndex matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1]/ contained contains=@razorcsRHS nextgroup=razorMemberOperator,razorInvocation,razorIndex
syn keyword razorTypeof typeof contained nextgroup=razorInvocation

syn region razorExplicitExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS

syn region razorBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorTop,@razorcs nextgroup=razorElse,razorWhile,razorCatch,razorFinally skipwhite skipempty

hi def link razorStart PreProc
hi def link razorStartEscape razorStart
hi def link razorRHSStart razorStart
hi def link razorIdentifier razorcsIdentifier
hi def link razorMemberOperator razorcsMemberOperator
hi def link razorDelimiter Delimiter
hi def link razorComment Comment
hi def link razorCommentStart razorComment
hi def link razorCommentEnd razorCommentStart
hi def link razorHTMLLineStart razorStart
hi def link razorTypeof Keyword

syn cluster razorDirectives contains=
    \ razorIf,razorFor,razorForeach,razorAwait,razorWhile,razorSwitch,razorDo,razorUsing,razorTry,razorLock,razorAttribute,
    \ razorCode,razorFunctions,razorImplements,razorInherits,razorModel,razorInject,razorNamespace,razorPage,razorLayout,
    \ razorPreservewhitespace,razorSection,razorTypeparam,razorAddTagHelper,razorRemoveTagHelper,razorTagHelperPrefix,
    \ razorRendermode

syn keyword razorIf if contained nextgroup=razorCondition skipwhite skipempty
syn region razorCondition matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorBlock,razorSemicolon skipwhite skipempty
syn match razorSemicolon /\%#=1;/ contained

syn keyword razorElse else contained nextgroup=razorIf,razorBlock skipwhite skipempty

syn keyword razorFor for contained nextgroup=razorIteratorExpression skipwhite skipempty
syn keyword razorForeach foreach contained nextgroup=razorIteratorExpression skipwhite skipempty
syn region razorIteratorExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs nextgroup=razorBlock skipwhite skipempty

syn keyword razorAwait await contained nextgroup=razorIdentifier skipwhite skipempty

syn keyword razorSwitch switch contained nextgroup=razorCondition skipwhite skipempty

syn keyword razorWhile while contained nextgroup=razorCondition skipwhite skipempty

syn keyword razorDo do contained nextgroup=razorBlock skipwhite skipempty

syn keyword razorUsing using contained nextgroup=razorGuardedStatement,razorUsingIdentifier skipwhite skipempty
syn region razorGuardedStatement matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs nextgroup=razorBlock skipwhite skipempty
syn match razorUsingIdentifier /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorUsingOperator,razorUsingMemberOperator skipwhite
syn match razorUsingMemberOperator /\%#=1\./ contained nextgroup=razorUsingIdentifier
syn match razorUsingOperator /\%#=1=/ contained nextgroup=razorUsingOperator skipwhite skipempty

syn keyword razorTry try contained nextgroup=razorBlock skipwhite skipempty
syn keyword razorCatch catch contained nextgroup=razorGuardedStatement skipwhite skipempty
syn keyword razorFinally finally contained nextgroup=razorBlock skipwhite skipempty

syn keyword razorLock lock contained nextgroup=razorGuardedStatement skipwhite skipempty

syn keyword razorAttribute attribute contained nextgroup=razorcsAttributes skipwhite

syn keyword razorCode code contained nextgroup=razorcsTypeBlock skipwhite skipempty

syn keyword razorFunctions functions contained nextgroup=razorcsTypeBlock skipwhite skipempty

syn keyword razorImplements implements contained nextgroup=razorTypeIdentifier skipwhite
syn match razorTypeIdentifier /\%#=1\K\k*\%(\.\K\k*\)*\%(<.\{-}>\)\=/ contained contains=razorcsGeneric,razorcsKeywordError,razorExtraMemberOperator
syn match razorExtraMemberOperator /\%#=1\./ contained

syn keyword razorInherits inherits contained nextgroup=razorTypeIdentifier skipwhite

syn keyword razorModel model contained nextgroup=razorTypeIdentifier skipwhite

syn keyword razorInject inject contained nextgroup=razorInjectIdentifier skipwhite
syn match razorInjectIdentifier /\%#=1\K\k*\%(\.\K\k*\)*\%(<.\{-}>\)\=/ contained contains=razorcsGeneric,razorcsKeywordError,razorExtraMemberOperator nextgroup=razorInjectDeclarator skipwhite
syn match razorInjectDeclarator /\%#=1\K\k*/ contained contains=razorcsKeywordError

syn keyword razorNamespace namespace contained nextgroup=razorIdentifier skipwhite

syn keyword razorPage page contained nextgroup=razorString skipwhite
syn region razorString matchgroup=razorcsStringStart start=/\%#=1"/ matchgroup=razorcsStringEnd end=/\%#=1"/ oneline contained contains=razorcsEscapeSequence,razorcsEscapeSequenceError

syn keyword razorLayout layout contained nextgroup=razorIdentifier skipwhite

syn keyword razorPreservewhitespace preservewhitespace contained nextgroup=razorBoolean skipwhite
syn keyword razorBoolean true false contained

syn keyword razorSection section contained nextgroup=razorSectionName skipwhite
syn match razorSectionName /\%#=1\K\k*/ contained nextgroup=razorBlock skipwhite skipempty contains=razorcsKeywordError

syn keyword razorTypeparam typeparam contained nextgroup=razorTypeParameter skipwhite
syn match razorTypeParameter /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsTypeConstraint skipwhite

syn keyword razorAddTagHelper addTagHelper contained nextgroup=razorTagPattern,razorTagPatternWildcard skipwhite
syn match razorTagPattern /\%#=1\K\k*/ contained nextgroup=razorTagPatternMemberOperator,razorTagPatternWildcard,razorTagPatternComma
syn match razorTagPatternComma /\%#=1,/ contained nextgroup=razorTagPattern,razorTagPatternWildcard skipwhite
syn match razorTagPatternWildcard /\%#=1\*/ contained nextgroup=razorTagPatternComma
syn match razorTagPatternMemberOperator /\%#=1\./ contained nextgroup=razorTagPattern

syn keyword razorRemoveTagHelper removeTagHelper contained nextgroup=razorTagPattern,razorTagPatternWildcard skipwhite

syn keyword razorTagHelperPrefix tagHelperPrefix contained

syn keyword razorRendermode rendermode contained nextgroup=razorRendermodeMode skipwhite
syn keyword razorRendermodeMode InteractiveServer InteractiveWebAssembly InteractiveAuto contained

" Miscellaneous
syn keyword razorType contained
    \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
    \ char bool object string

" Highlighting
hi def link razorDirective Statement
hi def link razorIf razorDirective
hi def link razorFor razorDirective
hi def link razorForeach razorDirective
hi def link razorAwait razorDirective
hi def link razorWhile razorDirective
hi def link razorElse razorDirective
hi def link razorSwitch razorDirective
hi def link razorDo razorDirective
hi def link razorUsing razorDirective
hi def link razorTry razorDirective
hi def link razorCatch razorDirective
hi def link razorFinally razorDirective
hi def link razorLock razorDirective
hi def link razorAttribute razorDirective
hi def link razorCode razorDirective
hi def link razorFunctions razorDirective
hi def link razorImplements razorDirective
hi def link razorInherits razorDirective
hi def link razorModel razorDirective
hi def link razorInject razorDirective
hi def link razorNamespace razorDirective
hi def link razorPage razorDirective
hi def link razorLayout razorDirective
hi def link razorPreservewhitespace razorDirective
hi def link razorSection razorDirective
hi def link razorTypeparam razorDirective
hi def link razorAddTagHelper razorDirective
hi def link razorRemoveTagHelper razorDirective
hi def link razorTagHelperPrefix razorDirective
hi def link razorRendermode razorDirective
hi def link razorSemicolon razorcsDelimiter
hi def link razorTypeIdentifier razorcsTypeIdentifier
hi def link razorUsingIdentifier razorIdentifier
hi def link razorUsingMemberOperator razorMemberOperator
hi def link razorUsingOperator razorcsAssignmentOperator
hi def link razorInjectIdentifier razorIdentifier
hi def link razorInjectDeclarator razorcsDeclarator
hi def link razorString razorcsString
hi def link razorBoolean razorcsBoolean
hi def link razorSectionName razorcsDeclarator
hi def link razorTypeParameter razorcsDeclarator
hi def link razorTagPattern razorIdentifier
hi def link razorTagPatternMemberOperator razorMemberOperator
hi def link razorTagPatternWildcard SpecialChar
hi def link razorTagPatternComma Delimiter
hi def link razorRendermodeMode Keyword
hi def link razorExtraMemberOperator razorMemberOperator
hi def link razorType razorcsType

let b:current_syntax = "razor"

" vim:fdm=marker

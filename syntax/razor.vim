" Vim syntax file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: github.com/jlcrochet/vim-razor

if exists("b:current_syntax")
  finish
endif

let b:main_syntax = "razor"

let s:include_path = expand("<sfile>:p:h") .. "/../include"

" Syntax {{{1
syn sync fromstart

" NOTE: The syntax files for HTML and C# are kept in a separate
" directory so that they don't get picked up by Vim in other contexts.
execute "source " .. s:include_path .. "/html.vim"

syn match razorHTMLEscape /\%#=1@/ contained nextgroup=razorInnerHTMLTag
execute "syn include @razorcs " .. s:include_path .. "/cs.vim"

syn cluster razorcsRHS add=razorHTMLEscape

syn match razorDelimiter /\%#=1\w\@1<!@/ containedin=razorhtmlValue,razorInnerHTMLBlock,razorHTMLLine nextgroup=razorIdentifier,@razorDirectives,razorBlock,razorBoolean
syn match razorDelimiter /\%#=1@/ contained containedin=razorhtmlTag,razorInnerHTMLTag nextgroup=razorhtmlAttribute,razorExpression,razorBoolean
syn match razorDelimiter /\%#=1@/ contained containedin=razor\a\{-}Block nextgroup=razorIdentifier,@razorDirectives,razorExpression,razorHTMLLine

syn match razorDelimiterEscape /\%#=1@@/ transparent containedin=razorhtmlValue,razorInnerHTMLBlock,razorHTMLLine,razorhtmlTag,razorInnerHTMLTag contains=NONE

syn region razorExplicitExpression matchgroup=razorDelimiter start=/\%#=1@(/ end=/\%#=1)/ containedin=razorhtmlValue,razorInnerHTMLBlock,razorHTMLLine contains=@razorcsRHS

syn region razorExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS
syn region razorBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcs,razorInnerHTMLTag fold

syn match razorIdentifier /\%#=1\h\w*/ contained nextgroup=razorMemberAccessOperator,razorInvocation,razorSubscript
syn match razorMemberAccessOperator /\%#=1\./ contained nextgroup=razorIdentifier
syn region razorInvocation matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorMemberAccessOperator,razorInvocation,razorSubscript
syn region razorSubscript matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=@razorcsRHS nextgroup=razorMemberAccessOperator,razorInvocation,razorSubscript

syn region razorInnerHTMLTag matchgroup=razorhtmlTag start=/\%#=1<!\=[[:alnum:]_:][[:alnum:]_:\-.]*/ end=/\%#=1>\@=/ contained containedin=razorcsBlock contains=razorhtmlAttribute nextgroup=razorInnerHTMLBlock,razorInnerHTMLEndBracket
syn region razorInnerHTMLBlock matchgroup=razorhtmlTag start=/\%#=1>/ matchgroup=razorhtmlEndTag end=/\%#=1<\/!\=[[:alnum:]_:][[:alnum:]_:\-.]*>/ contained contains=razorInnerHTMLTag,razorhtmlCharacterReference
syn match razorInnerHTMLEndBracket /\%#=1\/\@1<=>/ contained

syn region razorInnerHTMLTag matchgroup=razorhtmlTag start=/\%#=1<!\=\%(area\|base\|br\|col\|command\|embed\|hr\|img\|input\|keygen\|link\|meta\|param\|source\|track\|wbr\)[[:space:]>]\@=/ end=/\%#=1>/ contained containedin=razorcsBlock contains=razorhtmlAttribute

syn region razorInnerHTMLTag matchgroup=razorhtmlTag start=/\%#=1<!\=script[[:space:]>]\@=/ end=/\%#=1>/ contained containedin=razorcsBlock contains=razorhtmlAttribute nextgroup=razorhtmlScript,razorhtmlEndTag skipnl

syn region razorInnerHTMLTag matchgroup=razorhtmlTag start=/\%#=1<!\=style[[:space:]>]\@=/ end=/\%#=1>/ contained containedin=razorcsBlock contains=razorhtmlAttribute nextgroup=razorhtmlStyle,razorhtmlEndTag skipnl

syn region razorHTMLLine matchgroup=razorDelimiter start=/\%#=1:/ end=/\%#=1$/ keepend contained contains=razorInnerHTMLTag,razorhtmlCharacterReference

syn region razorComment matchgroup=razorCommentStart start=/\%#=1@\*/ matchgroup=razorCommentEnd end=/\%#=1\*@/ contains=razorcsTodo containedin=razor\a\{-}Block

" Directives {{{2
syn cluster razorDirectives contains=
      \ razorAwait,razorIf,razorSwitch,razorFor,razorForeach,razorWhile,razorDo,razorUsing,razorTry,razorLock,razorTypeparam,
      \ razorAttribute,razorCode,razorFunctions,razorImplements,razorInherits,razorModel,razorInject,razorPage,razorLayout,
      \ razorNamespace,razorPreservewhitespace,razorSection,razorAddTagHelper,razorRemoveTagHelper,razorTagHelperPrefix

syn keyword razorAwait await contained nextgroup=razorIdentifier skipwhite skipempty

syn keyword razorIf if contained nextgroup=razorIfCondition skipwhite skipempty
syn region razorIfCondition matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorIfBlock skipwhite skipempty
syn region razorIfBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcs,razorInnerHTMLTag nextgroup=razorElse skipwhite skipempty fold

syn keyword razorElse else contained nextgroup=razorIf,razorBlock skipwhite skipempty

syn keyword razorSwitch switch contained nextgroup=razorSwitchCondition skipwhite skipempty
syn region razorSwitchCondition matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorSwitchBlock skipwhite skipempty
syn region razorSwitchBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorCase,razorDefault,razorCaseColon,@razorcs,razorInnerHTMLTag fold
syn keyword razorCase case contained nextgroup=razorcsCasePatterns
syn keyword razorDefault default contained
syn match razorCaseColon /\%#=1:/ contained

syn keyword razorWhile while contained nextgroup=razorWhileCondition skipwhite skipempty
syn region razorWhileCondition matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorWhileBlock skipwhite skipempty
syn region razorWhileBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorCS,razorInnerHTMLTag fold

syn keyword razorDo do contained nextgroup=razorDoBlock skipwhite skipempty
syn region razorDoBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcs,razorInnerHTMLTag nextgroup=razorWhile skipwhite skipempty fold

syn keyword razorFor for contained nextgroup=razorForExpressions skipwhite skipempty
syn region razorForExpressions matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs,razorForExpression nextgroup=razorBlock skipwhite skipempty
syn region razorForExpression start=/\%#=1;/ end=/\%#=1[;)]\@=/ contained contains=@razorcsRHS

syn keyword razorForeach foreach contained nextgroup=razorForeachExpression skipwhite skipempty
syn region razorForeachExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs nextgroup=razorBlock skipwhite skipempty

syn keyword razorUsing using contained nextgroup=razorUsingStatement,razorUsingIdentifier skipwhite skipempty
syn region razorUsingStatement matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs nextgroup=razorBlock skipwhite skipempty
syn match razorUsingIdentifier /\%#=1\h\w*\%(\.\h\w*\)*/ contained contains=razorIdentifierDot nextgroup=razorUsingAliasOperator skipwhite
syn match razorUsingAliasOperator /\%#=1=/ contained nextgroup=razorNamespaceIdentifier skipwhite

syn keyword razorTry try contained nextgroup=razorTryBlock skipwhite skipempty
syn region razorTryBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcs,razorInnerHTMLTag nextgroup=razorCatch,razorFinally skipwhite skipempty fold

syn keyword razorCatch catch contained nextgroup=razorCatchCondition skipwhite skipempty
syn region razorCatchCondition matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsTypeIdentifier nextgroup=razorTryBlock skipwhite skipempty

syn keyword razorFinally finally contained nextgroup=razorBlock skipwhite skipempty

syn keyword razorLock lock contained nextgroup=razorLockExpression skipwhite skipempty
syn region razorLockExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorBlock skipwhite skipempty

syn keyword razorTypeparam typeparam contained nextgroup=razorTypeparamDeclarator skipwhite
syn match razorTypeparamDeclarator /\%#=1\h\w*/ contained nextgroup=razorWhere skipwhite
syn keyword razorWhere where contained nextgroup=razorTypeparamConstraintIdentifier skipwhite
syn match razorTypeparamConstraintIdentifier /\%#=1\h\w*/ contained nextgroup=razorTypeparamConstraintOperator skipwhite
syn match razorTypeparamConstraintOperator /\%#=1:/ contained nextgroup=razorTypeparamConstraintArgument skipwhite
syn match razorTypeparamConstraintArgument /\%#=1\h\w*/ contained

syn keyword razorAttribute attribute contained nextgroup=razorcsAttributes skipwhite

syn keyword razorCode code contained nextgroup=razorCodeBlock skipwhite skipempty
syn region razorCodeBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcs fold

syn keyword razorFunctions functions contained nextgroup=razorCodeBlock skipwhite skipempty

syn keyword razorImplements implements contained nextgroup=razorNamespaceIdentifier skipwhite

syn keyword razorInherits inherits contained nextgroup=razorGenericIdentifier skipwhite
syn match razorGenericIdentifier /\%#=1\h\w*\%(\.\h\w*\)*\%(<.\{-}>\)\=/ contained contains=razorIdentifierDot,razorGeneric
syn match razorIdentifierDot /\%#=1\./ contained
syn region razorGeneric matchgroup=razorcsDelimiter start=/\%#=1</ end=/\%#=1>/ contained contains=razorcsType,razorcsTypeIdentifier,razorcsModifier

syn keyword razorModel model contained nextgroup=razorGenericIdentifier skipwhite

syn keyword razorInject inject contained nextgroup=razorServiceIdentifier skipwhite
syn match razorServiceIdentifier /\%#=1\h\w*\%(\.\h\w*\)*/ contained contains=razorIdentifierDot nextgroup=razorServiceAlias skipwhite
syn match razorServiceAlias /\%#=1\h\w*/ contained

syn keyword razorPage page contained nextgroup=razorString skipwhite
syn region razorString matchgroup=razorcsStringStart start=/\%#=1"/ matchgroup=razorcsStringEnd end=/\%#=1"/ oneline contained

syn keyword razorLayout layout contained nextgroup=razorNamespaceIdentifier skipwhite

syn keyword razorNamespace namespace contained nextgroup=razorNamespaceIdentifier skipwhite
syn match razorNamespaceIdentifier /\%#=1\h\w*\%(\.\h\w*\)*/ contained contains=razorIdentifierDot

syn keyword razorPreservewhitespace preservewhitespace contained nextgroup=razorBoolean skipwhite
syn keyword razorBoolean true false contained

syn keyword razorSection section contained nextgroup=razorSectionDeclarator skipwhite skipempty
syn match razorSectionDeclarator /\%#=1\h\w*/ contained nextgroup=razorHTMLBlock skipwhite skipempty
syn region razorHTMLBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=TOP fold

syn keyword razorAddTagHelper addTagHelper contained nextgroup=razorTagHelperPattern skipwhite
syn match razorTagHelperPattern /\%#=1\h\w*\%(\.\h\w*\)*\*\=/ contained contains=razorIdentifierDot nextgroup=razorTagHelperComma skipwhite
syn match razorTagHelperPattern /\%#=1\*/ contained nextgroup=razorTagHelperComma skipwhite
syn match razorTagHelperComma /\%#=1,/ contained nextgroup=razorNamespaceIdentifier skipwhite

syn keyword razorRemoveTagHelper removeTagHelper contained nextgroup=razorAssemblyIdentifier skipwhite

syn keyword razorTagHelperPrefix tagHelperPrefix contained nextgroup=razorTagHelperPrefixPattern skipwhite
syn match razorTagHelperPrefixPattern /\%#=1[[:alnum:]_:][[:alnum:]_:\-.]*/ contained
" }}}2

" Highlighting {{{1
hi def link razorDelimiter PreProc
hi def link razorIdentifier razorcsIdentifier
hi def link razorGenericIdentifier razorIdentifier
hi def link razorServiceIdentifier razorIdentifier
hi def link razorServiceAlias razorServiceIdentifier
hi def link razorNamespaceIdentifier razorIdentifier
hi def link razorUsingIdentifier razorIdentifier
hi def link razorUsingAliasOperator Operator
hi def link razorIdentifierDot razorMemberAccessOperator
hi def link razorTypeparamDeclarator razorIdentifier
hi def link razorTypeparamConstraintIdentifier razorTypeparamDeclarator
hi def link razorTypeparamConstraintArgument razorTypeparamConstraintIdentifier
hi def link razorTypeparamConstraintOperator Operator
hi def link razorTagHelperPattern razorIdentifier
hi def link razorMemberAccessOperator razorcsMemberAccessOperator
hi def link razorInnerHTMLTag razorhtmlTag
hi def link razorInnerHTMLEndBracket razorhtmlTag
hi def link razorComment Comment
hi def link razorCommentStart razorComment
hi def link razorCommentEnd razorCommentStart
hi def link razorString razorcsString
hi def link razorBoolean razorcsBoolean
hi def link razorSectionDeclarator razorcsDeclarator
hi def link razorHTMLEscape razorDelimiter
hi def link razorTagHelperPrefixPattern String
hi def link razorCaseColon razorDelimiter

hi def link razorDirective PreProc
hi def link razorAwait razorDirective
hi def link razorIf razorDirective
hi def link razorElse razorDirective
hi def link razorSwitch razorDirective
hi def link razorCase razorDirective
hi def link razorDefault razorDirective
hi def link razorFor razorDirective
hi def link razorForeach razorDirective
hi def link razorWhile razorDirective
hi def link razorDo razorDirective
hi def link razorUsing razorDirective
hi def link razorTry razorDirective
hi def link razorCatch razorDirective
hi def link razorFinally razorDirective
hi def link razorLock razorDirective
hi def link razorTypeparam razorDirective
hi def link razorWhere razorDirective
hi def link razorAttribute razorDirective
hi def link razorCode razorDirective
hi def link razorFunctions razorDirective
hi def link razorImplements razorDirective
hi def link razorInherits razorDirective
hi def link razorModel razorDirective
hi def link razorInject razorDirective
hi def link razorPage razorDirective
hi def link razorLayout razorDirective
hi def link razorNamespace razorDirective
hi def link razorPreservewhitespace razorDirective
hi def link razorSection razorDirective
hi def link razorAddTagHelper razorDirective
hi def link razorRemoveTagHelper razorDirective
hi def link razorTagHelperPrefix razorDirective
" }}}

unlet s:include_path

let b:current_syntax = "razor"

" vim:fdm=marker

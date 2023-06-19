" Vim syntax file
" Language: Razor (docs.microsoft.com/en-us/aspnet/core/mvc/views/razor)
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: github.com/jlcrochet/vim-razor

if exists("b:current_syntax")
  finish
endif

" Syntax {{{1
syn sync fromstart

" NOTE: The syntax files for HTML and C# are kept in a separate
" directory so that they don't get picked up by Vim in other contexts.
runtime include/html.vim

syn match razorHTMLEscape /\%#=1@/ contained nextgroup=razorInnerHTMLTag

syn include @razorcs include/cs.vim

syn cluster razorcsRHS add=razorHTMLEscape

syn match razorDelimiter /\%#=1\w\@1<!@/ containedin=razorhtmlValue,razorInnerHTMLBlock,razorHTMLLine,javascript\a*,css\a* nextgroup=razorIdentifier,razorDirective,razorBlock,razorBoolean
syn match razorDelimiter /\%#=1@/ contained containedin=razorhtmlTag,razorInnerHTMLTag nextgroup=razorhtmlAttribute,razorExpression,razorBoolean
syn match razorDelimiter /\%#=1@/ contained containedin=razorBlock nextgroup=razorIdentifier,razorDirective,razorExpression,razorHTMLLine

syn match razorDelimiterEscape /\%#=1@@/ containedin=razorhtmlValue,razorInnerHTMLBlock,razorHTMLLine,razorhtmlTag,razorInnerHTMLTag,javascript\a*,css\a*

syn region razorExplicitExpression matchgroup=razorDelimiter start=/\%#=1@(/ end=/\%#=1)/ containedin=razorhtmlValue,razorInnerHTMLBlock,razorHTMLLine contains=@razorcsRHS

syn region razorExpression matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS
syn region razorBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcs,razorInnerHTMLTag nextgroup=razorPostfixDirective skipwhite skipempty fold

syn match razorIdentifier /\%#=1\K\k*/ contained nextgroup=razorMemberAccessOperator,razorInvocation,razorIndex,razorNullForgivingOperator
syn match razorMemberAccessOperator /\%#=1?\=\./ contained nextgroup=razorIdentifier
syn region razorInvocation matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorMemberAccessOperator,razorInvocation,razorIndex,razorNullForgivingOperator
syn region razorIndex matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=@razorcsRHS nextgroup=razorMemberAccessOperator,razorInvocation,razorIndex,razorNullForgivingOperator
syn match razorNullForgivingOperator /\%#=1!/ contained nextgroup=razorMemberAccessOperator,razorInvocation,razorIndex

syn region razorInnerHTMLTag matchgroup=razorhtmlTag start=/\%#=1<!\=[[:alnum:]_:][[:alnum:]_:\-.]*/ end=/\%#=1>\@=/ contained containedin=razorcsBlock contains=razorhtmlAttribute nextgroup=razorInnerHTMLBlock,razorInnerHTMLEndBracket
syn region razorInnerHTMLBlock matchgroup=razorhtmlTag start=/\%#=1>/ matchgroup=razorhtmlEndTag end=/\%#=1<\/!\=[[:alnum:]_:][[:alnum:]_:\-.]*>/ contained contains=razorInnerHTMLTag,razorhtmlCharacterReference
syn match razorInnerHTMLEndBracket /\%#=1\/\@1<=>/ contained

syn region razorInnerHTMLTag matchgroup=razorhtmlTag start=/\%#=1<!\=\%(area\|base\|br\|col\|command\|embed\|hr\|img\|input\|keygen\|link\|meta\|param\|source\|track\|wbr\)[[:space:]>]\@=/ end=/\%#=1>/ contained containedin=razorcsBlock contains=razorhtmlAttribute

syn region razorInnerHTMLTag matchgroup=razorhtmlTag start=/\%#=1<!\=script[[:space:]>]\@=/ end=/\%#=1>/ contained containedin=razorcsBlock contains=razorhtmlAttribute nextgroup=razorhtmlScript,razorhtmlEndTag skipnl

syn region razorInnerHTMLTag matchgroup=razorhtmlTag start=/\%#=1<!\=style[[:space:]>]\@=/ end=/\%#=1>/ contained containedin=razorcsBlock contains=razorhtmlAttribute nextgroup=razorhtmlStyle,razorhtmlEndTag skipnl

syn region razorHTMLLine matchgroup=razorDelimiter start=/\%#=1:/ end=/\%#=1$/ keepend contained contains=razorInnerHTMLTag,razorhtmlCharacterReference

syn region razorComment matchgroup=razorCommentStart start=/\%#=1@\*/ matchgroup=razorCommentEnd end=/\%#=1\*@/ contains=razorcsTodo containedin=razorBlock,razorInnerHTMLBlock,@razorcsBlocks

" Directives {{{2
syn keyword razorDirective await contained nextgroup=razorIdentifier skipwhite skipempty

syn keyword razorDirective if while switch lock contained nextgroup=razorCondition skipwhite skipempty
syn region razorCondition matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorBlock,razorSemicolon skipwhite skipempty
syn match razorSemicolon /\%#=1;/ contained

syn keyword razorDirective for foreach contained nextgroup=razorStatements skipwhite skipempty
syn region razorStatements matchgroup=razorDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs nextgroup=razorBlock skipwhite skipempty

syn keyword razorDirective do try code functions contained nextgroup=razorBlock skipwhite skipempty

syn keyword razorPostfixDirective else contained nextgroup=razorDirective,razorBlock skipwhite skipempty
syn keyword razorPostfixDirective finally contained nextgroup=razorBlock skipwhite skipempty
syn keyword razorPostfixDirective while contained nextgroup=razorCondition skipwhite skipempty
syn keyword razorPostfixDirective catch contained nextgroup=razorStatements skipwhite skipempty

syn keyword razorDirective using contained nextgroup=razorStatements,razorTypeIdentifier skipwhite skipempty
syn match razorTypeIdentifier /\%#=1\K\k*\%(<.\{-}>\)\=/ contained contains=razorcsGeneric nextgroup=razorTypeAliasOperator,razorTypeMemberAccessOperator,razorTypeDeclarator skipwhite
syn match razorTypeMemberAccessOperator /\%#=1\./ contained nextgroup=razorTypeIdentifier skipwhite skipempty
syn match razorTypeAliasOperator /\%#=1=/ contained nextgroup=razorTypeIdentifier skipwhite skipempty
syn match razorTypeDeclarator /\%#=1\K\k*/ contained

syn keyword razorDirective typeparam contained nextgroup=razorTypeparamDeclarator skipwhite
syn match razorTypeparamDeclarator /\%#=1\K\k*/ contained nextgroup=razorWhere skipwhite
syn keyword razorWhere where contained nextgroup=razorTypeparamConstraintIdentifier skipwhite
syn match razorTypeparamConstraintIdentifier /\%#=1\K\k*/ contained nextgroup=razorTypeparamConstraintOperator skipwhite
syn match razorTypeparamConstraintOperator /\%#=1:/ contained nextgroup=razorTypeparamConstraintArgument skipwhite
syn match razorTypeparamConstraintArgument /\%#=1\K\k*/ contained

syn keyword razorDirective attribute contained nextgroup=razorcsAttributes skipwhite

syn keyword razorDirective implements inherits model inject layout namespace contained nextgroup=razorTypeIdentifier skipwhite

syn keyword razorDirective page contained nextgroup=razorString skipwhite
syn region razorString matchgroup=razorcsStringStart start=/\%#=1"/ matchgroup=razorcsStringEnd end=/\%#=1"/ oneline contained

syn keyword razorDirective preservewhitespace contained nextgroup=razorBoolean skipwhite
syn keyword razorBoolean true false contained

syn keyword razorDirective section contained nextgroup=razorSectionDeclarator skipwhite skipempty
syn match razorSectionDeclarator /\%#=1\K\k*/ contained nextgroup=razorHTMLBlock skipwhite skipempty
syn region razorHTMLBlock matchgroup=razorDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=TOP fold

syn keyword razorDirective addTagHelper contained nextgroup=razorTagHelperPattern skipwhite
syn match razorTagHelperPattern /\%#=1\K\k*\%(\.\K\k*\)*\*\=/ contained nextgroup=razorTagHelperComma skipwhite
syn match razorTagHelperPattern /\%#=1\*/ contained nextgroup=razorTagHelperComma skipwhite
syn match razorTagHelperComma /\%#=1,/ contained nextgroup=razorTagHelperPattern skipwhite

syn keyword razorDirective removeTagHelper contained

syn keyword razorDirective tagHelperPrefix contained nextgroup=razorTagHelperPrefixPattern skipwhite
syn match razorTagHelperPrefixPattern /\%#=1[[:alnum:]_:][[:alnum:]_:\-.]*/ contained
" }}}2

" Highlighting {{{1
hi def link razorDelimiter PreProc
hi def link razorDelimiterEscape SpecialChar
hi def link razorIdentifier razorcsIdentifier
hi def link razorTypeparamDeclarator razorcsDeclarator
hi def link razorTypeparamConstraintIdentifier razorTypeIdentifier
hi def link razorTypeparamConstraintArgument razorTypeparamConstraintIdentifier
hi def link razorTypeparamConstraintOperator Operator
hi def link razorTagHelperPattern razorIdentifier
hi def link razorMemberAccessOperator razorcsMemberAccessOperator
hi def link razorNullForgivingOperator Operator
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
hi def link razorDirective Statement
hi def link razorPostfixDirective razorDirective
hi def link razorWhere razorPostfixDirective
hi def link razorBoolean Boolean
hi def link razorTypeIdentifier razorcsTypeIdentifier
hi def link razorTypeDeclarator razorcsDeclarator
hi def link razorTypeAliasOperator Operator
hi def link razorTypeMemberAccessOperator razorMemberAccessOperator
hi def link razorSemicolon Delimiter
" }}}

let b:current_syntax = "razor"

" vim:fdm=marker

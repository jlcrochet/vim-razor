" Syntax {{{1
" RHS {{{2
syn cluster razorcsRHS contains=
      \ razorcsRHSIdentifier,razorcsNumber,razorcsString,razorcsCharacter,
      \ razorcsBoolean,razorcsNull,razorcsConstant,
      \ razorcsGroup,razorcsList,razorcsQueryExpression,
      \ razorcsUnaryOperator,razorcsUnaryOperatorKeyword,razorcsSpecialMethod,
      \ razorcsLambdaDeclarator,razorcsLambdaParameters

" Operators {{{3
syn cluster razorcsOperators contains=
      \ razorcsOperator,razorcsOperatorKeyword,razorcsRHSMemberAccessOperator,
      \ razorcsInvocation,razorcsIndex

syn match razorcsOperator /\%#=1[+\-*/%^]=\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1&&\==\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1||\==\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1?\%(?=\=\)\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1:/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1<\%(=\|<=\=\)\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1>\%(=\|>=\=\)\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1!=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1==\=/ contained nextgroup=@razorcsRHS skipwhite skipnl

syn match razorcsOperator /\%#=1++/ contained nextgroup=@razorcsOperators skipwhite
syn match razorcsOperator /\%#=1--/ contained nextgroup=@razorcsOperators skipwhite

syn match razorcsRHSMemberAccessOperator /\%#=1?\=\./ contained nextgroup=razorcsRHSIdentifier
syn match razorcsRHSMemberAccessOperator /\%#=1->/ contained nextgroup=razorcsRHSVariable
syn match razorcsRHSMemberAccessOperator /\%#=1::/ contained nextgroup=razorcsRHSIdentifier

syn match razorcsOperator /\%#=1\.\./ contained nextgroup=@razorcsRHS skipwhite skipnl

syn keyword razorcsOperatorKeyword as is contained nextgroup=razorcsRHSType,razorcsRHSIdentifier,razorcsNull skipwhite skipnl
syn keyword razorcsOperatorKeyword switch contained nextgroup=razorcsList skipwhite
syn keyword razorcsOperatorKeyword with contained nextgroup=razorcsObject skipwhite

syn match razorcsUnaryOperator /\%#=1[!^~&*]/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsUnaryOperator /\%#=1++\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsUnaryOperator /\%#=1--\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsUnaryOperator /\%#=1\.\./ contained nextgroup=@razorcsRHS skipwhite skipnl

syn keyword razorcsUnaryOperatorKeyword out await stackalloc contained nextgroup=razorcsRHSIdentifier,razorcsRHSType,razorcsTypeTuple skipwhite
syn keyword razorcsUnaryOperatorKeyword new contained nextgroup=razorcsRHSIdentifier,razorcsRHSType,razorcsGroup,razorcsIndex,razorcsObject skipwhite
syn keyword razorcsUnaryOperatorKeyword async contained nextgroup=razorcsLambdaDeclarator,razorcsLambdaParameters skipwhite

syn region razorcsObject matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorcsVariable

syn region razorcsInvocation matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=@razorcsOperators,razorcsList skipwhite skipnl
syn region razorcsIndex matchgroup=razorcsDelimiter start=/\%#=1?\=\[/ end=/\%#=1]/ contained contains=@razorcsRHS nextgroup=@razorcsOperators,razorcsList skipwhite skipnl
" }}}3

syn match razorcsRHSVariable /\%#=1\h\w*/ contained nextgroup=@razorcsOperators skipwhite skipnl

syn match razorcsRHSIdentifier /\%#=1\h\w*\%(<.\{-}>\)\=/ contained contains=razorcsGeneric,razorcsType,razorcsModifier,razorcsStatement,razorcsType,razorcsConstant nextgroup=@razorcsOperators,razorcsList,razorcsVariable skipwhite skipnl

syn keyword razorcsRHSType contained nextgroup=razorcsIndex,razorcsRHSMemberAccessOperator,razorcsVariable skipwhite skipnl
      \ bool byte char decimal double dynamic float int long object
      \ sbyte short string uint ulong ushort void

syn region razorcsGroup matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS,razorcsRHSType nextgroup=@razorcsRHS,@razorcsOperators,razorcsLambdaOperator skipwhite skipnl
syn region razorcsList matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcsRHS nextgroup=@razorcsOperators skipwhite skipnl

syn match razorcsLambdaDeclarator /\%#=1\h\w*\s*=>/ contained contains=razorcsLambdaOperator nextgroup=@razorcsRHS,razorcsBlock skipwhite skipnl
syn region razorcsLambdaParameters matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)\s*\ze=>/ contained oneline contains=razorcsLambdaParameter nextgroup=razorcsLambdaOperator
syn match razorcsLambdaParameter /\%#=1\h\w*/ contained
syn match razorcsLambdaParameter /\%#=1\h\w*\%(<.\{-}>\)\=\s\+\h\w*/ contained contains=razorcsRHSType,razorcsRHSIdentifier

" Numbers {{{3
execute g:razor#syntax#cs_numbers
" }}}3

syn match razorcsCharacter /\%#=1'\%(\\\%(x\x\{1,4}\|u\x\{4}\|U\x\{8}\|.\)\|.\)'/ contained contains=razorcsEscapeSequence,razorcsEscapeSequenceError nextgroup=razorcsOperator skipwhite skipnl

syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1"/   end=/\%#=1"/ contained oneline contains=razorcsEscapeSequence,razorcsEscapeSequenceError nextgroup=razorcsOperator skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1$"/  end=/\%#=1"/ contained oneline contains=razorcsEscapeSequence,razorcsEscapeSequenceError,razorcsStringInterpolation,razorcsStringNoInterpolation nextgroup=razorcsOperator skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1@"/  end=/\%#=1"/ skip=/\%#=1""/ contained contains=razorcsQuoteEscape,nextgroup=razorcsOperator skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1$@"/ end=/\%#=1"/ skip=/\%#=1""/ contained contains=razorcsQuoteEscape,razorcsStringInterpolation,razorcsStringNoInterpolation nextgroup=razorcsOperator skipwhite skipnl

syn region razorcsStringInterpolation matchgroup=razorcsStringInterpolationDelimiter start=/\%#=1{/ end=/\%#=1}/ oneline contained contains=@razorcsRHS
syn match razorcsStringNoInterpolation /\%#=1{{/ contained

syn match razorcsEscapeSequenceError /\%#=1\\./ contained
syn match razorcsEscapeSequence /\%#=1\\\%(['"\\0abfnrtv]\|x\x\{1,4}\|u\x\{4}\|U\x\{8}\)/ contained

syn match razorcsQuoteEscape /\%#=1""/ contained

syn keyword razorcsBoolean true false contained nextgroup=razorcsOperator skipwhite skipnl
syn keyword razorcsNull null contained nextgroup=razorcsOperator skipwhite skipnl

syn keyword razorcsConstant base this nextgroup=@razorcsOperators skipwhite skipnl

syn region razorcsQueryExpression start=/\%#=1\<from\>/ end=/\%#=1[,;]\@=/ contained contains=razorcsQueryKeyword,razorcsComment
syn keyword razorcsQueryKeyword from into let join contained nextgroup=razorcsQueryVariable skipwhite
syn keyword razorcsQueryKeyword contained
      \ in orderby ascending descending group equals
syn keyword razorcsQueryKeyword select by where contained nextgroup=@razorcsRHS skipwhite
syn keyword razorcsQueryKeyword on contained
syn match razorcsQueryVariable /\%#=1\h\w*/ contained contains=razorcsModifier,razorcsStatement,razorcsQueryKeyword,razorcsType nextgroup=razorcsAssignmentOperator skipwhite skipnl

" LHS {{{2
syn region razorcsComment start=/\%#=1\/\*/ end=/\%#=1\*\// contains=razorcsTodo containedin=ALLBUT,razorcsComment,razorcsString nextgroup=@razorcsRHS skipwhite
syn region razorcsComment start=/\%#=1\/\/\*/ end=/\%#=1\*\// contains=razorcsTodo,@razorcsxml containedin=ALLBUT,razorcsComment,razorcsString nextgroup=@razorcsRHS skipwhite
syn match razorcsComment /\%#=1\/\/.*/ contains=razorcsTodo containedin=ALLBUT,razorcsComment,razorcsString
syn match razorcsComment /\%#=1\/\/\/.*/ contains=razorcsTodo,@razorcsxml containedin=ALLBUT,razorcsComment,razorcsString

syn keyword razorcsTodo TODO NOTE XXX FIXME HACK TBD contained
syn include @razorcsxml syntax/xml.vim

syn match razorcsPreprocessor /\%#=1^\s*#.*/

syn match razorcsIncrementOperator /\%#=1++/
syn match razorcsDecrementOperator /\%#=1--/
syn match razorcsPointerIndirectionOperator /\%#=1\*/

syn keyword razorcsStatement nextgroup=razorcsTypeDefinition skipwhite
      \ class interface namespace struct record
syn match razorcsTypeDefinition /\%#=1\h\w*\%(\.\h\w*\)*\%(<.\{-}>\)\=/ contained contains=razorcsGenericDefinition nextgroup=razorcsInheritanceOperator skipwhite
syn match razorcsInheritanceOperator /\%#=1:/ contained nextgroup=razorcsInheritedType skipwhite
syn match razorcsInheritedType /\%#=1\h\w*\%(\.\h\w*\)*\%(<.\{-}>\)\=/ contained contains=razorcsGenericDefinition nextgroup=razorcsTypeComma skipwhite
syn match razorcsInheritedType /\%#=1\<new()/ contained nextgroup=razorcsTypeComma skipwhite
syn keyword razorcsInheritedType class struct notnull unmanaged contained nextgroup=razorcsTypeComma skipwhite
syn match razorcsTypeComma /\%#=1,/ contained nextgroup=razorcsInheritedType skipwhite
syn region razorcsGenericDefinition matchgroup=razorcsDelimiter start=/\%#=1</ end=/\%#=1>/ contained oneline contains=razorcsType,razorcsTypeVariable,razorcsGenericModifier
syn match razorcsTypeVariable /\%#=1\h\w*/ contained

syn keyword razorcsStatement enum nextgroup=razorcsEnumDefinition skipwhite
syn match razorcsEnumDefinition /\%#=1\h\w*\%(\.\h\w*\)*/ contained nextgroup=razorcsEnumList skipwhite
syn region razorcsEnumList matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorcsVariable

syn keyword razorcsStatement var nextgroup=razorcsVariable,razorcsVariableTuple skipwhite
syn match razorcsVariable /\%#=1\h\w*/ contained contains=razorcsModifier,razorcsStatement,razorcsType nextgroup=razorcsAssignmentOperator skipwhite
syn region razorcsVariableTuple matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsVariable,razorcsVariableTuple nextgroup=razorcsAssignmentOperator skipwhite
syn match razorcsVariableComma /\%#=1,/ nextgroup=razorcsVariable,razorcsVariableTuple skipwhite skipnl

syn keyword razorcsSpecialMethod checked unchecked typeof nameof default nextgroup=razorcsInvocation skipwhite

syn keyword razorcsModifier
      \ abstract async const delegate event explicit extern
      \ implicit in out override params partial readonly ref sealed
      \ static unsafe virtual volatile yield new

syn keyword razorcsStatement await nextgroup=razorcsRHSIdentifier skipwhite

syn keyword razorcsStatement get set init nextgroup=razorcsLambdaOperator,razorcsBlock skipwhite skipnl

syn keyword razorcsStatement using fixed unfixed nextgroup=razorcsGuardedStatement skipwhite
syn region razorcsGuardedStatement matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained transparent

syn keyword razorcsStatement alias

syn keyword razorcsStatement if switch while nextgroup=razorcsCondition skipwhite
syn keyword razorcsStatement else
syn region razorcsCondition matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS

syn keyword razorcsStatement for nextgroup=razorcsForStatement skipwhite
syn region razorcsForStatement matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsTop,razorcsForCondition,razorcsVariableComma
syn region razorcsForCondition matchgroup=razorcsDelimiter start=/\%#=1;\zs/ end=/\%#=1\ze;/ contained oneline contains=@razorcsRHS

syn keyword razorcsStatement foreach nextgroup=razorcsForeachStatement skipwhite
syn region razorcsForeachStatement matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs,razorcsInStatement
syn keyword razorcsInStatement in contained nextgroup=razorcsRHSIdentifier,razorcsUnaryOperatorKeyword skipwhite

syn keyword razorcsStatement break continue default

syn keyword razorcsStatement case nextgroup=razorcsCaseExpression
syn region razorcsCaseExpression start=/\%#=1/ end=/\%#=1:\@=/ contained contains=@razorcsRHS,razorcsCaseWhenStatement
syn keyword razorcsCaseWhenStatement when contained nextgroup=razorcsCaseWhenExpression
syn match razorcsCaseWhenExpression /\%#=1\_.\{-}:\@=/ contained contains=@razorcsRHS

syn keyword razorcsStatement try finally
syn keyword razorcsStatement catch nextgroup=razorcsCatchStatement skipwhite
syn region razorcsCatchStatement matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsLHSIdentifier nextgroup=razorcsCatchWhenStatement skipwhite
syn keyword razorcsCatchWhenStatement when contained nextgroup=razorcsCondition skipwhite

syn keyword razorcsStatement return throw nextgroup=@razorcsRHS skipwhite skipnl

syn keyword razorcsStatement do

syn keyword razorcsStatement goto nextgroup=razorcsLHSIdentifier skipwhite

syn keyword razorcsStatement lock nextgroup=razorcsCondition skipwhite

syn keyword razorcsType nextgroup=razorcsDeclarator,razorcsConstant,@razorcsTypeModifiers skipwhite
      \ bool byte char decimal double dynamic float int long object
      \ sbyte short string uint ulong ushort void

syn keyword razorcsStatement operator nextgroup=razorcsDeclarator skipwhite

syn match razorcsLHSIdentifier /\%#=1\h\w*\%(<.\{-}>\)\=/ contains=razorcsGeneric,razorcsModifier,razorcsStatement,razorcsType nextgroup=razorcsDeclarator,razorcsConstant,razorcsAssignmentOperator,razorcsCompoundAssignmentOperator,razorcsInvocation,razorcsLHSMemberAccessOperator,@razorcsTypeModifiers skipwhite skipnl
syn region razorcsGeneric matchgroup=razorcsDelimiter start=/\%#=1</ end=/\%#=1>/ contained oneline contains=razorcsLHSIdentifier,razorcsType,razorcsTypeTuple,razorcsGenericModifier
syn keyword razorcsGenericModifier in out contained
syn match razorcsDeclarator /\%#=1\h\w*\%(\.\h\w*\)*\%(<.\{-}>\)\=/ contained contains=razorcsGenericDefinition,razorcsModifier,razorcsStatement,razorcsType nextgroup=razorcsAssignmentOperator,razorcsLambdaOperator,razorcsParameters skipwhite

syn region razorcsTypeTuple matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contains=razorcsType,razorcsLHSIdentifier,razorcsTypeTuple nextgroup=razorcsDeclarator,razorcsConstant,razorcsAssignmentOperator,@razorcsTypeModifiers skipwhite

syn cluster razorcsTypeModifiers contains=razorcsTypeNullable,razorcsTypePointer,razorcsTypeArray
syn match razorcsTypeNullable /\%#=1?/ contained nextgroup=razorcsDeclarator,razorcsConstant,razorcsTypePointer,razorcsTypeArray skipwhite
syn match razorcsTypePointer /\%#=1\*\+/ contained nextgroup=razorcsDeclarator,razorcsConstant,razorcsTypeArray skipwhite
syn region razorcsTypeArray matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1]/ contained oneline contains=@razorcsRHS nextgroup=razorcsDeclarator,razorcsConstant,razorcsTypeArray,razorcsAssignmentOperator skipwhite

syn match razorcsLHSMemberAccessOperator /\%#=1?\=\./ contained nextgroup=razorcsLHSIdentifier
syn match razorcsLHSMemberAccessOperator /\%#=1->/ contained nextgroup=razorcsLHSIdentifier
syn match razorcsLHSMemberAccessOperator /\%#=1::/ contained nextgroup=razorcsLHSIdentifier

syn keyword razorcsModifier public protected internal private nextgroup=razorcsConstructor skipwhite
syn match razorcsConstructor /\%#=1\h\w*\%(\s*(\)\@=/ contained nextgroup=razorcsParameters skipwhite
syn region razorcsParameters matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsType,razorcsTypeTuple,razorcsLHSIdentifier,razorcsModifier,razorcsConstant nextgroup=razorcsLambdaOperator,razorcsBlock skipwhite

syn match razorcsCompoundAssignmentOperator /\%#=1\%([+\-*/%^]\|&&\=\|||\=\|<<\|>>\|??\)=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsAssignmentOperator /\%#=1=/ contained nextgroup=@razorcsRHS skipwhite skipnl

syn match razorcsLambdaOperator /\%#=1=>/ contained nextgroup=@razorcsRHS,razorcsBlock skipwhite skipnl

syn match razorcsWhereStatement /\%#=1\<where\s*\h\w*\s*:\s*\h\w*\%(\.\h\w*\)*\%(<.\{-}>\)\=/ contains=razorcsWhereKeyword,razorcsInheritanceOperator nextgroup=razorcsTypeComma skipwhite
syn keyword razorcsWhereKeyword where contained nextgroup=razorcsTypeVariable skipwhite

syn region razorcsAttribute matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1]/ contains=razorcsRHSVariable

syn region razorcsBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contains=@razorcs,razorHTML,razorComment nextgroup=razorcsAssignmentOperator skipwhite
" }}}2

" Highlighting {{{1
hi def link razorcsOperator Operator
hi def link razorcsUnaryOperator razorcsOperator
hi def link razorcsOperatorKeyword Keyword
hi def link razorcsUnaryOperatorKeyword razorcsOperatorKeyword
hi def link razorcsLHSMemberAccessOperator razorcsOperator
hi def link razorcsRHSMemberAccessOperator razorcsLHSMemberAccessOperator
hi def link razorcsDelimiter Delimiter
hi def link razorcsComment Comment
hi def link razorcsTodo Todo
hi def link razorcsPreprocessor PreProc
hi def link razorcsIncrementOperator razorcsOperator
hi def link razorcsDecrementOperator razorcsOperator
hi def link razorcsPointerIndirectionOperator razorcsOperator
hi def link razorcsStatement Statement
hi def link razorcsModifier Keyword
hi def link razorcsType Type
hi def link razorcsDeclarator Identifier
hi def link razorcsAssignmentOperator razorcsOperator
hi def link razorcsCompoundAssignmentOperator razorcsAssignmentOperator
hi def link razorcsLambdaOperator razorcsOperator
hi def link razorcsLambdaDeclarator razorcsDeclarator
hi def link razorcsLambdaParameter razorcsLambdaDeclarator
hi def link razorcsInheritanceOperator razorcsOperator
hi def link razorcsVariable razorcsDeclarator
hi def link razorcsConstructor razorcsDeclarator
hi def link razorcsTypeDefinition Typedef
hi def link razorcsEnumDefinition razorcsTypeDefinition
hi def link razorcsBoolean Boolean
hi def link razorcsNull Constant
hi def link razorcsConstant Constant
hi def link razorcsNumber Number
hi def link razorcsCharacter Character
hi def link razorcsString String
hi def link razorcsStringDelimiter razorcsString
hi def link razorcsStringInterpolationDelimiter PreProc
hi def link razorcsStringNoInterpolation razorcsString
hi def link razorcsEscapeSequence SpecialChar
hi def link razorcsEscapeSequenceError Error
hi def link razorcsQuoteEscape razorcsEscapeSequence
hi def link razorcsQueryKeyword Keyword
hi def link razorcsQueryVariable razorcsVariable
" }}}1

" vim:fdm=marker

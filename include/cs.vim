syn keyword razorCSModifier nextgroup=razorCSModifier,razorCSType,razorCSDefine,razorCSUserType,razorCSNew,razorCSFunctionDefinition skipwhite skipnl
      \ public private protected abstract const static virtual sealed
      \ extern internal event explicit implicit override new out params
      \ readonly ref stackalloc using volatile async

syn keyword razorCSType nextgroup=razorCSOperatorDefine,razorCSArrayType,razorCSNullableType,razorCSFunctionDefinition,razorCSVariable,razorCSMemberAccessOperator skipwhite skipnl
      \ bool byte char decimal object string delegate dynamic double
      \ enum void float int long sbyte short uint ulong ushort var

syn match razorCSUserType /\%#=1\h\w*/ display nextgroup=razorCSGeneric,razorCSArrayType,razorCSNullableType,razorCSOperatorDefine,razorCSFunctionDefinition,razorCSVariable,razorCSMemberAccessOperator skipwhite skipnl

syn match razorCSArrayType /\[]/ display contained nextgroup=razorCSOperatorDefine,razorCSFunctionDefinition,razorCSVariable skipwhite skipnl
syn match razorCSNullableType /?/ display contained nextgroup=razorCSOperatorDefine,razorCSArrayType,razorCSFunctionDefinition,razorCSVariable skipwhite skipnl

syn keyword razorCSDefine nextgroup=razorCSDefinition skipwhite skipnl
      \ class namespace struct interface alias

syn match razorCSDefinition /\%#=1\h\w*\%(\.\h\w*\)*/ display contained nextgroup=razorCSBlock skipwhite skipnl

syn match razorCSVariable /\%#=1\<\h\w*/ transparent contains=NONE nextgroup=@razorCSContainedOperators,razorCSGeneric skipwhite skipnl

syn match razorCSFunctionDefinition /\%#=1\h\w*(.*)/ display contained contains=razorCSFunctionParameters
syn region razorCSFunctionParameters matchgroup=razorCSParenthesis start=/(/ end=/)/ display contained contains=razorCSModifier,razorCSType,razorCSUserType,razorCSPseudoVariable nextgroup=razorCSBlock,razorCSLambdaOperator skipwhite skipnl

syn region razorCSParentheses matchgroup=razorCSParenthesis start=/(/ end=/)/ display contains=@razorCS nextgroup=@razorCSContainedOperators skipwhite skipnl

syn region razorCSBlock matchgroup=razorCSBrace start=/{/ end=/}/ display contained contains=@razorCS,razorInnerHTML

syn keyword razorCSOperatorDefine operator contained nextgroup=razorCSUnaryOperator,razorCSBinaryOperator,razorCSType,razorCSUserType,razorCSBoolean skipwhite skipnl

syn match razorCSUnaryOperator /\%#=1[+\-!~^]/ display

" The nextgroup argument here is intended to allow optional parameters
" inside razorCSFunctionParameters
syn match razorCSAssignmentOperator /\%#=1=/ display contained nextgroup=@razorCS skipwhite skipnl

syn match razorCSBinaryOperator /\%#=1[+\-*/%&|^<>]/ display contained
syn match razorCSBinaryOperator /\%#=1[!=]=/ display contained
syn match razorCSBinaryOperator /\%#=1<[<=]/ display contained
syn match razorCSBinaryOperator /\%#=1>[>=]/ display contained
syn match razorCSBinaryOperator /\%#=1&&/ display contained
syn match razorCSBinaryOperator /\%#=1||/ display contained
syn match razorCSBinaryOperator /\%#=1??/ display contained
syn match razorCSBinaryOperator /\%#=1\.\./ display contained

syn match razorCSTernaryOperator /\%#=1[?:]/ display contained

syn match razorCSModifiedAssignmentOperator /\%#=1[+\-*/%&|^]=/ display contained
syn match razorCSModifiedAssignmentOperator /\%#=1<<=/ display contained
syn match razorCSModifiedAssignmentOperator /\%#=1>>=/ display contained
syn match razorCSModifiedAssignmentOperator /\%#=1??=/ display contained

syn match razorCSMemberAccessOperator /\%#=1?\=\./ display contained nextgroup=razorCSVariable skipwhite skipnl
syn match razorCSPointerMemberAccessOperator /\%#=1->/ display contained nextgroup=razorCSVariable skipwhite skipnl
syn region razorCSIndexOperator matchgroup=Operator start=/\%#=1?\=\[/ end=/]/ display contained contains=@razorCS nextgroup=@razorCSContainedOperators skipwhite skipnl

syn match razorCSLambdaOperator /\%#=1=>/ display contained nextgroup=razorCSBlock skipwhite skipnl

syn cluster razorCSContainedOperators contains=
      \ razorCSBinaryOperator,razorCSTernaryOperator,razorCSAssignmentOperator,
      \ razorCSModifiedAssignmentOperator,razorCSMemberAccessOperator,
      \ razorCSPointerMemberAccessOperator,razorCSIndexOperator,razorCSLambdaOperator

syn region razorCSGeneric matchgroup=razorCSGenericBracket start=/</ end=/>/ display oneline contained contains=razorCSType,razorCSUserType nextgroup=razorCSFunctionDefinition skipwhite skipnl

syn keyword razorCSKeywordOperator where sizeof typeof await using

syn keyword razorCSAs as nextgroup=razorCSType,razorCSUserType skipwhite skipnl
syn keyword razorCSIs is nextgroup=razorCSType,razorCSUserType skipwhite skipnl
syn keyword razorCSNew new nextgroup=razorCSType,razorCSUserType,razorCSNewArray skipwhite skipnl
syn match razorCSNewArray /\[]/ display contained nextgroup=razorCSBlock skipwhite skipnl

syn keyword razorCSBoolean true false nextgroup=@razorCSContainedOperators skipwhite skipnl
syn keyword razorCSNull null nextgroup=@razorCSContainedOperators skipwhite skipnl

syn keyword razorCSPseudoVariable this base nextgroup=@razorCSContainedOperators skipwhite skipnl

syn keyword razorCSControl break catch continue finally goto return throw try

syn keyword razorCSConditional case default else if switch

syn keyword razorCSStatement checked unchecked fixed unsafe

syn keyword razorCSRepeat do for foreach in while

syn match razorCSInteger /\%#=1\d\%(_*\d\)*[uU]\=[lL]\=/ display nextgroup=@razorCSContainedOperators skipwhite skipnl
syn match razorCSFloat   /\%#=1\d\%(_*\d\)*\%(\.\d\%(_*\d\)*\)\=[eE][+-]\=\d\%(_*\d\)*[fFmM]\=/ display nextgroup=@razorCSContainedOperators skipwhite skipnl
syn match razorCSFloat   /\%#=1\d\%(_*\d\)*\.\d\%(_*\d\)*[fFmM]\=/ display nextgroup=@razorCSContainedOperators skipwhite skipnl
syn match razorCSFloat   /\%#=1\d\%(_*\d\)*[fFmM]/ display nextgroup=@razorCSContainedOperators skipwhite skipnl

syn region razorCSString start=/"/   end=/"/ display oneline contains=razorCSEscapeSequence nextgroup=@razorCSContainedOperators skipwhite skipnl
syn region razorCSString start=/$"/  end=/"/ display oneline contains=razorCSEscapeSequence,razorCSStringInterpolation nextgroup=@razorCSContainedOperators skipwhite skipnl
syn region razorCSString start=/@"/  end=/"/ display nextgroup=@razorCSContainedOperators skipwhite skipnl
syn region razorCSString start=/$@"/ end=/"/ display contains=razorCSStringInterpolation nextgroup=@razorCSContainedOperators skipwhite skipnl
syn region razorCSString start=/@$"/ end=/"/ display contains=razorCSStringInterpolation nextgroup=@razorCSContainedOperators skipwhite skipnl

syn match razorCSCharacter /'\%(\\\%(\o\o\o\|x\x\x\|x\x\x\x\x\|.\)\|.\)'/ display contains=razorCSEscapeSequence nextgroup=@razorCSConditional skipwhite skipnl

syn match razorCSEscapeSequence /\\\%(\o\o\o\|x\x\x\|x\x\x\x\x\|.\)/ display contained

syn region razorCSStringInterpolation matchgroup=razorCSStringInterpolationDelimiter start=/{/ end=/}/ display oneline contained contains=@razorCS

syn region razorCSComment start=/\/\// end=/\_$/ display
syn region razorCSComment start=/\/\*/ end=/\*\// display

syn sync ccomment razorCSComment

hi def link razorCSModifier Keyword
hi def link razorCSType Type
hi def link razorCSUserType razorCSType
hi def link razorCSFunctionDefinition Typedef
hi def link razorCSGenericBracket Delimiter
hi def link razorCSParenthesis Delimiter
hi def link razorCSBrace Delimiter
hi def link razorCSArrayType razorCSType
hi def link razorCSNullableType razorCSType
hi def link razorCSDefine Statement
hi def link razorCSDefinition Typedef
hi def link razorCSOperatorDefine Statement
hi def link razorCSUnaryOperator Operator
hi def link razorCSBinaryOperator Operator
hi def link razorCSTernaryOperator Operator
hi def link razorCSAssignmentOperator Operator
hi def link razorCSMemberAccessOperator Operator
hi def link razorCSPointerMemberAccessOperator Operator
hi def link razorCSIndexOperator Operator
hi def link razorCSLambdaOperator Operator
hi def link razorCSKeywordOperator Keyword
hi def link razorCSAs Keyword
hi def link razorCSIs Keyword
hi def link razorCSNew Keyword
hi def link razorCSNewArray razorCSNew
hi def link razorCSBoolean Constant
hi def link razorCSNull Constant
hi def link razorCSPseudoVariable Constant
hi def link razorCSControl Statement
hi def link razorCSConditional Conditional
hi def link razorCSStatement Statement
hi def link razorCSRepeat Repeat
hi def link razorCSString String
hi def link razorCSCharacter Character
hi def link razorCSInteger Number
hi def link razorCSFloat Float
hi def link razorCSEscapeSequence SpecialChar
hi def link razorCSStringInterpolationDelimiter PreProc
hi def link razorCSComment Comment
hi def link razorCSTodo Todo

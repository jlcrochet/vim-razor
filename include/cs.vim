syn keyword razorCSModifier nextgroup=razorCSModifier,razorCSType,razorCSDefine,razorCSUserType,razorCSNew,razorCSFunctionDefinition skipwhite skipnl
      \ public private protected abstract const static virtual sealed
      \ extern internal event explicit implicit override params
      \ readonly ref stackalloc using volatile async

syn keyword razorCSType nextgroup=razorCSOperatorDefine,razorCSTypeModifier,razorCSFunctionDefinition,razorCSVariable,razorCSMemberAccessOperator skipwhite skipnl
      \ bool byte char decimal object string delegate dynamic double
      \ enum void float int long sbyte short uint ulong ushort var

syn match razorCSUserType /\%#=1\h\w*/ display contained nextgroup=razorCSGeneric,razorCSTypeModifier,razorCSOperatorDefine,razorCSFunctionDefinition,razorCSVariable,razorCSMemberAccessOperator skipwhite skipnl

hi def link razorCSDeclaration Identifier

syn match razorCSTypeModifier /\%(\[]\|?\|\*\)*/ display contained nextgroup=razorCSOperatorDefine,razorCSFunctionDefinition,razorCSVariable skipwhite skipnl

syn keyword razorCSDefine nextgroup=razorCSDefinition skipwhite skipnl
      \ class namespace struct interface alias

syn match razorCSDefinition /\%#=1\h\w*\%(\.\h\w*\)*/ display contained nextgroup=razorCSBlock skipwhite skipnl

syn match razorCSVariable /\%#=1\<\h\w*/ transparent contains=NONE nextgroup=@razorCSContainedOperators,razorCSGeneric skipwhite skipnl

syn match razorCSFunctionDefinition /\%#=1\h\w*(.\{-})/ display contained contains=razorCSFunctionParameters
syn region razorCSFunctionParameters matchgroup=razorCSParenthesis start=/(/ end=/)/ display contained contains=razorCSModifier,razorCSKeywordOperator,razorCSType,razorCSUserType,razorCSPseudoVariable nextgroup=razorCSBlock,razorCSLambdaOperator skipwhite skipnl

syn region razorCSParentheses matchgroup=razorCSParenthesis start=/(/ end=/)/ display transparent contains=@razorCS nextgroup=@razorCSContainedOperators skipwhite skipnl

syn region razorCSBlock matchgroup=razorCSBrace start=/{/ end=/}/ display contained contains=@razorCS,razorCSBlock,razorInnerHTML,razorComment

syn keyword razorCSOperatorDefine operator contained nextgroup=razorCSUnaryOperator,razorCSBinaryOperator,razorCSType,razorCSUserType,razorCSBoolean skipwhite skipnl

" The nextgroup argument here is intended to allow optional parameters
" inside razorCSFunctionParameters
syn match razorCSAssignmentOperator /\%#=1=/ display contained nextgroup=@razorCS skipwhite skipnl

syn match razorCSUnaryOperator /\%#=1\*/ display nextgroup=razorCSVariable
syn match razorCSUnaryOperator /\%#=1[!~]/ display
syn match razorCSUnaryOperator /\%#=1++\=/ display
syn match razorCSUnaryOperator /\%#=1--\=/ display

syn match razorCSBinaryOperator /\%#=1[*+\-/%&|^]=\=/ display contained
syn match razorCSBinaryOperator /\%#=1[=!]=/ display contained
syn match razorCSBinaryOperator /\%#=1[<>]=\=/ display contained
syn match razorCSBinaryOperator /\%#=1&&=\=/ display contained
syn match razorCSBinaryOperator /\%#=1||=\=/ display contained
syn match razorCSBinaryOperator /\%#=1<<=\=/ display contained
syn match razorCSBinaryOperator /\%#=1>>=\=/ display contained
syn match razorCSBinaryOperator /\%#=1??=/ display contained

syn match razorCSTernaryOperator /\%#=1[?:]/ display contained

syn match razorCSMemberAccessOperator /\%#=1?\=\./ display contained nextgroup=razorCSVariable skipwhite skipnl
syn match razorCSMemberAccessOperator /\%#=1->/ display contained nextgroup=razorCSVariable skipwhite skipnl
syn region razorCSIndexOperator matchgroup=razorCSIndexBrackets start=/\%#=1?\=\[/ end=/]/ display contained contains=@razorCS nextgroup=@razorCSContainedOperators skipwhite skipnl

syn match razorCSLambdaOperator /\%#=1=>/ display contained nextgroup=razorCSBlock skipwhite skipnl

syn cluster razorCSContainedOperators contains=
      \ razorCSBinaryOperator,razorCSTernaryOperator,razorCSAssignmentOperator,
      \ razorCSMemberAccessOperator,
      \ razorCSIndexOperator,razorCSLambdaOperator,
      \ razorCSComment  " This is to prevent slash operators from clobbering C# comments

syn region razorCSGeneric matchgroup=razorCSGenericBracket start=/</ end=/>/ display oneline contained contains=razorCSType,razorCSUserType nextgroup=razorCSFunctionDefinition,razorCSVariable,razorCSTypeModifier,razorCSParentheses skipwhite skipnl

syn keyword razorCSKeywordOperator where sizeof typeof await using out

syn keyword razorCSAs as nextgroup=razorCSType,razorCSUserType skipwhite skipnl
syn keyword razorCSIs is nextgroup=razorCSType,razorCSUserType skipwhite skipnl
syn keyword razorCSNew new nextgroup=razorCSType,razorCSUserType,razorCSNewArray,razorCSBlock skipwhite skipnl
syn match razorCSNewArray /\[]/ display contained nextgroup=razorCSBlock skipwhite skipnl

syn keyword razorCSBoolean true false nextgroup=@razorCSContainedOperators skipwhite skipnl
syn keyword razorCSNull null nextgroup=@razorCSContainedOperators skipwhite skipnl

syn keyword razorCSPseudoVariable this base nextgroup=@razorCSContainedOperators skipwhite skipnl

syn keyword razorCSControl break catch continue finally goto return throw try

syn keyword razorCSConditional case default else if switch

syn keyword razorCSStatement checked unchecked fixed unsafe

syn keyword razorCSRepeat do for foreach in while

function s:or(...)
  return '\%('.join(a:000, '\|').'\)'
endfunction

function s:optional(re)
  return '\%('.a:re.'\)\='
endfunction

let s:decimal = '\d\%(_*\d\)*'
let s:binary = '0[bB][01]\%(_*[01]\)*'
let s:hexadecimal = '0[xX]\x\%(_*\x\)*'

let s:unsigned_suffix = '[uU]'
let s:long_suffix = '[lL]'
let s:integer_suffix = s:or(s:unsigned_suffix.s:long_suffix.'\=', s:long_suffix.s:unsigned_suffix.'\=')
let s:float_suffix = '[fF]'
let s:decimal_suffix = '[mM]'
let s:exponent_suffix = '[eE][+-]\='.s:decimal

let s:syn_match_template = 'syn match razorCSNumber /\%%#=1%s/ display nextgroup=razorCSBinaryOperator,razorCSTernaryOperator skipwhite skipnl'

let s:decimal_re = s:decimal . s:or(
      \ s:integer_suffix,
      \ s:float_suffix,
      \ s:decimal_suffix,
      \ s:exponent_suffix . s:or(s:float_suffix, s:decimal_suffix).'\=',
      \ '\.'.s:decimal . s:optional(s:exponent_suffix) . s:or(s:float_suffix, s:decimal_suffix).'\='
      \ ) . '\='

let s:binary_re = s:binary . s:integer_suffix.'\='

let s:hexadecimal_re = s:hexadecimal . s:or(
      \ s:integer_suffix,
      \ s:float_suffix,
      \ s:exponent_suffix . s:float_suffix.'\='
      \ ) . '\='

execute printf(s:syn_match_template, s:decimal_re)
execute printf(s:syn_match_template, s:binary_re)
execute printf(s:syn_match_template, s:hexadecimal_re)

delfunction s:or
delfunction s:optional

unlet
      \ s:decimal s:binary s:hexadecimal
      \ s:unsigned_suffix s:long_suffix s:integer_suffix
      \ s:float_suffix s:decimal_suffix s:exponent_suffix
      \ s:decimal_re s:binary_re s:hexadecimal_re
      \ s:syn_match_template

syn region razorCSString matchgroup=razorCSStringDelimiter start=/"/   end=/"/ display oneline contains=razorCSEscapeSequence nextgroup=razorCSBinaryOperator,razorCSTernaryOperator,razorCSIndexOperator skipwhite skipnl
syn region razorCSString matchgroup=razorCSStringDelimiter start=/$"/  end=/"/ display oneline contains=razorCSEscapeSequence,razorCSStringInterpolation nextgroup=razorCSBinaryOperator,razorCSTernaryOperator,razorCSIndexOperator skipwhite skipnl
syn region razorCSString matchgroup=razorCSStringDelimiter start=/@"/  end=/"/ display nextgroup=razorCSBinaryOperator,razorCSTernaryOperator,razorCSIndexOperator skipwhite skipnl
syn region razorCSString matchgroup=razorCSStringDelimiter start=/$@"/ end=/"/ display contains=razorCSStringInterpolation nextgroup=razorCSBinaryOperator,razorCSTernaryOperator,razorCSIndexOperator skipwhite skipnl
syn region razorCSString matchgroup=razorCSStringDelimiter start=/@$"/ end=/"/ display contains=razorCSStringInterpolation nextgroup=razorCSBinaryOperator,razorCSTernaryOperator,razorCSIndexOperator skipwhite skipnl

syn match razorCSCharacter /'\%(\\\%(\o\o\o\|x\x\x\|x\x\x\x\x\|.\)\|.\)'/ display contains=razorCSEscapeSequence nextgroup=razorCSBinaryOperator,razorCSTernaryOperator skipwhite skipnl

syn match razorCSEscapeSequence /\\\%(\o\o\o\|x\x\x\|x\x\x\x\x\|.\)/ display contained

syn region razorCSStringInterpolation matchgroup=razorCSStringInterpolationDelimiter start=/{/ end=/}/ display oneline contained contains=@razorCS

syn region razorCSComment start=/\/\// end=/\_$/ display
syn region razorCSComment start=/\/\*/ end=/\*\// display

hi def link razorCSModifier Keyword
hi def link razorCSType Type
hi def link razorCSUserType razorCSType
hi def link razorCSTypeModifier razorCSType
hi def link razorCSFunctionDefinition Typedef
hi def link razorCSGenericBracket Delimiter
hi def link razorCSParenthesis Delimiter
hi def link razorCSBrace Delimiter
hi def link razorCSDefine Statement
hi def link razorCSDefinition Typedef
hi def link razorCSOperatorDefine Statement
hi def link razorCSUnaryOperator Operator
hi def link razorCSBinaryOperator Operator
hi def link razorCSTernaryOperator Operator
hi def link razorCSAssignmentOperator Operator
hi def link razorCSMemberAccessOperator Operator
hi def link razorCSIndexBrackets Operator
hi def link razorCSLambdaOperator Operator
hi def link razorCSKeywordOperator Keyword
hi def link razorCSAs Keyword
hi def link razorCSIs Keyword
hi def link razorCSNew Keyword
hi def link razorCSNewArray razorCSNew
hi def link razorCSBoolean Boolean
hi def link razorCSNull Constant
hi def link razorCSPseudoVariable Constant
hi def link razorCSControl Statement
hi def link razorCSConditional Conditional
hi def link razorCSStatement Statement
hi def link razorCSRepeat Repeat
hi def link razorCSString String
hi def link razorCSStringDelimiter razorCSString
hi def link razorCSCharacter Character
hi def link razorCSNumber Number
hi def link razorCSEscapeSequence SpecialChar
hi def link razorCSStringInterpolationDelimiter PreProc
hi def link razorCSComment Comment
hi def link razorCSTodo Todo

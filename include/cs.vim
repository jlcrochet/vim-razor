syn match razorcsUnicodeEscapeSequence /\%#=1\\u\x\{4}/ display containedin=ALL
syn match razorcsUnicodeEscapeSequence /\%#=1\\U\x\{8}/ display containedin=ALL

syn keyword razorcsModifier nextgroup=razorcsModifier,razorcsTypeExpression,razorcsType,razorcsDefine,razorcsNew,razorcsFunctionDefinition skipwhite skipnl
      \ public private protected abstract const static virtual sealed
      \ extern internal event explicit implicit override params
      \ readonly ref stackalloc using volatile async

syn match razorcsTypeExpression /\%#=1\h\w*\%(\.\h\w*\)*\%(<.\{-}>\)\=?\=\**\%(\[]\)*/ display contains=razorcsGeneric nextgroup=razorcsDeclarator,razorcsFunctionDefinition,razorcsOperatorDefinition skipwhite
syn region razorcsGeneric start=/\%#=1</ end=/\%#=1>/ display transparent contained oneline contains=razorcsTypeExpression

syn match razorcsDeclarator /\%#=1\h\w*/ display contained nextgroup=razorcsAssignmentOperator skipwhite skipnl

syn keyword razorcsType nextgroup=razorcsDeclarator,razorcsOperatorDefinition,razorcsFunctionDefinition,razorcsMemberAccessOperator skipwhite skipnl
      \ bool byte char decimal object string delegate dynamic double
      \ enum void float int long sbyte short uint ulong ushort var

syn keyword razorcsDefine nextgroup=razorcsDefinition skipwhite skipnl
      \ class namespace struct interface alias

syn match razorcsDefinition /\%#=1\h\w*\%(\.\h\w*\)*/ display contained nextgroup=razorcsBlock skipwhite skipnl

syn match razorcsVariable /\%#=1\h\w*/ display contained nextgroup=@razorcsContainedOperators,razorcsGeneric skipwhite skipnl

syn match razorcsFunctionDefinition /\%#=1\h\w*(\_.\{-})/ display contained contains=razorcsFunctionParameters
syn region razorcsFunctionParameters matchgroup=razorcsParenthesis start=/\%#=1(/ end=/\%#=1)/ display contained contains=razorcsModifier,razorcsKeywordOperator,razorcsTypeExpression,razorcsPseudoVariable nextgroup=razorcsBlock,razorcsLambdaOperator skipwhite skipnl

syn region razorcsParentheses matchgroup=razorcsParenthesis start=/\%#=1(/ end=/\%#=1)/ display contains=@razorcs nextgroup=@razorcsContainedOperators skipwhite skipnl

syn region razorcsBlock matchgroup=razorcsBrace start=/\%#=1{/ end=/\%#=1}/ display contained contains=@razorcs,razorcsBlock,razorComment

syn keyword razorcsOperatorDefinition operator contained nextgroup=razorcsUnaryOperator,razorcsBinaryOperator,razorcsTypeExpression,razorcsBoolean skipwhite skipnl

" The nextgroup argument here is intended to allow optional parameters
" inside razorcsFunctionParameters
syn match razorcsAssignmentOperator /\%#=1=/ display contained nextgroup=@razorcs skipwhite skipnl

syn match razorcsUnaryOperator /\%#=1\*/ display nextgroup=razorcsVariable
syn match razorcsUnaryOperator /\%#=1[!~]/ display
syn match razorcsUnaryOperator /\%#=1++\=/ display
syn match razorcsUnaryOperator /\%#=1--\=/ display

syn match razorcsTernaryOperator /\%#=1[?:]/ display contained

syn match razorcsBinaryOperator /\%#=1[*+\-/%&|^]=\=/ display contained
syn match razorcsBinaryOperator /\%#=1[=!]=/ display contained
syn match razorcsBinaryOperator /\%#=1[<>]=\=/ display contained
syn match razorcsBinaryOperator /\%#=1&&=\=/ display contained
syn match razorcsBinaryOperator /\%#=1||=\=/ display contained
syn match razorcsBinaryOperator /\%#=1<<=\=/ display contained
syn match razorcsBinaryOperator /\%#=1>>=\=/ display contained
syn match razorcsBinaryOperator /\%#=1??=/ display contained

syn match razorcsMemberAccessOperator /\%#=1?\=\./ display contained nextgroup=razorcsVariable skipwhite skipnl
syn match razorcsMemberAccessOperator /\%#=1->/ display contained nextgroup=razorcsVariable skipwhite skipnl
syn region razorcsIndexOperator matchgroup=razorcsIndexBrackets start=/\%#=1?\=\[/ end=/\%#=1]/ display transparent contained contains=@razorcs nextgroup=@razorcsContainedOperators skipwhite skipnl

syn match razorcsLambdaOperator /\%#=1=>/ display contained nextgroup=razorcsBlock skipwhite skipnl

syn cluster razorcsContainedOperators contains=
      \ razorcsBinaryOperator,razorcsTernaryOperator,razorcsAssignmentOperator,
      \ razorcsMemberAccessOperator,
      \ razorcsIndexOperator,razorcsLambdaOperator,
      \ razorcsComment  " This is to prevent slash operators from clobbering C# comments

syn keyword razorcsKeywordOperator where await using out
syn keyword razorcsKeywordOperator typeof sizeof

syn keyword razorcsAs as nextgroup=razorcsTypeExpression skipwhite skipnl
syn keyword razorcsIs is nextgroup=razorcsTypeExpression skipwhite skipnl
syn keyword razorcsNew new nextgroup=razorcsTypeExpression,razorcsNewArray,razorcsBlock skipwhite skipnl
syn region razorcsNewArray start=/\%#=1\[/ end=/\%#=1]/ display transparent contained nextgroup=razorcsBlock skipwhite skipnl

syn keyword razorcsBoolean true false nextgroup=@razorcsContainedOperators skipwhite skipnl
syn keyword razorcsNull null nextgroup=@razorcsContainedOperators skipwhite skipnl

syn keyword razorcsPseudoVariable this base nextgroup=@razorcsContainedOperators skipwhite skipnl

syn keyword razorcsControl break continue finally goto return throw try
syn keyword razorcsControl catch

syn keyword razorcsConditional case default else if switch

syn keyword razorcsStatement checked unchecked fixed unsafe

syn keyword razorcsRepeat do for foreach in while

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

let s:syn_match_template = 'syn match razorcsNumber /\%%#=1%s/ display nextgroup=razorcsBinaryOperator,razorcsTernaryOperator skipwhite skipnl'

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

syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1"/   end=/\%#=1"/ display oneline contains=razorcsEscapeSequence nextgroup=razorcsBinaryOperator,razorcsTernaryOperator,razorcsIndexOperator skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1$"/  end=/\%#=1"/ display oneline contains=razorcsEscapeSequence,razorcsStringInterpolation nextgroup=razorcsBinaryOperator,razorcsTernaryOperator,razorcsIndexOperator skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1@"/  end=/\%#=1"/ display nextgroup=razorcsBinaryOperator,razorcsTernaryOperator,razorcsIndexOperator skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1$@"/ end=/\%#=1"/ display contains=razorcsStringInterpolation nextgroup=razorcsBinaryOperator,razorcsTernaryOperator,razorcsIndexOperator skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1@$"/ end=/\%#=1"/ display contains=razorcsStringInterpolation nextgroup=razorcsBinaryOperator,razorcsTernaryOperator,razorcsIndexOperator skipwhite skipnl

syn match razorcsCharacter /\%#=1'\%(\\\%(\o\o\o\|x\x\x\|x\x\x\x\x\|.\)\|.\)'/ display contains=razorcsEscapeSequence nextgroup=razorcsBinaryOperator,razorcsTernaryOperator skipwhite skipnl

syn match razorcsEscapeSequence /\%#=1\\\%(\o\o\o\|x\x\x\|x\x\x\x\x\|.\)/ display contained

syn region razorcsStringInterpolation matchgroup=razorcsStringInterpolationDelimiter start=/\%#=1{/ end=/\%#=1}/ display oneline contained contains=@razorcs

syn region razorcsComment start=/\%#=1\/\// end=/\%#=1\_$/ display contains=razorTodo
syn region razorcsComment start=/\%#=1\/\*/ end=/\%#=1\*\// display keepend contains=razorTodo

syn keyword razorcsTodo TODO NOTE XXX FIXME HACK TBD

hi def link razorcsUnicodeEscapeSequence PreProc
hi def link razorcsModifier Keyword
" hi def link razorcsType Type
" hi def link razorcsTypeExpression razorcsType
hi def link razorcsTypeExpression Underlined
hi def link razorcsFunctionDefinition Typedef
hi def link razorcsGenericBracket Delimiter
hi def link razorcsParenthesis Delimiter
hi def link razorcsBrace Delimiter
hi def link razorcsDefine Statement
hi def link razorcsDefinition Typedef
hi def link razorcsOperatorDefinition Statement
hi def link razorcsUnaryOperator Operator
hi def link razorcsBinaryOperator Operator
hi def link razorcsTernaryOperator Operator
hi def link razorcsAssignmentOperator Operator
hi def link razorcsMemberAccessOperator Operator
hi def link razorcsIndexBrackets Operator
hi def link razorcsLambdaOperator Operator
hi def link razorcsKeywordOperator Keyword
hi def link razorcsAs Keyword
hi def link razorcsIs Keyword
hi def link razorcsNew Keyword
hi def link razorcsNewArray razorcsNew
hi def link razorcsBoolean Boolean
hi def link razorcsNull Constant
hi def link razorcsPseudoVariable Constant
hi def link razorcsControl Statement
hi def link razorcsConditional Conditional
hi def link razorcsStatement Statement
hi def link razorcsRepeat Repeat
hi def link razorcsString String
hi def link razorcsStringDelimiter razorcsString
hi def link razorcsCharacter Character
hi def link razorcsNumber Number
hi def link razorcsEscapeSequence SpecialChar
hi def link razorcsStringInterpolationDelimiter PreProc
hi def link razorcsComment Comment
hi def link razorcsTodo Todo

hi def link razorcsDeclarator Identifier
hi Operator guifg=orange

" Syntax {{{1
syn region razorcsComment start=/\%#=1\/\// end=/\%#=1\_$/  display oneline contains=razorcsTodo
syn region razorcsComment start=/\%#=1\/\*/ end=/\%#=1\*\// display keepend contains=razorcsTodo

syn region razorcsComment start=/\%#=1\/\/\// end=/\%#=1\_$/  display oneline contains=razorcsTodo,@razorcsxml
syn region razorcsComment start=/\%#=1\/\*\*/ end=/\%#=1\*\// display keepend contains=razorcsTodo,@razorcsxml

syn keyword razorcsTodo TODO NOTE XXX FIXME HACK TBD contained
syn include @razorcsxml syntax/xml.vim

syn region razorcsPreprocessor start=/\%#=1#/ end=/\%#=1\_$/ display oneline

syn keyword razorcsKeyword
      \ abstract alias and as async await break case catch checked const
      \ continue default delegate do else event explicit extern finally
      \ fixed for foreach goto if implicit in internal is lock nameof
      \ new not operator or out override params partial private
      \ protected public readonly ref return sealed sizeof stackalloc
      \ static switch throw try typeof unchecked unsafe using virtual
      \ volatile when while yield

syn keyword razorcsKeyword where nextgroup=razorcsDeclarator skipwhite

syn keyword razorcsType nextgroup=razorcsDeclarator,razorcsTypeModifier,razorcsConstant skipwhite
      \ bool byte char decimal double dynamic float int long object
      \ sbyte short string uint ulong ushort var void

syn match razorcsTypeModifier /\%#=1?\=\**\%(\[.\{-}]\)*/ display transparent contained nextgroup=razorcsDeclarator,razorcsConstant skipwhite

syn match razorcsIdentifier /\%#=1\h\w*\%(<.\{-}>\)\=/ display contains=razorcsGeneric nextgroup=razorcsTypeModifier,razorcsDeclarator,razorcsKeyword,razorcsConstant,razorcsTuple skipwhite
syn region razorcsGeneric start=/\%#=1</ end=/\%#=1>/ display oneline contained contains=razorcsIdentifier,razorcsType

syn match razorcsDeclarator /\%#=1\h\w*/ display contained contains=razorcsKeyword

syn region razorcsTuple start=/\%#=1(/ end=/\%#=1)/ display transparent nextgroup=razorcsDeclarator,razorcsKeyword skipwhite

syn keyword razorcsKeyword nextgroup=razorcsTypeDefinition skipwhite
      \ class enum interface namespace struct record
syn match razorcsTypeDefinition /\%#=1\h\w*\%(\.\h\w*\)*\%(<.\{-}>\)\=/ display contained

syn keyword razorcsBoolean true false
syn keyword razorcsNull null

syn keyword razorcsConstant base this

function s:or(...)
  return '\%('.join(a:000, '\|').'\)'
endfunction

function s:optional(re)
  return '\%('.a:re.'\)\='
endfunction

let s:decimal = '\d[[:digit:]_]*'
let s:binary = '0[bB][01][01_]*'
let s:hexadecimal = '0[xX]\x[[:xdigit:]_]*'

let s:integer_suffix = '\%([uU][lL]\=\|[lL][uU]\=\)'
let s:float_suffix = '[fF]'
let s:decimal_suffix = '[mM]'
let s:exponent_suffix = '[eE][+-]\='.s:decimal

let s:syn_match_template = 'syn match razorcsNumber /\%%#=1%s/ display'

let s:decimal_re = s:decimal . s:or(
      \ s:integer_suffix,
      \ s:float_suffix,
      \ s:decimal_suffix,
      \ s:exponent_suffix . s:or(s:float_suffix, s:decimal_suffix).'\=',
      \ '\.'.s:decimal . s:optional(s:exponent_suffix) . s:or(s:float_suffix, s:decimal_suffix).'\='
      \ ) . '\='

let s:binary_re = s:binary . s:integer_suffix.'\=\>'

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
      \ s:integer_suffix s:float_suffix s:decimal_suffix s:exponent_suffix
      \ s:decimal_re s:binary_re s:hexadecimal_re
      \ s:syn_match_template

syn match razorcsCharacter /\%#=1'\%(\\\%(x\x\{1,4}\|u\x\{4}\|U\x\{8}\|.\)\|.\)'/ display contains=razorcsEscapeSequence

syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1"/   end=/\%#=1"/ display oneline contains=razorcsEscapeSequence
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1$"/  end=/\%#=1"/ display oneline contains=razorcsEscapeSequence,razorcsStringInterpolation
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1@"/  end=/\%#=1"/ display
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1$@"/ end=/\%#=1"/ display contains=razorcsStringInterpolation

syn region razorcsStringInterpolation matchgroup=razorcsStringInterpolationDelimiter start=/\%#=1{/ end=/\%#=1}/ display oneline contained contains=@razorcs

syn match razorcsEscapeSequence /\%#=1\\\%(x\x\{1,4}\|u\x\{4}\|U\x\{8}\|.\)/ display contained

syn region razorcsBlock matchgroup=razorcsBrace start=/\%#=1{/ end=/\%#=1}/ display transparent

" Highlighting {{{1
hi def link razorcsComment Comment
hi def link razorcsPreprocessor PreProc
hi def link razorcsTodo Todo
hi def link razorcsKeyword Keyword
hi def link razorcsType Type
hi def link razorcsDeclarator Identifier
hi def link razorcsTypeDefinition Typedef
hi def link razorcsBoolean Boolean
hi def link razorcsNull Constant
hi def link razorcsConstant Constant
hi def link razorcsNumber Number
hi def link razorcsCharacter Character
hi def link razorcsString String
hi def link razorcsStringDelimiter razorcsString
hi def link razorcsStringInterpolationDelimiter PreProc
hi def link razorcsEscapeSequence SpecialChar
" }}}1

" vim:fdm=marker

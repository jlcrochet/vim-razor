function s:choice(...)
  return '\%('.join(a:000, '\|').'\)'
endfunction

function s:optional(re)
  return '\%('.a:re.'\)\='
endfunction

let s:decimal = '\d\+\%(_\+\d\+\)*'
let s:binary = '0[bB]_*[01]\+\%(_\+[01]\+\)*'
let s:hexadecimal = '0[xX]_*\x\+\%(_\+\x\+\)*'

let s:integer_suffix = '\%([uU][lL]\=\|[lL][uU]\=\)'
let s:float_suffix = '[fFmMdD]'
let s:exponent_suffix = '[eE][+-]\='.s:decimal

let s:float_re = '\.'.s:decimal . s:optional(s:exponent_suffix) . s:float_suffix.'\='

let s:decimal_re = s:decimal . s:choice(
      \ s:integer_suffix,
      \ s:float_suffix,
      \ s:float_re,
      \ s:exponent_suffix . s:float_suffix.'\='
      \ ) . '\='

let s:binary_re = s:binary . s:integer_suffix.'\='

let s:hexadecimal_re = s:hexadecimal . s:choice(
      \ s:integer_suffix,
      \ s:float_suffix,
      \ s:exponent_suffix . s:float_suffix.'\='
      \ ) . '\='

let s:syn_match_template = 'syn match razorcsNumber /\%%#=1%s\>/ contained nextgroup=@razorcsOperators skipwhite skipempty'

const g:razorcs_numbers = printf(s:syn_match_template .. repeat("\n" .. s:syn_match_template, 3), s:float_re, s:decimal_re, s:binary_re, s:hexadecimal_re)

delfunction s:choice
delfunction s:optional

unlet
      \ s:decimal s:binary s:hexadecimal
      \ s:integer_suffix s:float_suffix s:exponent_suffix
      \ s:float_re s:decimal_re s:binary_re s:hexadecimal_re
      \ s:syn_match_template


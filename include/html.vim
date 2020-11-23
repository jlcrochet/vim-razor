syn include @razorhtmljs syntax/javascript.vim
syn include @razorhtmlcss syntax/css.vim

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<\a[[:alnum:]._-]*/ end=/\%#=1>/ display contains=razorhtmlAttribute
syn region razorhtmlTag start=/\%#=1<\// end=/\%#=1>/ display

syn match razorhtmlAttribute /\%#=1[^"'>/=[:space:]]\+/ display contained nextgroup=razorhtmlAttributeOperator skipwhite skipnl
syn match razorhtmlAttributeOperator /\%#=1=/ display contained nextgroup=razorhtmlValue skipwhite skipnl

syn match razorhtmlValue /\%#=1[^[:space:]>]\+/ display contained contains=razorhtmlEntityReference,razorhtmlCharacterReference

syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1"/ end=/\%#=1"/ display contained contains=razorhtmlEntityReference,razorhtmlCharacterReference
syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1'/ end=/\%#=1'/ display contained contains=razorhtmlEntityReference,razorhtmlCharacterReference

syn match razorhtmlEntityReference /\%#=1&\a[[:alnum:]]*;/ display
syn match razorhtmlCharacterReference /\%#=1&#\d\+;/ display
syn match razorhtmlCharacterReference /\%#=1&#x\x\+;/ display

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<script\>/ end=/\%#=1>/ display contains=razorhtmlAttribute nextgroup=razorhtmlTag,razorhtmlScript skipnl
syn region razorhtmlScript start=/\%#=1/ matchgroup=razorhtmlTag end=/\%#=1<\/script>/ display contained transparent contains=@razorhtmljs
syn match razorhtmlTag /\%#=1<\/script>/ display contained

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<style\>/ end=/\%#=1>/ display contains=razorhtmlAttribute nextgroup=razorhtmlTag,razorhtmlStyle skipnl
syn region razorhtmlStyle start=/\%#=1/ matchgroup=razorhtmlTag end=/\%#=1<\/style>/ display contained transparent contains=@razorhtmlcss
syn match razorhtmlTag /\%#=1<\/style>/ display contained

syn region razorhtmlSpecialTag start=/\%#=1<!/ end=/\%#=1>/ display contains=razorhtmlComment
syn region razorhtmlComment start=/\%#=1--/ end=/\%#=1--/ display keepend contained

hi def link razorhtmlTag Identifier
hi def link razorhtmlAttribute Keyword
hi def link razorhtmlValue String
hi def link razorhtmlValueDelimiter razorhtmlValue
hi def link razorhtmlEntityReference SpecialChar
hi def link razorhtmlCharacterReference razorhtmlEntityReference
hi def link razorhtmlSpecialTag Comment
hi def link razorhtmlComment razorhtmlSpecialTag

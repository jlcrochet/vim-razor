syn include @razorhtmljs syntax/javascript.vim
syn include @razorhtmlcss syntax/css.vim

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<\a[[:alnum:]._-]*/ end=/\%#=1>/ contains=razorhtmlAttribute
syn region razorhtmlTag start=/\%#=1<\// end=/\%#=1>/

syn match razorhtmlAttribute /\%#=1[^"'>/=[:space:]]\+/ contained nextgroup=razorhtmlAttributeOperator skipwhite skipnl
syn match razorhtmlAttributeOperator /\%#=1=/ contained nextgroup=razorhtmlValue skipwhite skipnl

syn match razorhtmlValue /\%#=1[^[:space:]>]\+/ contained contains=razorhtmlEntityReference,razorhtmlCharacterReference

syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1"/ end=/\%#=1"/ contained contains=razorhtmlEntityReference,razorhtmlCharacterReference
syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1'/ end=/\%#=1'/ contained contains=razorhtmlEntityReference,razorhtmlCharacterReference

syn match razorhtmlEntityReference /\%#=1&\a[[:alnum:]]*;/
syn match razorhtmlCharacterReference /\%#=1&#\d\+;/
syn match razorhtmlCharacterReference /\%#=1&#x\x\+;/

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<script\>/ end=/\%#=1>/ contains=razorhtmlAttribute nextgroup=razorhtmlTag,razorhtmlScript skipnl
syn region razorhtmlScript start=/\%#=1/ matchgroup=razorhtmlTag end=/\%#=1<\/script>/ contained transparent contains=@razorhtmljs
syn match razorhtmlTag /\%#=1<\/script>/ contained

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<style\>/ end=/\%#=1>/ contains=razorhtmlAttribute nextgroup=razorhtmlTag,razorhtmlStyle skipnl
syn region razorhtmlStyle start=/\%#=1/ matchgroup=razorhtmlTag end=/\%#=1<\/style>/ contained transparent contains=@razorhtmlcss
syn match razorhtmlTag /\%#=1<\/style>/ contained

syn region razorhtmlSpecialTag start=/\%#=1<!/ end=/\%#=1>/ contains=razorhtmlComment
syn region razorhtmlComment start=/\%#=1--/ end=/\%#=1--/ keepend contained

syn sync match razorhtmlSync grouphere razorhtmlScript /\%#=1<script\>/
syn sync match razorhtmlSync grouphere razorhtmlStyle /\%#=1<style\>/

hi def link razorhtmlTag Identifier
hi def link razorhtmlAttribute Keyword
hi def link razorhtmlValue String
hi def link razorhtmlValueDelimiter razorhtmlValue
hi def link razorhtmlEntityReference SpecialChar
hi def link razorhtmlCharacterReference razorhtmlEntityReference
hi def link razorhtmlSpecialTag Comment
hi def link razorhtmlComment razorhtmlSpecialTag

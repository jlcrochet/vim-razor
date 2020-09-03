syn include @razorhtmljs syntax/javascript.vim
syn include @razorhtmlcss syntax/css.vim

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<\a[[:alnum:]-.]*/ end=/\%#=1>/ display contains=razorhtmlAttribute
syn region razorhtmlTag start=/\%#=1<\// end=/\%#=1>/ display

syn match razorhtmlAttribute /\%#=1\a[[:alnum:]-.]*/ display contained nextgroup=razorhtmlAttribute,razorhtmlAttributeOperator skipwhite skipnl
syn match razorhtmlAttributeOperator /\%#=1=/ display contained nextgroup=razorhtmlValue skipwhite skipnl

syn match razorhtmlValue /\%#=1[^[:space:]>]\+/ display contained contains=razorhtmlCharacterReference

syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1"/ end=/\%#=1"/ display contained contains=razorhtmlCharacterReference
syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1'/ end=/\%#=1'/ display contained contains=razorhtmlCharacterReference

syn match razorhtmlCharacterReference /\%#=1&#\d\+;/ display
syn match razorhtmlCharacterReference /\%#=1&#x\x\+;/ display
syn match razorhtmlCharacterReference /\%#=1&\a[[:alnum:]]*;/ display

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<script\>/ end=/\%#=1>/ display contains=razorhtmlAttribute nextgroup=razorhtmlTag,razorhtmlScript skipnl
syn region razorhtmlScript start=// matchgroup=razorhtmlTag end=/\%#=1<\/script>/ display contained transparent contains=@razorhtmljs
syn match razorhtmlTag /\%#=1<\/script>/ display contained
syn match razorhtmlScriptError /\%#=1<\\\@1<!\/script>/ display contained containedin=javaScriptStringS,javaScriptStringD,javaScriptStringT

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<style\>/ end=/\%#=1>/ display contains=razorhtmlAttribute nextgroup=razorhtmlTag,razorhtmlStyle skipnl
syn region razorhtmlStyle start=// matchgroup=razorhtmlTag end=/\%#=1<\/style>/ display contained transparent contains=@razorhtmlcss
syn match razorhtmlTag /\%#=1<\/style>/ display contained

syn region razorhtmlComment start=/\%#=1<!--/ end=/\%#=1-->/ display

syn region razorhtmlDoctype start=/\%#=1<!DOCTYPE/ end=/\%#=1>/ display

hi def link razorhtmlTag Identifier
hi def link razorhtmlAttribute Keyword
hi def link razorhtmlAttributeOperator Operator
hi def link razorhtmlValue String
hi def link razorhtmlValueDelimiter razorhtmlValue
hi def link razorhtmlScriptError Error
hi def link razorhtmlCharacterReference SpecialChar
hi def link razorhtmlComment Comment
hi def link razorhtmlDoctype razorhtmlComment

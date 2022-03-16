syn include @razorhtmljs syntax/javascript.vim | unlet b:current_syntax
syn include @razorhtmlcss syntax/css.vim

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<!\=[[:alnum:]_:][[:alnum:]_:\-.]*/ end=/\%#=1>/ contains=razorhtmlAttribute

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<!\=script[[:space:]>]\@=/ end=/\%#=1>/ contains=razorhtmlAttribute nextgroup=razorhtmlScript,razorhtmlEndTag skipnl
syn region razorhtmlScript start=/\%#=1/ matchgroup=razorhtmlEndTag end=/\%#=1<\/!\=script>/ contained keepend transparent contains=@razorhtmljs

syn region razorhtmlTag matchgroup=razorhtmlTag start=/\%#=1<!\=style[[:space:]>]\@=/ end=/\%#=1>/ contains=razorhtmlAttribute nextgroup=razorhtmlStyle,razorhtmlEndTag skipnl
syn region razorhtmlStyle start=/\%#=1/ matchgroup=razorhtmlEndTag end=/\%#=1<\/!\=style>/ contained transparent contains=@razorhtmlcss

syn match razorhtmlEndTag /\%#=1<\/!\=[[:alnum:]_:][[:alnum:]_:\-.]*>/

syn match razorhtmlAttribute /\%#=1[^"'>/=[:space:]]\+/ contained nextgroup=razorhtmlAttributeOperator skipwhite skipempty
syn match razorhtmlAttributeOperator /\%#=1=/ contained nextgroup=razorhtmlValue skipwhite skipempty

syn match razorhtmlValue /\%#=1[^<>`[:space:]]\+/ contained contains=razorhtmlCharacterReference

syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1"/ end=/\%#=1"/ contained contains=razorhtmlCharacterReference
syn region razorhtmlValue matchgroup=razorhtmlValueDelimiter start=/\%#=1'/ end=/\%#=1'/ contained contains=razorhtmlCharacterReference

syn match razorhtmlCharacterReference /\%#=1&\%(\a\+\|#\%(\d\+\|[xX]\x\+\)\);/

syn region razorhtmlComment matchgroup=razorhtmlCommentStart start=/\%#=1<!--/ matchgroup=razorhtmlCommentEnd end=/\%#=1-->/
syn region razorhtmlDoctype start=/\%#=1<!\cdoctype[[:space:]>]\@=/ end=/\%#=1>/ contains=razorhtmlCharacterReference
syn region razorhtmlCDATA matchgroup=razorhtmlCDATAStart start=/\%#=1<!\[CDATA\[/ matchgroup=razorhtmlCDATAEnd end=/\%#=1]]>/ keepend

syn match razorhtmlError /\%#=1>/

hi def link razorhtmlTag Identifier
hi def link razorhtmlEndTag razorhtmlTag
hi def link razorhtmlAttribute Keyword
hi def link razorhtmlValue String
hi def link razorhtmlValueDelimiter razorhtmlValue
hi def link razorhtmlCharacterReference SpecialChar
hi def link razorhtmlComment Comment
hi def link razorhtmlCommentStart razorhtmlComment
hi def link razorhtmlCommentEnd razorhtmlCommentStart
hi def link razorhtmlDoctype razorhtmlComment
hi def link razorhtmlCDATA Special
hi def link razorhtmlCDATAStart razorhtmlCDATA
hi def link razorhtmlCDATAEnd razorhtmlCDATAStart
hi def link razorhtmlError Error

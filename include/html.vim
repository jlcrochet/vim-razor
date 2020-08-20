syn include @razorHTMLJS syntax/javascript.vim
syn include @razorHTMLCSS syntax/css.vim

syn region razorHTMLTag matchgroup=razorHTMLTag start=/\%#=1<\a[[:alnum:]-]*/ end=/>/ display contains=razorHTMLAttribute
syn region razorHTMLTag start=/\%#=1<\// end=/>/ display

syn match razorHTMLAttribute /\%#=1\a[[:alnum:]-]*/ display contained nextgroup=razorHTMLAttribute,razorHTMLAttributeOperator skipwhite skipnl
syn match razorHTMLAttributeOperator /=/ display contained nextgroup=razorHTMLValue skipwhite skipnl

syn match razorHTMLValue /\%#=1[^[:blank:]>]\+/ display contained contains=razorHTMLCharacterReference

syn region razorHTMLValue start=/"/ end=/"/ display contained contains=razorHTMLCharacterReference
syn region razorHTMLValue start=/'/ end=/'/ display contained contains=razorHTMLCharacterReference

syn match razorHTMLCharacterReference /\%#=1&#\d\+;/ display
syn match razorHTMLCharacterReference /\%#=1&#x\x\+;/ display
syn match razorHTMLCharacterReference /\%#=1&\a[[:alnum:]]\+;/ display

syn region razorHTMLTag matchgroup=razorHTMLTag start=/\%#=1<script\>/ end=/>/ display contains=razorHTMLAttribute nextgroup=razorHTMLTag,razorHTMLScript skipnl
syn region razorHTMLScript start=// matchgroup=razorHTMLTag end=/\%#=1<\/script>/ display contained transparent contains=@razorHTMLJS
syn match razorHTMLTag /\%#=1<\/script>/ display contained
syn match razorHTMLScriptError /\%#=1<\\\@1<!\/script>/ display contained containedin=javaScriptStringS,javaScriptStringD,javaScriptStringT

syn region razorHTMLTag matchgroup=razorHTMLTag start=/\%#=1<style\>/ end=/>/ display contains=razorHTMLAttribute nextgroup=razorHTMLTag,razorHTMLStyle skipnl
syn region razorHTMLStyle start=// matchgroup=razorHTMLTag end=/\%#=1<\/style>/ display contained transparent contains=@razorHTMLCSS
syn match razorHTMLTag /\%#=1<\/style>/ display contained

syn region razorHTMLComment start=/\%#=1<!--/ end=/-->/ display

syn region razorHTMLDoctype start=/\%#=1<!DOCTYPE/ end=/>/ display

hi def link razorHTMLTag Identifier
hi def link razorHTMLAttribute Keyword
hi def link razorHTMLAttributeOperator Operator
hi def link razorHTMLValue String
hi def link razorHTMLScriptError Error
hi def link razorHTMLCharacterReference SpecialChar
hi def link razorHTMLComment Comment
hi def link razorHTMLDoctype razorHTMLComment

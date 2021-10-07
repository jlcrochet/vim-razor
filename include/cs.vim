syn include @razorcsXML syntax/xml.vim

let b:current_syntax = "razorcs"

" Syntax {{{1
" Miscellaneous (low priority) {{{2
syn keyword razorcsKeywordError contained
      \ abstract as
      \ base bool break byte
      \ case catch char checked class const continue
      \ decimal default delegate do double
      \ else enum event explicit extern
      \ false finally fixed float for foreach
      \ goto
      \ if implicit in int interface internal is
      \ lock long
      \ namespace new null
      \ object operator out override
      \ params private protected public
      \ readonly ref return
      \ sbyte sealed short sizeof stackalloc static string struct switch
      \ this throw true try typeof
      \ uint ulong unchecked unsafe ushort using
      \ virtual void volatile
      \ while

" LHS {{{2
syn keyword razorcsStatement global
syn keyword razorcsStatement using nextgroup=razorcsUsingIdentifier,razorcsUsingStatic skipwhite skipnl
syn keyword razorcsUsingStatic static contained nextgroup=razorcsUsingIdentifier skipwhite skipnl
syn match razorcsUsingIdentifier /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=razorcsUsingIdentifierSeparator,razorcsUsingIdentifierAliasOperator skipwhite skipnl
syn match razorcsUsingIdentifierSeparator /\%#=1\./ contained nextgroup=razorcsUsingIdentifier skipwhite skipnl
syn match razorcsUsingIdentifierAliasOperator /\%#=1=/ contained nextgroup=razorcsRHSIdentifier skipwhite skipnl

syn keyword razorcsStatement alias nextgroup=razorcsUsingIdentifier skipwhite skipnl

syn keyword razorcsStatement class struct interface nextgroup=razorcsTypeName skipwhite skipnl
syn match razorcsTypeName /\%#=1\h\w*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGenericParameters nextgroup=razorcsTypeBlock,razorcsTypeInheritanceOperator,razorcsTypeConstraint skipwhite skipnl
syn region razorcsGenericParameters matchgroup=razorcsDelimiter start=/\%#=1</ end=/\%#=1>/ contained oneline contains=razorcsGenericParameter,razorcsModifier nextgroup=razorcsTypeBlock skipwhite skipnl
syn match razorcsGenericParameter /\%#=1\h\w*/ contained contains=razorcsKeywordError
syn match razorcsTypeInheritanceOperator /\%#=1:/ contained nextgroup=razorcsTypeInheritee,razorcsTypeInheriteeKeyword skipwhite skipnl
syn match razorcsTypeInheritee /\%#=1\h\w*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGeneric nextgroup=razorcsTypeBlock,razorcsTypeInheriteeMemberAccessOperator,razorcsTypeInheriteeComma,razorcsTypeConstraint,razorcsTypeInheriteeArguments,razorcsTypeConstraintModifier skipwhite skipnl
syn keyword razorcsTypeInheriteeKeyword contained nextgroup=razorcsTypeBlock,razorcsTypeInheriteeComma,razorcsTypeConstraint,razorcsTypeConstraintModifier skipwhite skipnl
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic
      \ class struct enum default notnull
syn match razorcsTypeConstraintModifier /\%#=1?/ contained nextgroup=razorcsTypeInheriteeMemberAccessOperator,razorcsTypeInheriteeComma,razorcsTypeConstraint skipwhite skipnl
syn keyword razorcsTypeInheriteeKeyword new contained nextgroup=razorcsTypeInheriteeArguments,razorcsTypeInheritee skipwhite skipnl
syn keyword razorcsTypeInheriteeKeyword managed unmanaged contained nextgroup=razorcsTypeBlock,razorcsTypeInheriteeComma skipwhite skipnl
syn region razorcsTypeInheriteeArguments matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsTypeVariable nextgroup=razorcsTypeBlock,razorcsTypeInheriteeComma,razorcsTypeConstraint,razorcsTypeConstraintLambdaOperator skipwhite skipnl
syn match razorcsTypeConstraintLambdaOperator /\%#=1=>/ contained nextgroup=razorcsTypeInheriteeKeyword skipwhite skipnl
syn match razorcsTypeInheriteeMemberAccessOperator /\%#=1\./ contained nextgroup=razorcsTypeInheritee,razorcsTypeInheriteeKeyword skipwhite skipnl
syn match razorcsTypeInheriteeComma /\%#=1,/ contained nextgroup=razorcsTypeInheritee,razorcsTypeInheriteeKeyword skipwhite skipnl
syn keyword razorcsTypeConstraint where contained nextgroup=razorcsTypeVariable skipwhite skipnl
syn match razorcsTypeVariable /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=razorcsTypeInheritanceOperator skipwhite skipnl
syn region razorcsTypeBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcs

syn keyword razorcsStatement record nextgroup=razorcsRecordName,razorcsRecordModifier skipwhite skipnl
syn keyword razorcsRecordModifier struct class contained nextgroup=razorcsRecordName skipwhite skipnl
syn match razorcsRecordName /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=razorcsTypeBlock,razorcsRecordProperties,razorcsTypeInheritanceOperator skipwhite skipnl
syn region razorcsRecordProperties matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsType,razorcsTypeIdentifier nextgroup=razorcsTypeBlock,razorcsTypeInheritanceOperator skipwhite skipnl

syn match razorcsDestructorSign /\%#=1\~/ contained containedin=razorcsTypeBlock nextgroup=razorcsDestructor skipwhite skipnl
syn match razorcsDestructor /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=razorcsParameters skipwhite skipnl

syn keyword razorcsStatement enum nextgroup=razorcsEnumName skipwhite skipnl
syn match razorcsEnumName /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=razorcsEnumBlock,razorcsEnumInheritanceOperator skipwhite skipnl
syn match razorcsEnumInheritanceOperator /\%#=1:/ contained nextgroup=razorcsEnumType skipwhite skipnl
syn keyword razorcsEnumType byte sbyte short ushort int uint long ulong nint nuint contained nextgroup=razorcsEnumBlock skipwhite skipnl
syn region razorcsEnumBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorcsDeclarator

syn keyword razorcsStatement namespace nextgroup=razorcsNamespaceName skipwhite skipnl
syn match razorcsNamespaceName /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=razorcsNamespaceNameSeparator,razorcsNamespaceBlock skipwhite skipnl
syn match razorcsNamespaceNameSeparator /\%#=1\./ contained nextgroup=razorcsNamespaceName skipwhite skipnl
syn region razorcsNamespaceBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcs

syn keyword razorcsStatement if switch while nextgroup=razorcsCondition skipwhite skipnl
syn region razorcsCondition matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS

syn keyword razorcsStatement else do

syn keyword razorcsCaseStatement case nextgroup=razorcsCasePatterns
syn region razorcsCasePatterns start=/\%#=1/ end=/\%#=1[,;:\])}]\@=/ contained contains=@razorcsRHS,razorcsOperator,razorcsPatternBlock,razorcsPatternKeyword,razorcsRHSTypeIdentifier

syn keyword razorcsStatement default

syn keyword razorcsStatement for foreach nextgroup=razorcsIterationExpressions skipwhite skipnl
syn region razorcsIterationExpressions matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs,razorcsIterationCondition
syn region razorcsIterationCondition start=/\%#=1;/ end=/\%#=1;/ contained contains=@razorcsRHS

syn keyword razorcsStatement break continue yield

syn keyword razorcsStatement goto nextgroup=razorcsRHSIdentifier,razorcsCaseStatement skipwhite skipnl

syn keyword razorcsStatement return throw nextgroup=@razorcsRHS skipwhite skipnl

syn keyword razorcsStatement try finally
syn keyword razorcsStatement catch nextgroup=razorcsCatchCondition skipwhite skipnl
syn region razorcsCatchCondition matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsTypeIdentifier nextgroup=razorcsOperatorKeyword skipwhite skipnl

syn keyword razorcsStatement checked unchecked

syn keyword razorcsStatement lock nextgroup=razorcsCondition skipwhite skipnl

syn keyword razorcsModifier
      \ abstract async
      \ const
      \ event explicit extern
      \ fixed
      \ implicit in internal
      \ new
      \ out override
      \ params partial private protected
      \ ref readonly
      \ sealed
      \ unsafe
      \ virtual volatile

syn keyword razorcsModifier delegate nextgroup=razorcsFunctionPointerModifier skipwhite skipnl
syn match razorcsFunctionPointerModifier /\%#=1\*/ contained nextgroup=razorcsGeneric,razorcsFunctionPointerManaged skipwhite skipnl
syn keyword razorcsFunctionPointerManaged managed unmanaged contained nextgroup=razorcsGeneric,razorcsFunctionPointerTypes skipwhite skipnl
syn region razorcsFunctionPointerTypes matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=razorcsTypeIdentifier nextgroup=razorcsGeneric skipwhite skipnl

syn keyword razorcsStatement using contained containedin=razorcsBlock nextgroup=razorcsGuardedStatement,razorcsStatement,razorcsTypeIdentifier skipwhite skipnl
syn keyword razorcsStatement fixed contained containedin=razorcsBlock nextgroup=razorcsGuardedStatement skipwhite skipnl
syn region razorcsGuardedStatement matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs

syn keyword razorcsModifier public static nextgroup=razorcsConstructor skipwhite skipnl
syn match razorcsConstructor /\%#=1\h\w*(\@=/ contained contains=razorcsKeywordError nextgroup=razorcsConstructorParameters skipwhite skipnl
syn region razorcsConstructorParameters matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsTypeIdentifier,razorcsModifier,razorcsThis,razorcsAttribute nextgroup=razorcsLambdaOperator,razorcsConstructorInheritanceOperator skipwhite skipnl
syn match razorcsConstructorInheritanceOperator /\%#=1:/ contained nextgroup=razorcsMethodConstant skipwhite skipnl
syn keyword razorcsMethodConstant this base contained nextgroup=razorcsMethodConstantParameters skipwhite skipnl
syn region razorcsMethodConstantParameters matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorcsLambdaOperator skipwhite skipnl

syn keyword razorcsOperatorModifier operator nextgroup=razorcsOperatorMethod,razorcsBooleanOperatorMethod,razorcsConversionMethod,razorcsConversionMethodKeyword skipwhite skipnl
syn match razorcsOperatorMethod /\%#=1\%(++\=\|--\=\|[~*/%&|^]\|[=!]=\|<[<=]\=\|>[>=]\=\|\.\.\)/ contained nextgroup=razorcsParameters skipwhite skipnl
syn keyword razorcsBooleanOperatorMethod true false contained nextgroup=razorcsParameters skipwhite skipnl
syn match razorcsConversionMethod /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=razorcsParameters skipwhite skipnl
syn keyword razorcsConversionMethodKeyword contained nextgroup=razorcsParameters skipwhite skipnl
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic

syn keyword razorcsType nextgroup=razorcsDeclarator,razorcsIndexerThis,razorcsMemberAccessOperator,razorcsInvocation,razorcsTypeModifier,razorcsOperatorModifier skipwhite skipnl
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic

syn keyword razorcsStatement var nextgroup=razorcsDeclarator,razorcsTupleDeclarator skipwhite skipnl
syn region razorcsTupleDeclarator matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsDeclarator nextgroup=razorcsAssignmentOperator skipwhite skipnl

syn match razorcsIdentifier /\%#=1\h\w*\%(<.\{-}>\)\=\%(?\.\@!\)\=\**\%(\[.\{-}\]\)*/ contains=razorcsGeneric,razorcsTypeModifier nextgroup=razorcsDeclarator,razorcsIndexerThis,razorcsAssignmentOperator,razorcsCompoundAssignmentOperator,razorcsMemberAccessOperator,razorcsNullForgivingOperator,razorcsInvocation,razorcsIndex,razorcsOperatorModifier,razorcsPropertyBlock skipwhite skipnl
syn region razorcsGeneric matchgroup=razorcsDelimiter start=/\%#=1</ end=/\%#=1>/ contained contains=razorcsType,razorcsTypeIdentifier,razorcsModifier nextgroup=razorcsDeclarator,razorcsIndexerThis,razorcsOperatorModifier,razorcsPropertyBlock skipwhite skipnl
syn region razorcsInvocation matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS,razorcsKeywordArgument nextgroup=razorcsInvocation,razorcsIndex,razorcsOperator skipwhite skipnl
syn region razorcsIndex matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=@razorcsRHS nextgroup=razorcsInvocation,razorcsIndex,razorcsOperator skipwhite skipnl

syn keyword razorcsConstant this base nextgroup=razorcsAssignmentOperator,razorcsCompoundAssignmentOperator,razorcsMemberAccessOperator,razorcsInvocation,razorcsIndex skipwhite skipnl

syn keyword razorcsIndexerThis this contained nextgroup=razorcsIndexerParameters skipwhite skipnl
syn region razorcsIndexerParameters matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=razorcsTypeIdentifier,razorcsModifier nextgroup=razorcsPropertyBlock,razorcsLambdaOperator skipwhite skipnl

syn match razorcsDeclarator /\%#=1\h\w*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGenericParameters nextgroup=razorcsAssignmentOperator,razorcsLambdaOperator,razorcsParameters,razorcsPropertyBlock,razorcsDeclaratorMemberAccessOperator skipwhite skipnl
syn match razorcsNotDeclarator /\%#=1\<\h\w*\%(<.\{-}>\)\=\ze\s*\./ contained containedin=razorcsDeclarator contains=razorcsGeneric
syn match razorcsDeclaratorMemberAccessOperator /\%#=1\./ contained nextgroup=razorcsDeclarator,razorcsIdentifier,razorcsIndexerThis skipwhite skipnl
syn region razorcsParameters matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsTypeIdentifier,razorcsModifier,razorcsThisModifier,razorcsTypeTuple,razorcsAttribute nextgroup=razorcsLambdaOperator,razorcsBlock,razorcsMethodTypeConstraint skipwhite skipnl
syn keyword razorcsThisModifier this contained
syn region razorcsPropertyBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorcsAccessor,razorcsModifier nextgroup=razorcsAssignmentOperator skipwhite skipnl
syn keyword razorcsAccessor get set init add remove contained nextgroup=razorcsBlock,razorcsLambdaOperator skipwhite skipnl
syn match razorcsComma /\%#=1,/ nextgroup=razorcsDeclarator skipwhite skipnl

syn match razorcsMethodTypeInheritanceOperator /\%#=1:/ contained nextgroup=razorcsMethodTypeInheritee,razorcsMethodTypeInheriteeKeyword skipwhite skipnl
syn match razorcsMethodTypeInheritee /\%#=1\h\w*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGeneric nextgroup=razorcsMethodTypeInheriteeMemberAccessOperator,razorcsMethodTypeInheriteeComma,razorcsMethodTypeConstraint,razorcsMethodTypeConstraintModifier,razorcsMethodTypeInheriteeArguments,razorcsLambdaOperator skipwhite skipnl
syn keyword razorcsMethodTypeInheriteeKeyword contained nextgroup=razorcsMethodTypeInheriteeComma,razorcsMethodTypeConstraint,razorcsMethodTypeConstraintModifier,razorcsMethodTypeConstraintLambdaOperator skipwhite skipnl
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic
      \ class struct enum default notnull
syn match razorcsMethodTypeConstraintModifier /\%#=1?/ contained nextgroup=razorcsMethodTypeInheriteeMemberAccessOperator,razorcsMethodTypeInheriteeComma,razorcsMethodTypeConstraint,razorcsLambdaOperator skipwhite skipnl
syn keyword razorcsMethodTypeInheriteeKeyword new contained nextgroup=razorcsMethodTypeInheriteeArguments,razorcsMethodTypeInheritee skipwhite skipnl
syn keyword razorcsMethodTypeInheriteeKeyword managed unmanaged contained nextgroup=razorcsMethodTypeInheriteeComma,razorcsLambdaOperator skipwhite skipnl
syn region razorcsMethodTypeInheriteeArguments matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained nextgroup=razorcsMethodTypeInheriteeComma,razorcsMethodTypeConstraint,razorcsMethodTypeConstraintLambdaOperator skipwhite skipnl
syn match razorcsMethodTypeConstraintLambdaOperator /\%#=1=>/ contained nextgroup=razorcsMethodTypeInheriteeKeyword skipwhite skipnl
syn match razorcsMethodTypeInheriteeMemberAccessOperator /\%#=1\./ contained nextgroup=razorcsMethodTypeInheritee,razorcsMethodTypeInheriteeKeyword skipwhite skipnl
syn match razorcsMethodTypeInheriteeComma /\%#=1,/ contained nextgroup=razorcsMethodTypeInheritee,razorcsMethodTypeInheriteeKeyword skipwhite skipnl
syn keyword razorcsMethodTypeConstraint where contained nextgroup=razorcsMethodTypeVariable skipwhite skipnl
syn match razorcsMethodTypeVariable /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=razorcsMethodTypeInheritanceOperator skipwhite skipnl

syn region razorcsTypeTuple matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsType,razorcsTypeTuple,razorcsIdentifier nextgroup=razorcsDeclarator skipwhite skipnl

syn region razorcsGroup matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contains=@razorcsRHS,razorcsKeywordArgument,razorcsRHSTypeIdentifier nextgroup=razorcsAssignmentOperator,razorcsMemberAccessOperator,razorcsDeclarator,razorcsInvocation,razorcsIndex,razorcsOperatorKeyword skipwhite skipnl

syn region razorcsAttribute matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contains=@razorcsRHS,razorcsAttributeSpecifier
syn keyword razorcsAttributeSpecifier field event method param property return type contained nextgroup=razorcsKeywordArgumentColon skipwhite skipnl

syn match razorcsAssignmentOperator /\%#=1=/ contained nextgroup=@razorcsRHS,razorcsRHSTypeIdentifier,razorcsInitializer skipwhite skipnl
syn match razorcsCompoundAssignmentOperator /\%#=1\%([+\-*/%^]\|&&\=\|||\=\|??\)=/ contained nextgroup=@razorcsRHS,razorcsRHSTypeIdentifier,razorcsInitializer skipwhite skipnl

syn match razorcsLambdaOperator /\%#=1=>/ contained nextgroup=@razorcsRHS,razorcsBlock skipwhite skipnl

syn match razorcsMemberAccessOperator /\%#=1?\=\./ contained nextgroup=razorcsIdentifier,razorcsConstant skipwhite skipnl
syn match razorcsMemberAccessOperator /\%#=1->/ contained nextgroup=razorcsIdentifier skipwhite skipnl
syn match razorcsMemberAccessOperator /\%#=1::/ contained nextgroup=razorcsIdentifier skipwhite skipnl

syn match razorcsNullForgivingOperator /\%#=1!/ contained nextgroup=razorcsMemberAccessOperator,razorcsInvocation,razorcsIndex skipwhite skipnl

syn match razorcsIncrementOperator /\%#=1++/
syn match razorcsDecrementOperator /\%#=1--/
syn match razorcsPointerOperator /\%#=1[*&]/

" RHS {{{2
syn cluster razorcsLiterals contains=
      \ razorcsNumber,razorcsBoolean,razorcsNull,razorcsRHSConstant,razorcsCharacter,razorcsString

syn cluster razorcsRHS contains=
      \ @razorcsLiterals,
      \ razorcsUnaryOperator,razorcsUnaryOperatorKeyword,razorcsRHSIdentifier,razorcsRHSType,
      \ razorcsRHSGroup,razorcsFunctionKeyword,razorcsRHSAttribute,razorcsLINQExpression

syn cluster razorcsOperators contains=razorcsOperator,razorcsOperatorKeyword,razorcsTernaryOperator

syn match razorcsUnaryOperator /\%#=1++\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsUnaryOperator /\%#=1--\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsUnaryOperator /\%#=1\.\./ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsUnaryOperator /\%#=1[!~*&^]/ contained nextgroup=@razorcsRHS skipwhite skipnl

syn keyword razorcsUnaryOperatorKeyword new contained containedin=razorcsBlock nextgroup=razorcsRHSIdentifier,razorcsRHSType,razorcsInitializer,razorcsRHSInvocation,razorcsRHSIndex skipwhite skipnl
syn keyword razorcsUnaryOperatorKeyword stackalloc contained nextgroup=razorcsRHSIdentifier,razorcsRHSType,razorcsInitializer,razorcsRHSIndex skipwhite skipnl
syn keyword razorcsUnaryOperatorKeyword ref out in contained nextgroup=@razorcsRHS skipwhite skipnl
syn keyword razorcsUnaryOperatorKeyword await contained containedin=razorcsBlock nextgroup=razorcsStatement,@razorcsRHS skipwhite skipnl
syn keyword razorcsUnaryOperatorKeyword async contained nextgroup=razorcsRHSTypeIdentifier,razorcsRHSType,razorcsRHSGroup skipwhite skipnl
syn keyword razorcsUnaryOperatorKeyword throw contained nextgroup=@razorcsRHS skipwhite skipnl
syn keyword razorcsUnaryOperatorKeyword static contained nextgroup=razorcsRHSType,razorcsRHSIdentifier skipwhite skipnl
syn keyword razorcsUnaryOperatorKeyword delegate contained nextgroup=razorcsFunctionPointerModifier skipwhite skipnl

syn keyword razorcsUnaryOperatorKeyword var contained nextgroup=razorcsRHSDeclarator,razorcsRHSTupleDeclarator skipwhite skipnl
syn match razorcsRHSDeclarator /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=@razorcsOperators skipwhite skipnl
syn region razorcsRHSTupleDeclarator matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsRHSDeclarator nextgroup=@razorcsOperators skipwhite skipnl

syn keyword razorcsRHSType contained nextgroup=razorcsMemberAccessOperator,razorcsRHSGroup,razorcsRHSIndex,razorcsRHSDeclarator,razorcsTypeModifier,razorcsOperatorKeyword skipwhite skipnl
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic

syn match razorcsRHSIdentifier /\%#=1\h\w*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGeneric nextgroup=@razorcsOperators,razorcsRHSInvocation,razorcsRHSIndex,razorcsInitializer,razorcsOperatorModifier skipwhite skipnl
syn region razorcsRHSInvocation matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS,razorcsKeywordArgument nextgroup=@razorcsOperators,razorcsInitializer,razorcsRHSInvocation,razorcsRHSIndex skipwhite skipnl
syn region razorcsRHSIndex matchgroup=razorcsDelimiter start=/\%#=1?\=\[/ end=/\%#=1\]/ contained contains=@razorcsRHS nextgroup=@razorcsOperators,razorcsRHSInvocation,razorcsRHSIndex,razorcsInitializer skipwhite skipnl

syn region razorcsInitializer matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcsRHS,razorcsInitializer nextgroup=@razorcsOperators skipwhite skipnl

execute g:razor#syntax#cs_numbers

syn keyword razorcsBoolean true false contained nextgroup=@razorcsOperators skipwhite skipnl
syn keyword razorcsNull null contained nextgroup=@razorcsOperators skipwhite skipnl
syn keyword razorcsRHSConstant this base contained nextgroup=@razorcsOperators,razorcsRHSInvocation,razorcsRHSIndex skipwhite skipnl

syn match razorcsCharacter /\%#=1'\%(\\\%(x\x\{1,4}\|u\x\{4}\|U\x\{8}\|.\)\|.\)'/ contained contains=razorcsEscapeSequence,razorcsEscapeSequenceError nextgroup=@razorcsOperators skipwhite skipnl

syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1"/   end=/\%#=1"/ contained oneline contains=razorcsEscapeSequence,razorcsEscapeSequenceError nextgroup=@razorcsOperators skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1$"/  end=/\%#=1"/ contained oneline contains=razorcsBraceEscape,razorcsEscapeSequence,razorcsEscapeSequenceError,razorcsStringInterpolation,razorcsStringInterpolationError nextgroup=@razorcsOperators skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1@"/  end=/\%#=1"/ contained skip=/\%#=1""/ contains=razorcsQuoteEscape nextgroup=@razorcsOperators skipwhite skipnl
syn region razorcsString matchgroup=razorcsStringDelimiter start=/\%#=1$@"/ end=/\%#=1"/ contained skip=/\%#=1""/ contains=razorcsBraceEscape,razorcsQuoteEscape,razorcsStringInterpolation,razorcsStringInterpolationError nextgroup=@razorcsOperators skipwhite skipnl

syn match razorcsStringInterpolationError /\%#=1[{}]/ contained
syn region razorcsStringInterpolation matchgroup=razorcsStringInterpolationDelimiter start=/\%#=1{/ end=/\%#=1\%(:.\{-}\)\=}/ contained oneline contains=@razorcsRHS

syn match razorcsEscapeSequenceError /\%#=1\\./ contained
syn match razorcsEscapeSequence /\%#=1\\\%(['"\\0abfnrtv]\|x\x\{1,4}\|u\x\{4}\|U\x\{8}\)/ contained

syn match razorcsQuoteEscape /\%#=1""/ contained
syn match razorcsBraceEscape /\%#=1{{/ contained
syn match razorcsBraceEscape /\%#=1}}/ contained

syn region razorcsTernaryOperator matchgroup=razorcsOperator start=/\%#=1?/ end=/\%#=1:/ contained oneline contains=@razorcsRHS nextgroup=@razorcsRHS skipwhite skipnl

syn match razorcsOperator /\%#=1!/ contained nextgroup=@razorcsOperators,razorcsRHSInvocation,razorcsRHSIndex skipwhite skipnl
syn match razorcsOperator /\%#=1!=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1=[=>]\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1[+*/%]=\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1-[>=]\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1++/ contained nextgroup=@razorcsOperators skipwhite skipnl
syn match razorcsOperator /\%#=1--/ contained nextgroup=@razorcsOperators skipwhite skipnl
syn match razorcsOperator /\%#=1<\%(<=\=\|=\)\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1>\%(>=\=\|=\)\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1&&\==\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1||\==\=/ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1??=\=/ contained nextgroup=@razorcsRHS skipwhite skipnl

syn match razorcsOperator /\%#=1\./ contained nextgroup=razorcsRHSIdentifier,razorcsRHSConstant skipwhite skipnl
syn match razorcsOperator /\%#=1\.\./ contained nextgroup=@razorcsRHS skipwhite skipnl
syn match razorcsOperator /\%#=1?\./ contained nextgroup=razorcsRHSIdentifier,razorcsRHSConstant skipwhite skipnl
syn match razorcsOperator /\%#=1::/ contained nextgroup=razorcsRHSIdentifier skipwhite skipnl

syn region razorcsRHSGroup matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS,razorcsRHSTypeIdentifier nextgroup=@razorcsRHS,@razorcsOperators skipwhite skipnl
syn match razorcsRHSTypeIdentifier /\%#=1\h\w*\%(<.\{-}>\)\=\%(?[.\[]\@!\)\=\**/ contained contains=razorcsType,razorcsKeywordError,razorcsGeneric,razorcsTypeModifier nextgroup=razorcsDeclarator,@razorcsOperators,razorcsRHSGroup,razorcsRHSIndex skipwhite skipnl

syn keyword razorcsOperatorKeyword as contained nextgroup=razorcsRHSTypeIdentifier skipwhite skipnl
syn keyword razorcsOperatorKeyword in when and or contained nextgroup=@razorcsRHS skipwhite skipnl

syn keyword razorcsOperatorKeyword is contained nextgroup=razorcsPatterns
syn region razorcsPatterns start=/\%#=1/ end=/\%#=1[,;:\])}]\@=/ contained contains=@razorcsLiterals,razorcsOperator,razorcsTernaryOperator,razorcsPatternIdentifier,razorcsPatternGroup,razorcsObjectPattern,razorcsPatternKeyword
syn match razorcsPatternIdentifier /\%#=1\h\w*\%(<.\{-}>\)\=/ contained contains=razorcsType,razorcsGeneric,razorcsKeywordError nextgroup=razorcsDeclarator,razorcsPatternKeyword,razorcsPatternGroup,razorcsRHSIndex skipwhite skipnl
syn region razorcsPatternGroup matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS,razorcsOperator,razorcsPatternGroup,razorcsPatternBlock,razorcsPatternKeyword nextgroup=razorcsDeclarator,razorcsPatternKeyword,razorcsRHSInvocation,razorcsRHSIndex skipwhite skipnl
syn keyword razorcsPatternKeyword and or not when contained
syn region razorcsObjectPattern matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorcsPatternProperty nextgroup=razorcsDeclarator,razorcsPatternKeyword skipwhite skipnl
syn match razorcsPatternProperty /\%#=1\h\w*/ contained contains=razorcsKeywordError nextgroup=razorcsPatternPropertyColon,razorcsPatternPropertyMemberAccessOperator skipwhite skipnl
syn match razorcsPatternPropertyColon /\%#=1:/ contained nextgroup=razorcsPatterns skipwhite skipnl
syn match razorcsPatternPropertyMemberAccessOperator /\%#=1\./ contained nextgroup=razorcsPatternProperty skipwhite skipnl

syn keyword razorcsOperatorKeyword switch contained nextgroup=razorcsPatternBlock skipwhite skipnl
syn region razorcsPatternBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcsLiterals,razorcsUnaryOperatorKeyword,razorcsOperator,razorcsTernaryOperator,razorcsPatternIdentifier,razorcsPatternGroup,razorcsObjectPattern,razorcsPatternKeyword nextgroup=@razorcsOperators skipwhite skipnl

syn keyword razorcsOperatorKeyword with contained nextgroup=razorcsInitializer skipwhite skipnl

syn keyword razorcsFunctionKeyword typeof default checked unchecked sizeof nameof contained nextgroup=razorcsRHSInvocation skipwhite skipnl

syn region razorcsRHSAttribute matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=@razorcsRHS,razorcsAttributeSpecifier nextgroup=@razorcsRHS,@razorcsOperators skipwhite skipnl

syn region razorcsLINQExpression start=/\%#=1\<from\>/ end=/\%#=1[)\]};]\@=/ contained transparent contains=razorcsLINQKeyword,@razorcsRHS
syn keyword razorcsLINQKeyword from into contained nextgroup=razorcsDeclarator,razorcsLINQDeclaration skipwhite skipnl
syn match razorcsLINQDeclaration /\%#=1\h\w*\%(\.\h\w*\)*\%(<.\{-}>\)\=\s\+\%(in\>\)\@!\h\w*/ contained contains=razorcsType,razorcsIdentifier
syn keyword razorcsLINQKeyword let contained nextgroup=razorcsDeclarator skipwhite skipnl
syn keyword razorcsLINQKeyword in where select orderby group by ascending descending join on equals contained

" Miscellaneous (high priority) {{{2
syn region razorcsComment matchgroup=razorcsCommentDelimiter start=/\%#=1\/\// end=/\%#=1$/ contains=razorcsTodo containedin=ALLBUT,razorcsString,razorcsComment
syn region razorcsComment matchgroup=razorcsCommentDelimiter start=/\%#=1\/\*/ end=/\%#=1\*\// contains=razorcsTodo containedin=ALLBUT,razorcsString,razorcsComment
syn region razorcsComment matchgroup=razorcsCommentDelimiter start=/\%#=1\/\/\// end=/\%#=1$/ contains=razorcsTodo,@razorcsXML containedin=ALLBUT,razorcsString,razorcsComment
syn region razorcsComment matchgroup=razorcsCommentDelimiter start=/\%#=1\/\/\*/ end=/\%#=1\*\/\// contains=razorcsTodo,@razorcsXML containedin=ALLBUT,razorcsString,razorcsComment
syn keyword razorcsTodo TODO NOTE XXX FIXME HACK TBD contained

syn match razorcsDirective /\%#=1^\s*\zs#.*/ containedin=ALLBUT,razorcsDirective,razorcsString,razorcsComment

syn match razorcsKeywordArgument /\%#=1\h\w*\ze\s*:/ contained contains=razorcsKeywordError nextgroup=razorcsKeywordArgumentColon skipwhite skipnl
syn match razorcsKeywordArgumentColon /\%#=1:/ contained nextgroup=@razorcsRHS skipwhite skipnl

syn match razorcsTypeModifier /\%#=1[*?]/ contained nextgroup=razorcsDeclarator,razorcsTypeModifier skipwhite skipnl
syn region razorcsTypeModifier matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=@razorcsRHS nextgroup=razorcsDeclarator,razorcsInitializer,razorcsTypeModifier skipwhite skipnl

syn match razorcsTypeIdentifier /\%#=1\h\w*\%(<.\{-}>\)\=?\=\**\%(\[.\{-}\]\)*/ contained contains=razorcsType,razorcsKeywordError,razorcsGeneric,razorcsTypeModifier nextgroup=razorcsDeclarator,razorcsTypeMemberAccessOperator skipwhite skipnl
syn match razorcsTypeMemberAccessOperator /\%#=1\./ contained nextgroup=razorcsTypeIdentifier skipwhite skipnl
syn match razorcsTypeMemberAccessOperator /\%#=1::/ contained nextgroup=razorcsTypeIdentifier skipwhite skipnl

syn region razorcsBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contains=@razorcs,razorHTML

" Highlighting {{{1
hi def link razorcsComment Comment
hi def link razorcsCommentDelimiter razorcsComment
hi def link razorcsTodo Todo
hi def link razorcsDirective PreProc
hi def link razorcsStatement Statement
hi def link razorcsCaseStatement razorcsStatement
hi def link razorcsUsingIdentifier Identifier
hi def link razorcsUsingIdentifierSeparator razorcsOperator
hi def link razorcsUsingIdentifierAliasOperator razorcsOperator
hi def link razorcsUsingStatic razorcsStatement
hi def link razorcsTypeName Typedef
hi def link razorcsRecordName razorcsTypeName
hi def link razorcsRecordModifier razorcsStatement
hi def link razorcsGenericParameter razorcsDeclarator
hi def link razorcsTypeInheritanceOperator razorcsOperator
hi def link razorcsTypeConstraintLambdaOperator razorcsOperator
hi def link razorcsTypeInheriteeMemberAccessOperator razorcsMemberAccessOperator
hi def link razorcsTypeConstraint razorcsStatement
hi def link razorcsTypeConstraintModifier razorcsTypeModifier
hi def link razorcsTypeInheriteeKeyword Keyword
hi def link razorcsMethodTypeInheritanceOperator razorcsTypeInheritanceOperator
hi def link razorcsMethodTypeConstraintLambdaOperator razorcsTypeConstraintLambdaOperator
hi def link razorcsMethodTypeInheriteeMemberAccessOperator razorcsTypeInheriteeMemberAccessOperator
hi def link razorcsMethodTypeConstraint razorcsTypeConstraint
hi def link razorcsMethodTypeInheriteeKeyword razorcsTypeInheriteeKeyword
hi def link razorcsMethodTypeConstraintModifier razorcsTypeConstraintModifier
hi def link razorcsTypeVariable razorcsIdentifier
hi def link razorcsEnumName Typedef
hi def link razorcsEnumInheritanceOperator razorcsOperator
hi def link razorcsEnumType razorcsType
hi def link razorcsNamespaceName Typedef
hi def link razorcsNamespaceNameSeparator razorcsOperator
hi def link razorcsDelimiter Delimiter
hi def link razorcsModifier razorcsStatement
hi def link razorcsFunctionPointerModifier razorcsTypeModifier
hi def link razorcsOperatorModifier razorcsModifier
hi def link razorcsOperatorMethod razorcsOperator
hi def link razorcsBooleanOperatorMethod razorcsBoolean
hi def link razorcsIncrementOperator razorcsOperator
hi def link razorcsDecrementOperator razorcsOperator
hi def link razorcsPointerOperator razorcsOperator
hi def link razorcsType Type
hi def link razorcsTypeModifier razorcsType
hi def link razorcsTypeIdentifier razorcsIdentifier
hi def link razorcsRHSTypeIdentifier razorcsTypeIdentifier
hi def link razorcsTypeMemberAccessOperator razorcsMemberAccessOperator
hi def link razorcsDeclarator Identifier
hi def link razorcsNotDeclarator razorcsIdentifier
hi def link razorcsDeclaratorMemberAccessOperator razorcsMemberAccessOperator
hi def link razorcsConstructor razorcsDeclarator
hi def link razorcsConstructorInheritanceOperator razorcsOperator
hi def link razorcsDestructorSign razorcsOperator
hi def link razorcsDestructor razorcsConstructor
hi def link razorcsMethodConstant razorcsConstant
hi def link razorcsConstant Constant
hi def link razorcsRHSConstant razorcsConstant
hi def link razorcsIndexerThis razorcsConstant
hi def link razorcsThisModifier razorcsConstant
hi def link razorcsOperator Operator
hi def link razorcsAssignmentOperator razorcsOperator
hi def link razorcsCompoundAssignmentOperator razorcsAssignmentOperator
hi def link razorcsMemberAccessOperator razorcsOperator
hi def link razorcsNullForgivingOperator razorcsOperator
hi def link razorcsLambdaOperator razorcsOperator
hi def link razorcsAttributeSpecifier Special
hi def link razorcsAccessor razorcsStatement
hi def link razorcsOperatorKeyword Keyword
hi def link razorcsPatternKeyword razorcsOperatorKeyword
hi def link razorcsPatternProperty razorcsIdentifier
hi def link razorcsPatternPropertyMemberAccessOperator razorcsMemberAccessOperator
hi def link razorcsUnaryOperatorKeyword razorcsOperatorKeyword
hi def link razorcsRHSDeclarator razorcsDeclarator
hi def link razorcsRHSIdentifier razorcsIdentifier
hi def link razorcsRHSType razorcsType
hi def link razorcsLINQKeyword Keyword
hi def link razorcsUnaryOperator razorcsOperator
hi def link razorcsPatternIdentifier razorcsIdentifier
hi def link razorcsFunctionKeyword Keyword
hi def link razorcsNumber Number
hi def link razorcsBoolean Boolean
hi def link razorcsNull Constant
hi def link razorcsCharacter Character
hi def link razorcsString String
hi def link razorcsStringDelimiter razorcsString
hi def link razorcsStringInterpolationDelimiter PreProc
hi def link razorcsStringInterpolationError Error
hi def link razorcsEscapeSequence PreProc
hi def link razorcsEscapeSequenceError Error
hi def link razorcsQuoteEscape razorcsEscapeSequence
hi def link razorcsBraceEscape razorcsEscapeSequence
hi def link razorcsFieldInitializer razorcsDeclarator
hi def link razorcsKeywordError Error
" }}}1

" vim:fdm=marker

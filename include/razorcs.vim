" Syntax {{{1
syn sync fromstart

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

syn match razorcsDelimiter /\%#=1,/ containedin=@razorcsExtra,razorInvocation,razorIndex
syn match razorcsDelimiter /\%#=1;/ containedin=@razorcsBlocks

syn region razorcsBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contains=@razorcs fold

" LHS {{{2
syn keyword razorcsStatement alias nextgroup=razorcsIdentifier skipwhite skipempty

syn keyword razorcsStatement class struct nextgroup=razorcsTypeName skipwhite skipempty
syn match razorcsTypeName /\%#=1\K\k*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGenericParameters nextgroup=razorcsTypeBlock,razorcsTypeInheritanceOperator,razorcsTypeConstraint,razorcsTypeConstructorParameters skipwhite skipempty
syn region razorcsTypeConstructorParameters matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsType,razorcsTypeIdentifier,razorcsModifier,razorcsCollectionExpressionOrAttributes nextgroup=razorcsTypeBlock,razorcsTypeInheritanceOperator,razorcsTypeConstraint skipwhite skipempty
syn region razorcsGenericParameters matchgroup=razorcsDelimiter start=/\%#=1</ end=/\%#=1>/ contained contains=razorcsGenericParameter,razorcsModifier nextgroup=razorcsTypeBlock skipwhite skipempty
syn match razorcsGenericParameter /\%#=1\K\k*/ contained contains=razorcsKeywordError
syn match razorcsTypeInheritanceOperator /\%#=1:/ contained nextgroup=razorcsTypeInheritee,razorcsTypeInheriteeKeyword skipwhite skipempty
syn match razorcsTypeInheritee /\%#=1\K\k*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGeneric nextgroup=razorcsTypeBlock,razorcsTypeInheriteeMemberOperator,razorcsTypeInheriteeComma,razorcsTypeConstraint,razorcsTypeInheriteeArguments,razorcsTypeConstraintModifier skipwhite skipempty
syn keyword razorcsTypeInheriteeKeyword contained nextgroup=razorcsTypeBlock,razorcsTypeInheriteeComma,razorcsTypeConstraint,razorcsTypeConstraintModifier skipwhite skipempty
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic
      \ class struct enum default notnull
syn match razorcsTypeConstraintModifier /\%#=1?/ contained nextgroup=razorcsTypeInheriteeMemberOperator,razorcsTypeInheriteeComma,razorcsTypeConstraint skipwhite skipempty
syn keyword razorcsTypeInheriteeKeyword new contained nextgroup=razorcsTypeInheriteeArguments,razorcsTypeInheritee skipwhite skipempty
syn keyword razorcsTypeInheriteeKeyword managed unmanaged contained nextgroup=razorcsTypeBlock,razorcsTypeInheriteeComma skipwhite skipempty
syn region razorcsTypeInheriteeArguments matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorcsTypeBlock,razorcsTypeInheriteeComma,razorcsTypeConstraint,razorcsTypeConstraintLambdaOperator skipwhite skipempty
syn match razorcsTypeConstraintLambdaOperator /\%#=1=>/ contained nextgroup=razorcsTypeInheriteeKeyword skipwhite skipempty
syn match razorcsTypeInheriteeMemberOperator /\%#=1\./ contained nextgroup=razorcsTypeInheritee,razorcsTypeInheriteeKeyword skipwhite skipempty
syn match razorcsTypeInheriteeComma /\%#=1,/ contained nextgroup=razorcsTypeInheritee,razorcsTypeInheriteeKeyword skipwhite skipempty
syn keyword razorcsTypeConstraint where contained nextgroup=razorcsTypeVariable skipwhite skipempty
syn match razorcsTypeVariable /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsTypeInheritanceOperator skipwhite skipempty
syn region razorcsTypeBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorcsStatement,razorcsModifier,razorcsType,razorcsTypeIdentifier,razorcsBlock,razorcsDeclaratorComma,razorcsCollectionExpressionOrAttributes,razorcsOperatorModifier,razorcsTypeTuple,razorcsConstructor fold

syn keyword razorcsStatement interface nextgroup=razorcsInterfaceName skipwhite skipempty
syn match razorcsInterfaceName /\%#=1\K\k*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGenericParameters nextgroup=razorcsTypeBlock,razorcsTypeInheritanceOperator,razorcsTypeConstraint skipwhite skipempty

syn keyword razorcsStatement record nextgroup=razorcsTypeName,razorcsRecordModifier skipwhite skipempty
syn keyword razorcsRecordModifier class struct contained nextgroup=razorcsTypeName skipwhite skipempty

syn match razorcsDestructorSign /\%#=1\~/ contained containedin=razorcsTypeBlock nextgroup=razorcsDestructor skipwhite skipempty
syn match razorcsDestructor /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsParameters skipwhite skipempty

syn keyword razorcsStatement enum nextgroup=razorcsEnumName skipwhite skipempty
syn match razorcsEnumName /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsEnumBlock,razorcsEnumInheritanceOperator skipwhite skipempty
syn match razorcsEnumInheritanceOperator /\%#=1:/ contained nextgroup=razorcsEnumType skipwhite skipempty
syn keyword razorcsEnumType byte sbyte short ushort int uint long ulong nint nuint contained nextgroup=razorcsEnumBlock skipwhite skipempty
syn region razorcsEnumBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorcsDeclarator fold

syn keyword razorcsStatement namespace nextgroup=razorcsNamespaceName skipwhite skipempty
syn match razorcsNamespaceName /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsNamespaceNameSeparator,razorcsNamespaceBlock skipwhite skipempty
syn match razorcsNamespaceNameSeparator /\%#=1\./ contained nextgroup=razorcsNamespaceName skipwhite skipempty
syn region razorcsNamespaceBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcs fold

syn keyword razorcsStatement if switch while nextgroup=razorcsCondition skipwhite skipempty
syn region razorcsCondition matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorcsBlock skipwhite skipempty

syn keyword razorcsStatement else do nextgroup=razorcsBlock skipwhite skipempty

syn keyword razorcsStatement case nextgroup=@razorcsPatterns skipwhite skipempty

syn keyword razorcsStatement default nextgroup=razorcsCaseOperator skipwhite skipempty
syn match razorcsCaseOperator /\%#=1:/ contained nextgroup=razorcsBlock skipwhite skipempty

syn keyword razorcsStatement for foreach nextgroup=razorcsIteratorExpression skipwhite skipempty
syn region razorcsIteratorExpression matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs nextgroup=razorcsBlock skipwhite skipempty

syn keyword razorcsStatement break continue yield

syn keyword razorcsStatement goto

syn keyword razorcsStatement return throw nextgroup=@razorcsRHS skipwhite skipempty

syn keyword razorcsStatement try finally nextgroup=razorcsBlock skipwhite skipempty
syn keyword razorcsStatement catch nextgroup=razorcsCatchCondition skipwhite skipempty
syn region razorcsCatchCondition matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsTypeIdentifier nextgroup=razorcsOperatorKeyword,razorcsBlock skipwhite skipempty

syn keyword razorcsStatement checked unchecked nextgroup=razorcsBlock skipwhite skipempty

syn keyword razorcsStatement lock nextgroup=razorcsCondition skipwhite skipempty

syn keyword razorcsStatement using nextgroup=razorcsGuardedStatement,razorcsStatement,razorcsIdentifier,razorcsUsingStatic skipwhite skipempty
syn keyword razorcsUsingStatic static contained nextgroup=razorcsIdentifier skipwhite skipwhite
syn keyword razorcsStatement fixed nextgroup=razorcsGuardedStatement skipwhite skipempty
syn region razorcsGuardedStatement matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcs

syn keyword razorcsOperatorModifier operator nextgroup=razorcsOperatorMethod,razorcsBooleanOperatorMethod,razorcsConversionMethod,razorcsConversionMethodKeyword skipwhite skipempty
syn match razorcsOperatorMethod /\%#=1\%(++\=\|--\=\|[~*/%&|^]\|[=!]=\|<[<=]\=\|>[>=]\=\|\.\.\)/ contained nextgroup=razorcsParameters skipwhite skipempty
syn keyword razorcsBooleanOperatorMethod true false contained nextgroup=razorcsParameters skipwhite skipempty
syn match razorcsConversionMethod /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsParameters skipwhite skipempty
syn keyword razorcsConversionMethodKeyword contained nextgroup=razorcsParameters skipwhite skipempty
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic

syn keyword razorcsType nextgroup=razorcsDeclarator,razorcsIndexerThis,razorcsMemberOperator,razorcsInvocation,razorcsTypeModifier,razorcsOperatorModifier skipwhite skipempty
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic

syn keyword razorcsStatement var nextgroup=razorcsDeclarator,razorcsTupleDeclarator skipwhite skipempty
syn region razorcsTupleDeclarator matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsDeclarator,razorcsTupleDeclarator nextgroup=razorcsAssignmentOperator skipwhite skipempty

syn match razorcsIdentifier /\%#=1\K\k*\%(<.\{-}>\)\=\%([*?]\.\@!\|\[.\{-}\]\)*/ contains=razorcsGeneric,razorcsTypeModifier nextgroup=razorcsDeclarator,razorcsIndexerThis,@razorcsOperators,razorcsInvocation,razorcsIndex,razorcsOperatorModifier,razorcsPropertyBlock skipwhite skipempty
syn region razorcsGeneric matchgroup=razorcsDelimiter start=/\%#=1</ end=/\%#=1>/ contained contains=razorcsType,razorcsTypeTuple,razorcsTypeIdentifier,razorcsModifier nextgroup=razorcsDeclarator,razorcsIndexerThis,razorcsOperatorModifier,razorcsPropertyBlock skipwhite skipempty
syn region razorcsInvocation matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorcsInvocation,razorcsIndex,@razorcsOperators skipwhite skipempty
syn region razorcsIndex matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=@razorcsRHS nextgroup=razorcsInvocation,razorcsIndex,@razorcsOperators skipwhite skipempty

syn keyword razorcsConstant this base nextgroup=@razorcsOperators,razorcsInvocation,razorcsIndex skipwhite skipempty

syn keyword razorcsIndexerThis this contained nextgroup=razorcsIndexerParameters skipwhite skipempty
syn region razorcsIndexerParameters matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=razorcsTypeIdentifier,razorcsModifier nextgroup=razorcsPropertyBlock,razorcsLambdaOperator skipwhite skipempty

syn match razorcsDeclarator /\%#=1\K\k*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGenericParameters nextgroup=razorcsAssignmentOperator,razorcsLambdaOperator,razorcsParameters,razorcsPropertyBlock,razorcsDeclaratorMemberOperator,razorcsOperatorKeyword skipwhite skipempty
syn match razorcsNotDeclarator /\%#=1\<\K\k*\%(<.\{-}>\)\=\ze\s*\./ contained containedin=razorcsDeclarator contains=razorcsGeneric
syn match razorcsDeclaratorMemberOperator /\%#=1\./ contained nextgroup=razorcsDeclarator,razorcsIdentifier,razorcsIndexerThis skipwhite skipempty
syn region razorcsParameters matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsTypeIdentifier,razorcsModifier,razorcsThisModifier,razorcsTypeTuple,razorcsCollectionExpressionOrAttributes nextgroup=razorcsLambdaOperator,razorcsBlock,razorcsMethodTypeConstraint skipwhite skipempty
syn keyword razorcsThisModifier this contained
syn region razorcsPropertyBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorcsAccessor,razorcsModifier nextgroup=razorcsAssignmentOperator skipwhite skipempty fold
syn keyword razorcsAccessor get set init add remove contained nextgroup=razorcsBlock,razorcsLambdaOperator skipwhite skipempty
syn match razorcsDeclaratorComma /\%#=1,/ nextgroup=razorcsDeclarator skipwhite skipempty

syn match razorcsMethodTypeInheritanceOperator /\%#=1:/ contained nextgroup=razorcsMethodTypeInheritee,razorcsMethodTypeInheriteeKeyword skipwhite skipempty
syn match razorcsMethodTypeInheritee /\%#=1\K\k*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGeneric nextgroup=razorcsMethodTypeInheriteeMemberOperator,razorcsMethodTypeInheriteeComma,razorcsMethodTypeConstraint,razorcsMethodTypeConstraintModifier,razorcsMethodTypeInheriteeArguments,razorcsLambdaOperator skipwhite skipempty
syn keyword razorcsMethodTypeInheriteeKeyword contained nextgroup=razorcsMethodTypeInheriteeComma,razorcsMethodTypeConstraint,razorcsMethodTypeConstraintModifier,razorcsMethodTypeConstraintLambdaOperator skipwhite skipempty
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic
      \ class struct enum default notnull
syn match razorcsMethodTypeConstraintModifier /\%#=1?/ contained nextgroup=razorcsMethodTypeInheriteeMemberOperator,razorcsMethodTypeInheriteeComma,razorcsMethodTypeConstraint,razorcsLambdaOperator skipwhite skipempty
syn keyword razorcsMethodTypeInheriteeKeyword new contained nextgroup=razorcsMethodTypeInheriteeArguments,razorcsMethodTypeInheritee skipwhite skipempty
syn keyword razorcsMethodTypeInheriteeKeyword managed unmanaged contained nextgroup=razorcsMethodTypeInheriteeComma,razorcsLambdaOperator skipwhite skipempty
syn region razorcsMethodTypeInheriteeArguments matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained nextgroup=razorcsMethodTypeInheriteeComma,razorcsMethodTypeConstraint,razorcsMethodTypeConstraintLambdaOperator skipwhite skipempty
syn match razorcsMethodTypeConstraintLambdaOperator /\%#=1=>/ contained nextgroup=razorcsMethodTypeInheriteeKeyword skipwhite skipempty
syn match razorcsMethodTypeInheriteeMemberOperator /\%#=1\./ contained nextgroup=razorcsMethodTypeInheritee,razorcsMethodTypeInheriteeKeyword skipwhite skipempty
syn match razorcsMethodTypeInheriteeComma /\%#=1,/ contained nextgroup=razorcsMethodTypeInheritee,razorcsMethodTypeInheriteeKeyword skipwhite skipempty
syn keyword razorcsMethodTypeConstraint where contained nextgroup=razorcsMethodTypeVariable skipwhite skipempty
syn match razorcsMethodTypeVariable /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsMethodTypeInheritanceOperator skipwhite skipempty

syn region razorcsTypeTuple matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsType,razorcsTypeTuple,razorcsIdentifier nextgroup=razorcsDeclarator,razorcsIndexerThis,razorcsTypeModifier,razorcsOperatorModifier skipwhite skipempty

syn region razorcsGroup matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contains=@razorcsRHS,razorcsRHSTypeIdentifier nextgroup=@razorcsOperators,razorcsDeclarator,razorcsInvocation,razorcsIndex skipwhite skipempty

syn region razorcsCollectionExpressionOrAttributes matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contains=@razorcsRHS,razorcsAttribute

syn match razorcsAssignmentOperator /\%#=1=/ contained nextgroup=@razorcsRHS,razorcsRHSTypeIdentifier,razorcsInitializer skipwhite skipempty

syn match razorcsLambdaOperator /\%#=1=>/ contained nextgroup=@razorcsRHS,razorcsBlock skipwhite skipempty

syn match razorcsMemberOperator /\%#=1?\=\./ contained nextgroup=razorcsIdentifier,razorcsConstant skipwhite skipempty
syn match razorcsMemberOperator /\%#=1->/ contained nextgroup=razorcsIdentifier skipwhite skipempty
syn match razorcsMemberOperator /\%#=1::/ contained nextgroup=razorcsIdentifier skipwhite skipempty

syn match razorcsNullForgivingOperator /\%#=1!/ contained nextgroup=razorcsMemberOperator,razorcsInvocation,razorcsIndex skipwhite skipempty

syn match razorcsIncrementOperator /\%#=1++/
syn match razorcsDecrementOperator /\%#=1--/
syn match razorcsPointerOperator /\%#=1[*&]/

" RHS {{{2
syn cluster razorcsLiterals contains=
      \ razorcsNumber,razorcsBoolean,razorcsNull,razorcsRHSConstant,razorcsCharacter,razorcsString

syn cluster razorcsRHS contains=
      \ @razorcsLiterals,
      \ razorcsUnaryOperator,razorcsUnaryOperatorKeyword,razorcsRHSIdentifier,razorcsRHSType,
      \ razorcsRHSGroup,razorcsCollectionExpressionOrAttributes,razorcsLINQExpression

syn cluster razorcsOperators contains=razorcsOperator,razorcsOperatorKeyword,razorcsComment

syn match razorcsUnaryOperator /\%#=1++\=/ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsUnaryOperator /\%#=1--\=/ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsUnaryOperator /\%#=1\.\./ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsUnaryOperator /\%#=1[!~*&^]/ contained nextgroup=@razorcsRHS skipwhite skipempty

syn keyword razorcsUnaryOperatorKeyword new nextgroup=razorcsRHSIdentifier,razorcsRHSType,razorcsInitializer,razorcsRHSInvocation,razorcsRHSIndex skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword stackalloc nextgroup=razorcsRHSIdentifier,razorcsRHSType,razorcsInitializer,razorcsRHSIndex skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword out in contained nextgroup=@razorcsRHS skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword ref contained nextgroup=@razorcsRHS,razorcsReadonly skipwhite skipempty
syn keyword razorcsReadonly readonly contained nextgroup=@razorcsRHS skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword await nextgroup=razorcsStatement,@razorcsRHS skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword async params contained nextgroup=razorcsRHSTypeIdentifier,razorcsRHSType,razorcsRHSGroup skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword throw nextgroup=@razorcsRHS skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword static contained nextgroup=razorcsRHSType,razorcsRHSIdentifier skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword delegate contained nextgroup=razorcsFunctionPointerModifier skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword not contained nextgroup=@razorcsPatterns skipwhite skipempty

syn keyword razorcsUnaryOperatorKeyword default contained nextgroup=razorcsRHSInvocation,@razorcsOperators skipwhite skipempty
syn keyword razorcsUnaryOperatorKeyword typeof checked unchecked sizeof nameof contained nextgroup=razorcsRHSInvocation skipwhite skipempty

syn keyword razorcsUnaryOperatorKeyword var contained nextgroup=razorcsRHSDeclarator,razorcsRHSTupleDeclarator skipwhite skipempty
syn match razorcsRHSDeclarator /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=@razorcsOperators skipwhite skipempty
syn region razorcsRHSTupleDeclarator matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsRHSDeclarator nextgroup=@razorcsOperators skipwhite skipempty

syn keyword razorcsRHSType contained nextgroup=razorcsMemberOperator,razorcsRHSGroup,razorcsRHSIndex,razorcsRHSDeclarator,razorcsTypeModifier,razorcsOperatorKeyword skipwhite skipempty
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic

syn match razorcsRHSIdentifier /\%#=1\K\k*\%(<.\{-}>\)\=/ contained contains=razorcsKeywordError,razorcsGeneric nextgroup=@razorcsOperators,razorcsRHSInvocation,razorcsRHSIndex,razorcsInitializer,razorcsOperatorModifier skipwhite skipempty
syn region razorcsRHSInvocation matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=@razorcsOperators,razorcsInitializer,razorcsRHSInvocation,razorcsRHSIndex skipwhite skipempty
syn region razorcsRHSIndex matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=@razorcsRHS nextgroup=@razorcsOperators,razorcsRHSInvocation,razorcsRHSIndex,razorcsInitializer skipwhite skipempty

syn region razorcsInitializer matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcsRHS,razorcsInitializer,razorcsIndexSetter nextgroup=@razorcsOperators skipwhite skipempty

syn match razorcsNumber /\%#=1\c\d\+\%(_\+\d\+\)*\%(\%(lu\=\|ul\=\)\|[dmf]\|\.\d\+\%(_\+\d\+\)*\%(e[+-]\=\d\+\%(_\+\d\+\)*\)\=[dmf]\=\|e[+-]\=\d\+\%(_\+\d\+\)*[dmf]\=\)\=/ contained nextgroup=@razorcsOperators skipwhite skipempty
syn match razorcsNumber /\%#=1\c0b_*[01]\+\%(_\+[01]\+\)*\%(lu\=\|ul\=\)\=/ contained nextgroup=@razorcsOperators skipwhite skipempty
syn match razorcsNumber /\%#=1\c0x_*\x\+\%(_\+\x\+\)*\%(\%(lu\=\|ul\=\)\|[dmf]\|e[+-]\=\d\+\%(_\+\d\+\)*[dmf]\=\)\=/ contained nextgroup=@razorcsOperators skipwhite skipempty
syn match razorcsNumber /\%#=1\c\.\d\+\%(_\+\d\+\)*\%(e[+-]\=\d\+\%(_\+\d\+\)*\)\=[dmf]\=/ contained nextgroup=@razorcsOperators skipwhite skipempty

syn keyword razorcsBoolean true false contained nextgroup=@razorcsOperators skipwhite skipempty
syn keyword razorcsNull null contained nextgroup=@razorcsOperators skipwhite skipempty
syn keyword razorcsRHSConstant this base contained nextgroup=@razorcsOperators,razorcsRHSInvocation,razorcsRHSIndex skipwhite skipempty

syn region razorcsCharacter matchgroup=razorcsCharacterDelimiter start=/\%#=1'/ end=/\%#=1'/ contained contains=razorcsEscapeSequence,razorcsEscapeSequenceError nextgroup=@razorcsOperators skipwhite skipempty

syn region razorcsString matchgroup=razorcsStringStart start=/\%#=1"/               matchgroup=razorcsStringEnd end=/\%#=1"\%(u8\)\=/   contained contains=razorcsEscapeSequence,razorcsEscapeSequenceError nextgroup=@razorcsOperators skipwhite skipempty
syn region razorcsString matchgroup=razorcsStringStart start=/\%#=1\$"/             matchgroup=razorcsStringEnd end=/\%#=1"\%(u8\)\=/   contained contains=razorcsBraceEscape,razorcsEscapeSequence,razorcsEscapeSequenceError,razorcsStringInterpolation,razorcsStringInterpolationError nextgroup=@razorcsOperators skipwhite skipempty
syn region razorcsString matchgroup=razorcsStringStart start=/\%#=1@"/              matchgroup=razorcsStringEnd end=/\%#=1"\%(u8\)\=/   contained skip=/\%#=1""/ contains=razorcsQuoteEscape nextgroup=@razorcsOperators skipwhite skipempty
syn region razorcsString matchgroup=razorcsStringStart start=/\%#=1\$@"/            matchgroup=razorcsStringEnd end=/\%#=1"\%(u8\)\=/   contained skip=/\%#=1""/ contains=razorcsQuoteEscape,razorcsBraceEscape,razorcsStringInterpolation,razorcsStringInterpolationError nextgroup=@razorcsOperators skipwhite skipempty
syn region razorcsString matchgroup=razorcsStringStart start=/\%#=1@\$"/            matchgroup=razorcsStringEnd end=/\%#=1"\%(u8\)\=/   contained skip=/\%#=1""/ contains=razorcsQuoteEscape,razorcsBraceEscape,razorcsStringInterpolation,razorcsStringInterpolationError nextgroup=@razorcsOperators skipwhite skipempty
syn region razorcsString matchgroup=razorcsStringStart start=/\%#=1\z("\{3,}\)/     matchgroup=razorcsStringEnd end=/\%#=1\z1\%(u8\)\=/ contained nextgroup=@razorcsOperators skipwhite skipempty
syn region razorcsString matchgroup=razorcsStringStart start=/\%#=1\$\+\z("\{3,}\)/ matchgroup=razorcsStringEnd end=/\%#=1\z1\%(u8\)\=/ contained contains=razorcsBraceEscape,razorcsStringInterpolation,razorcsStringInterpolationError nextgroup=@razorcsOperators skipwhite skipempty

syn match razorcsStringInterpolationError /\%#=1[{}]/ contained
syn region razorcsStringInterpolation matchgroup=razorcsStringInterpolationDelimiter start=/\%#=1{/ end=/\%#=1\%([,:].\{-}\)\=}/ contained contains=@razorcsRHS

syn match razorcsEscapeSequenceError /\%#=1\\./ contained
syn match razorcsEscapeSequence /\%#=1\\\%(['"\\0abfnrtv]\|x\x\{1,4}\|u\x\{4}\|U\x\{8}\)/ contained

syn match razorcsQuoteEscape /\%#=1""/ contained
syn match razorcsBraceEscape /\%#=1{{/ contained
syn match razorcsBraceEscape /\%#=1}}/ contained

syn match razorcsOperator /\%#=1!/ contained nextgroup=@razorcsOperators,razorcsRHSInvocation,razorcsRHSIndex skipwhite skipempty
syn match razorcsOperator /\%#=1=/ contained nextgroup=@razorcsRHS,razorcsInitializer skipwhite skipempty
syn match razorcsOperator /\%#=1[=!]=/ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsOperator /\%#=1[+*/%]=\=/ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsOperator /\%#=1=>/ contained nextgroup=@razorcsRHS,razorcsBlock skipwhite skipempty
syn match razorcsOperator /\%#=1-[>=]\=/ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsOperator /\%#=1++/ contained nextgroup=@razorcsOperators skipwhite skipempty
syn match razorcsOperator /\%#=1--/ contained nextgroup=@razorcsOperators skipwhite skipempty
syn match razorcsOperator /\%#=1<<\==\=/ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsOperator /\%#=1>>\=>\==\=/ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsOperator /\%#=1&&\==\=/ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsOperator /\%#=1||\==\=/ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsOperator /\%#=1?\%(?=\=\)\=/ contained nextgroup=@razorcsRHS skipwhite skipempty

syn match razorcsOperator /\%#=1\./ contained nextgroup=razorcsRHSIdentifier,razorcsRHSConstant skipwhite skipempty
syn match razorcsOperator /\%#=1\.\./ contained nextgroup=@razorcsRHS skipwhite skipempty
syn match razorcsOperator /\%#=1?\./ contained nextgroup=razorcsRHSIdentifier,razorcsRHSConstant skipwhite skipempty
syn match razorcsOperator /\%#=1:/ contained nextgroup=@razorcsRHS,razorcsStatement skipwhite skipempty
syn match razorcsOperator /\%#=1::/ contained nextgroup=razorcsRHSIdentifier skipwhite skipempty

syn region razorcsRHSGroup matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS,razorcsRHSTypeIdentifier nextgroup=@razorcsRHS,@razorcsOperators skipwhite skipempty
syn match razorcsRHSTypeIdentifier /\%#=1\K\k*\%(<.\{-}>\)\=\%([*?]\.\@!\|\[.\{-}\]\)*/ contained contains=razorcsType,razorcsKeywordError,razorcsGeneric,razorcsTypeModifier nextgroup=@razorcsOperators,razorcsRHSGroup,razorcsRHSIndex,razorcsDeclarator skipwhite skipempty

syn keyword razorcsOperatorKeyword as contained nextgroup=razorcsRHSTypeIdentifier skipwhite skipempty
syn keyword razorcsOperatorKeyword in when contained nextgroup=@razorcsRHS skipwhite skipempty
syn keyword razorcsOperatorKeyword and or contained nextgroup=@razorcsPatterns skipwhite skipempty

syn keyword razorcsOperatorKeyword is contained nextgroup=@razorcsPatterns skipwhite skipempty
syn keyword razorcsOperatorKeyword switch contained nextgroup=razorcsPatternBlock skipwhite skipempty
syn region razorcsPatternBlock matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@razorcsPatterns nextgroup=@razorcsOperators skipwhite skipempty fold

syn cluster razorcsPatterns contains=razorcsPatternType,razorcsPatternTypeIdentifier,razorcsUnaryOperatorKeyword,@razorcsLiterals,razorcsOperator,razorcsPatternGroup,razorcsPatternProperties,razorcsPatternList

syn keyword razorcsPatternType contained nextgroup=razorcsPatternDeclarator,razorcsPatternTypeMemberOperator,razorcsPatternGroup,razorcsPatternProperties,razorcsOperatorKeyword skipwhite skipempty
      \ sbyte short int long byte ushort uint ulong float double decimal nint nuint
      \ char bool object string void dynamic

syn match razorcsPatternTypeIdentifier /\%#=1\K\k*\%(<.\{-}>\)\=/ contained contains=razorcsGeneric,razorcsKeywordError nextgroup=razorcsPatternDeclarator,razorcsLambdaOperator,razorcsPatternTypeMemberOperator,razorcsPatternGroup,razorcsPatternProperties,razorcsOperatorKeyword skipwhite skipempty

syn match razorcsPatternTypeMemberOperator /\%#=1\./ contained nextgroup=razorcsPatternTypeIdentifier skipwhite skipempty

syn match razorcsPatternDeclarator /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=@razorcsOperators skipwhite skipempty

syn region razorcsPatternGroup matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsPatterns nextgroup=@razorcsOperators,razorcsPatternDeclarator,razorcsPatternProperties skipwhite skipempty

syn region razorcsPatternProperties matchgroup=razorcsDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=razorcsPatternProperty nextgroup=@razorcsOperators,razorcsPatternDeclarator skipwhite skipempty
syn match razorcsPatternProperty /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsPatternPropertyColon,razorcsPatternPropertyMemberOperator skipwhite skipempty
syn match razorcsPatternPropertyColon /\%#=1:/ contained nextgroup=@razorcsPatterns skipwhite skipempty
syn match razorcsPatternPropertyMemberOperator /\%#=1\./ contained nextgroup=razorcsPatternProperty skipwhite skipempty

syn region razorcsPatternList matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1]/ contained contains=@razorcsPatterns,razorcsPatternSlice,razorcsPatternListVar nextgroup=@razorcsOperators skipwhite skipempty
syn match razorcsPatternSlice /\%#=1\.\./ contained
syn keyword razorcsPatternListVar var contained nextgroup=razorcsPatternListDeclarator skipwhite skipempty
syn match razorcsPatternListDeclarator /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsPatternListDeclaratorComma skipwhite skipempty
syn match razorcsPatternListDeclaratorComma /\%#=1,/ contained nextgroup=razorcsPatternListDeclarator skipwhite skipempty

syn keyword razorcsOperatorKeyword with contained nextgroup=razorcsInitializer skipwhite skipempty

syn region razorcsIndexSetter matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1]/ contained contains=@razorcsRHS nextgroup=razorcsAssignmentOperator skipwhite skipempty

syn region razorcsLINQExpression start=/\%#=1\<from\>/ end=/\%#=1[)\]};]\@=/ contained transparent contains=razorcsLINQKeyword,@razorcsRHS
syn keyword razorcsLINQKeyword from into contained nextgroup=razorcsLINQDeclarator,razorcsLINQDeclaration skipwhite skipempty
syn match razorcsLINQDeclaration /\%#=1\K\k*\%(\.\K\k*\)*\%(<.\{-}>\)\=\s\+\%(in\>\)\@!\K\k*/ contained contains=razorcsType,razorcsIdentifier
syn keyword razorcsLINQKeyword let join contained nextgroup=razorcsLINQDeclarator skipwhite skipempty
syn keyword razorcsLINQKeyword in where select orderby group by ascending descending on equals contained
syn match razorcsLINQDeclarator /\%#=1\K\k*/ contained contains=razorcsKeywordError nextgroup=razorcsAssignmentOperator skipwhite skipempty

" Miscellaneous (high priority) {{{2
syn region razorcsComment matchgroup=razorcsCommentStart start=/\%#=1\/\// end=/\%#=1$/ contains=razorcsTodo containedin=@razorcsExtra
syn region razorcsComment matchgroup=razorcsCommentStart start=/\%#=1\/\*/ matchgroup=razorcsCommentEnd end=/\%#=1\*\// contains=razorcsTodo containedin=@razorcsExtra
syn region razorcsComment matchgroup=razorcsCommentStart start=/\%#=1\/\/\// end=/\%#=1$/ keepend contains=razorcsTodo,razorcsXMLTagStart containedin=@razorcsExtra
syn keyword razorcsTodo TODO NOTE XXX FIXME HACK TBD contained

syn match razorcsXMLTagStart /\%#=1<\/\=/ contained nextgroup=razorcsXMLTagName
syn match razorcsXMLTagName /\%#=1\a[^[:space:]\>]*/ contained nextgroup=razorcsXMLAttribute,razorcsXMLTagEnd skipwhite
syn match razorcsXMLAttribute /\%#=1[^>/=[:space:]]\+/ contained nextgroup=razorcsXMLAttributeOperator,razorcsXMLTagEnd skipwhite
syn match razorcsXMLAttributeOperator /\%#=1=/ contained nextgroup=razorcsXMLValue skipwhite
syn region razorcsXMLValue matchgroup=razorcsXMLValueDelimiter start=/\%#=1"/ end=/\%#=1"/ contained nextgroup=razorcsXMLTagEnd skipwhite
syn region razorcsXMLValue matchgroup=razorcsXMLValueDelimiter start=/\%#=1'/ end=/\%#=1'/ contained nextgroup=razorcsXMLTagEnd skipwhite
syn match razorcsXMLTagEnd /\%#=1\/\=>/ contained

syn match razorcsDirective /\%#=1#.*/ containedin=@razorcsBlocks
syn region razorcsRegion matchgroup=razorcsDirective start=/\%#=1#region\>.*/ end=/\%#=1#endregion\>.*/ containedin=@razorcsBlocks,razorcsRegion transparent fold

syn match razorcsTypeModifier /\%#=1[*?]/ contained nextgroup=razorcsDeclarator,razorcsTypeModifier skipwhite skipempty
syn region razorcsTypeModifier matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=@razorcsRHS nextgroup=razorcsDeclarator,razorcsInitializer,razorcsTypeModifier skipwhite skipempty

syn match razorcsTypeIdentifier /\%#=1\K\k*\%(<.\{-}>\)\=\%([*?]\.\@!\|\[.\{-}\]\)*/ contained contains=razorcsType,razorcsKeywordError,razorcsGeneric,razorcsTypeModifier nextgroup=razorcsDeclarator,razorcsIndexerThis,razorcsTypeMemberOperator,razorcsOperatorModifier skipwhite skipempty
syn match razorcsTypeMemberOperator /\%#=1\./ contained nextgroup=razorcsTypeIdentifier skipwhite skipempty
syn match razorcsTypeMemberOperator /\%#=1::/ contained nextgroup=razorcsTypeIdentifier skipwhite skipempty

syn match razorcsConstructor /\%#=1\K\k*(\@=/ contained contains=razorcsKeywordError nextgroup=razorcsConstructorParameters
syn region razorcsConstructorParameters matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=razorcsType,razorcsTypeIdentifier,razorcsModifier,razorcsCollectionExpressionOrAttributes nextgroup=razorcsLambdaOperator,razorcsConstructorInheritanceOperator skipwhite skipempty
syn match razorcsConstructorInheritanceOperator /\%#=1:/ contained nextgroup=razorcsMethodConstant skipwhite skipempty
syn keyword razorcsMethodConstant this base contained nextgroup=razorcsMethodConstantParameters skipwhite skipempty
syn region razorcsMethodConstantParameters matchgroup=razorcsDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@razorcsRHS nextgroup=razorcsLambdaOperator skipwhite skipempty

syn match razorcsAttribute /\%#=1\K\k*/ contained nextgroup=@razorcsOperators skipwhite skipempty

syn keyword razorcsModifier nextgroup=razorcsModifier,razorcsType,razorcsTypeIdentifier,razorcsStatement skipwhite skipempty
      \ abstract async
      \ const
      \ event explicit extern
      \ fixed
      \ implicit in internal
      \ new
      \ out override
      \ params partial private protected public
      \ ref readonly required
      \ sealed static
      \ unsafe
      \ virtual volatile

syn keyword razorcsModifier delegate nextgroup=razorcsFunctionPointerModifier,razorcsModifier,razorcsType,razorcsTypeIdentifier,razorcsStatement skipwhite skipempty
syn match razorcsFunctionPointerModifier /\%#=1\*/ contained nextgroup=razorcsGeneric,razorcsFunctionPointerManaged skipwhite skipempty
syn keyword razorcsFunctionPointerManaged managed unmanaged contained nextgroup=razorcsGeneric,razorcsFunctionPointerTypes skipwhite skipempty
syn region razorcsFunctionPointerTypes matchgroup=razorcsDelimiter start=/\%#=1\[/ end=/\%#=1\]/ contained contains=razorcsTypeIdentifier nextgroup=razorcsGeneric skipwhite skipempty

syn cluster razorcsBlocks contains=razorcs\a\{-}Block

syn cluster razorcsExtra contains=
      \ ALLBUT,
      \ razorcsString,razorcsCharacter,razorcsComment,razorcsXMLTagName,razorcsXMLAttribute,razorcsXMLValue,
      \ razorcsDirective,razorcsEscapeSequenceError,
      \ razorcs\a\{-}Comma

" Highlighting {{{1
hi def link razorcsComment Comment
hi def link razorcsCommentStart razorcsComment
hi def link razorcsCommentEnd razorcsCommentStart
hi def link razorcsTodo Todo
hi def link razorcsDirective PreProc
hi def link razorcsStatement Statement
hi def link razorcsTypeName Typedef
hi def link razorcsInterfaceName razorcsTypeName
hi def link razorcsRecordModifier razorcsStatement
hi def link razorcsGenericParameter razorcsDeclarator
hi def link razorcsTypeInheritanceOperator razorcsOperator
hi def link razorcsTypeConstraintLambdaOperator razorcsOperator
hi def link razorcsTypeInheriteeMemberOperator razorcsMemberOperator
hi def link razorcsTypeConstraint razorcsStatement
hi def link razorcsTypeConstraintModifier razorcsTypeModifier
hi def link razorcsTypeInheriteeKeyword Keyword
hi def link razorcsMethodTypeInheritanceOperator razorcsTypeInheritanceOperator
hi def link razorcsMethodTypeConstraintLambdaOperator razorcsTypeConstraintLambdaOperator
hi def link razorcsMethodTypeInheriteeMemberOperator razorcsTypeInheriteeMemberOperator
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
hi def link razorcsModifier Keyword
hi def link razorcsFunctionPointerModifier razorcsTypeModifier
hi def link razorcsOperatorModifier razorcsModifier
hi def link razorcsOperatorMethod razorcsOperator
hi def link razorcsBooleanOperatorMethod razorcsBoolean
hi def link razorcsConversionMethodKeyword razorcsType
hi def link razorcsIncrementOperator razorcsOperator
hi def link razorcsDecrementOperator razorcsOperator
hi def link razorcsPointerOperator razorcsOperator
hi def link razorcsType Type
hi def link razorcsTypeModifier razorcsOperator
hi def link razorcsTypeIdentifier razorcsIdentifier
hi def link razorcsRHSTypeIdentifier razorcsTypeIdentifier
hi def link razorcsTypeMemberOperator razorcsMemberOperator
hi def link razorcsDeclarator Identifier
hi def link razorcsNotDeclarator razorcsIdentifier
hi def link razorcsDeclaratorMemberOperator razorcsMemberOperator
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
hi def link razorcsMemberOperator razorcsOperator
hi def link razorcsNullForgivingOperator razorcsOperator
hi def link razorcsLambdaOperator razorcsOperator
hi def link razorcsAccessor razorcsStatement
hi def link razorcsOperatorKeyword Keyword
hi def link razorcsUnaryOperatorKeyword razorcsOperatorKeyword
hi def link razorcsRHSDeclarator razorcsDeclarator
hi def link razorcsRHSIdentifier razorcsIdentifier
hi def link razorcsRHSType razorcsType
hi def link razorcsLINQKeyword Keyword
hi def link razorcsUnaryOperator razorcsOperator
hi def link razorcsNumber Number
hi def link razorcsBoolean Boolean
hi def link razorcsNull Constant
hi def link razorcsCharacter Character
hi def link razorcsCharacterDelimiter razorcsDelimiter
hi def link razorcsString String
hi def link razorcsStringStart razorcsDelimiter
hi def link razorcsStringEnd razorcsStringStart
hi def link razorcsStringInterpolationDelimiter razorcsDelimiter
hi def link razorcsStringInterpolationError Error
hi def link razorcsEscapeSequence SpecialChar
hi def link razorcsEscapeSequenceError Error
hi def link razorcsQuoteEscape razorcsEscapeSequence
hi def link razorcsBraceEscape razorcsEscapeSequence
hi def link razorcsKeywordError Error
hi def link razorcsAttribute razorcsIdentifier
hi def link razorcsAttributeDelimiter razorcsDelimiter
hi def link razorcsXMLTagStart Delimiter
hi def link razorcsXMLTagName Special
hi def link razorcsXMLTagEnd razorcsXMLTagStart
hi def link razorcsXMLAttribute Keyword
hi def link razorcsXMLAttributeOperator Operator
hi def link razorcsXMLValue String
hi def link razorcsXMLValueDelimiter razorcsDelimiter
hi def link razorcsPatternType razorcsType
hi def link razorcsPatternTypeIdentifier razorcsTypeIdentifier
hi def link razorcsPatternTypeMemberOperator razorcsMemberOperator
hi def link razorcsPatternDeclarator razorcsDeclarator
hi def link razorcsPatternPropertyMemberOperator razorcsMemberOperator
hi def link razorcsPatternSlice razorcsOperator
hi def link razorcsDeclaratorComma razorcsDelimiter
hi def link razorcsTypeInheriteeComma razorcsDeclaratorComma
hi def link razorcsCaseOperator razorcsOperator
hi def link razorcsLINQDeclarator razorcsDeclarator
hi def link razorcsFunctionPointerManaged razorcsModifier
hi def link razorcsPatternListVar razorcsStatement
hi def link razorcsPatternListDeclarator razorcsDeclarator
hi def link razorcsPatternListDeclaratorComma razorcsDeclaratorComma
hi def link razorcsReadonly razorcsUnaryOperatorKeyword
hi def link razorcsUsingStatic razorcsModifier
" }}}1

" vim:fdm=marker

if exists("b:current_syntax")
    finish
endif

syn match u8varname "^[^=]*" nextgroup=u8op skipwhite
syn match u8op "=" nextgroup=u8text skipwhite
syn region u8text start='"' end='"' contains=u8arg,u8spec,u8color,u8line,u8colorreg
syn region u8colorreg start='\\^[0-9a-fA-F]\{6}' end='\^^' contained
syn match u8note "#.*$"

"syn match u8colorin "\\^[0-9a-fA-F]{6}" contained
syn match u8line "\\n" contained
syn match u8line "\\m[0-9]\.[0-9]" contained
syn match u8arg "\\[0-9]" contained
syn match u8spec "\\s." contained

let b:current_syntax = "cug-utf8"

hi def link u8varname Identifier
hi def link u8op Operator
hi def link u8note Comment
hi def link u8text String
hi def link u8colorreg Type
"hi def link u8colorin Type
hi def link u8line Underlined
hi def link u8spec Type
hi def link u8arg PreProc

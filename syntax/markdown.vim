" markdown syntax
" (Pandoc is used as a reference, but it's not fully supported.)
" + polyphony, a markdown syntax extension
"
" thjbdvlt (2024). License MIT

" a cluster with stuff in which markdown isn't active
syn cluster NoMD contains=Comment,Code,YamlFrontMatter,LinkDef
syn region String start="^>.*" end="\n\n" contains=EmphasisString,Class keepend
syn match Citation "\[[^\[\]]*@[^\[\]]*\]" containedin=ALLBUT,@NoMD keepend
syn match CitationKey "@[a-zÀ-ÿ0-9_]\+" containedin=ALLBUT,@NoMD,Example contains=@NoSpell conceal cchar=@
syn region CitationText start=/\[\@1<=.\?/ end=/.\?\]\@=/ containedin=Citation contained conceal cchar=@
syn match FootnoteCall /.\@<=\[\^\S\+\]/ contains=@NoSpell conceal cchar=¶
syn region _Footnote start=/^\[\^\S\+\]:/ end=/$/
syn match Footnote /^\[\^\S\+\]:/ containedin=_Footnote contained contains=@NoSpell conceal cchar=¶
syn region FootnoteText start=/:\@<=./ end=/$/ containedin=_Footnote contained
syn region FootnoteText matchgroup=Footnote start=/\^\[/ end=/\]/ containedin=ALLBUT,@NoMD keepend
syn region FootnoteText start=/\[\@<=.\?/ end=/.\?\]\@=/ contained keepend
syn match Struct /|/ keepend containedin=ALLBUT,@NoMD,Rule
syn match Rule /^---\+$/
syn match Rule /^===\+$/
syn match Rule /|[-|=:]\+|/ keepend containedin=ALLBUT,@NoMD
syn match Example /(@[a-z]*)/ contains=@NoSpell containedin=ALLBUT,@NoMD
syn region LinkDef start=/^\[[^^\]]*\]:/ end=/$/ contains=@NoSpell
syn match _Url "\[[^\]]\+\]([^)]\+)" keepend
syn region Hypertext matchgroup=Struct start=/\[/ end=/\]/ containedin=_Url contained keepend
syn region Url matchgroup=Struct start=/\]\@<=(/ end=/)/ contained conceal cchar=/
syn region Url matchgroup=Struct start=/(/ end=/)/ containedin=_Url contained conceal cchar=/
syn match Url "<\?https\?://\S\+" contains=@NoSpell containedin=ALLBUT,@NoMD,URL keepend
syn region Emphasis start=/\*/ skip=/\\\*/ end=/\*/ contains=@NoSpell keepend
syn region Emphasis start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@=" skip="\\_" end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@=" contains=@NoSpell
syn region EmphasisString start="\*" skip="\\\*" end="\*" contains=@NoSpell containedin=String contained keepend
syn region EmphasisParenthese start="\*" skip="\\\*" end="\*" contains=@NoSpell containedin=Parenthese contained keepend
syn region EmphasisFootnoteText start="\*" skip="\\\*" end="\*" contains=@NoSpell containedin=FootnoteText contained keepend
syn region EmphasisTitle start="\*" skip="\\\*" end="\*" contains=@NoSpell containedin=Title contained keepend
syn region Strong start="\S\@<=__\|__\S\@=" skip="\\__" end="\S\@<=__\|__\S\@="
syn region Code matchgroup=CodeDelimiter start=/`/ end=/`/ contains=@NoSpell containedin=ALLBUT,@NoMD
syn region YamlFrontmatter matchgroup=Struct start=/\%1l^---$/ end=/^---$/ contains=@NoSpell
syn match YamlKey "^[^: ]\+:" containedin=YamlFrontMatter contained contains=@NoSpell
syn match ListItem "^\s*[\-\+\*] \|^\s*\d\+\."
syn match Concept "[^\n]\+\n\n\?:\@=" containedin=ALLBUT,@NoMD
syn region Definition start=/^:/ end=/$/ containedin=ALLBUT,@NoMD
syn region Code matchgroup=CodeDelimiter start=/^```\S\+/ end=/^```$/ contains=@NoSpell keepend
syn match Title /^.\+\n-\+$/ contains=TitleRule
syn match Title /^.\+\n=\+$/ contains=TitleRule
syn match Title /^#\+ .*/ contains=TitleRule
syn match TitleRule /^[=-]\+$/ contained
syn match TitleRule /^#\+/ contained
syn match FencedDiv /^:::.*$/ contains=@NoSpell containedin=NONE keepend
syn match _Class /\[[^\[\]]*\]{\.[a-z]\+}/ contains=@NoSpell keepend
syn region ClassText matchgroup=_Class start=/\[/ end=/\]/ containedin=_Class keepend contained
syn region ClassName matchgroup=_Class start=/{\./ end=/}/ containedin=_Class keepend contained contains=@NoSpell conceal cchar=|
syn region Super matchgroup=SuperSign start=/\^\@=\S/ end=/\^/ contains=@NoSpell containedin=Normal,String,FootnoteText oneline keepend
syn region Sub matchgroup=SubSign start=/\~\@=\S/ end=/\~/ contains=@NoSpell containedin=Normal,String,FootnoteText oneline keepend
syn region Mark matchgroup=Struct start=/==/ end=/==/ containedin=ALLBUT,@NoMD
syn region Comment start=/<!--/ end=/-->/ containedin=ALLBUT,@NoMD keepend
syn match htmlTag "<[a-z]\+\( [^>]\+\)*/\?>" contains=@NoSpell,htmlAttr keepend
syn match htmlTag "</[a-z]\+>" contains=@NoSpell,htmlAttr keepend
syn region htmlAttr start=/ \@<=[a-z]\+=\"/ skip=/\\"/ end=/"/ containedin=htmlTag contained contains=@NoSpell keepend
syn region htmlAttrVal start=/"/ skip=/\\"/ end=/"/ containedin=htmlAttr contains=@NoSpell contained

" i define a few specific highlights by default
hi def Emphasis cterm=italic gui=italic
hi def Strong cterm=bold gui=bold

" the other groups are linked to existing groups
hi def link Struct Statement
hi def link Code Type
hi def link Citation Struct
hi def link CitationText Constant
hi def link CitationKey Underlined
hi def link Footnote Struct
hi def link FootnoteCall Struct
hi def link FootnoteText Constant
hi def link Super Constant
hi def link SuperSign Struct
hi def link Sub Super
hi def link SubSign SuperSign
hi def link _Class Struct
hi def link ClassText Strong
hi def link ClassName Struct
hi def link TitleRule Struct
hi def link ListItem Struct
hi def link Example Struct
hi def link Rule Struct
hi def link FencedDiv Struct
hi def link CodeDelimiter Struct
hi def link Definition Constant
hi def link YamlKey Struct
hi def link YamlFrontMatter Constant
hi def link HtmlTag Struct
hi def link HtmlAttr Struct
hi def link htmlAttrVal Struct
hi def link Url Underlined
hi def link Hypertext Url
hi def link LinkDef Struct
hi def link Mark Strong
hi def link Concept Strong

" emphasis contained in other groups are not in italic
" but least they contains=@NoSpell and have the same color
" as their container
hi def link EmphasisString String
hi def link EmphasisParenthese Parenthese
hi def link EmphasisFootnoteText FootnoteText

let b:current_syntax = "markdown"

" polyphony: a markdown extension
if exists('g:markdown_polyphony')
    setl commentstring=\,,%s
    syn region Comment start=/,,/ end=/$/ oneline contains=@NoSpell containedin=ALLBUT,@NoMD keepend 
    syn region Comment matchgroup=Missing start=/^ *\.\.\.\+/ end=/$/ containedin=ALLBUT,@NoMD contains=@NoSpell
    syn region Comment matchgroup=Warning start=/^ *\!\!\+/ end=/$/ containedin=ABUT,@NoMD contains=@NoSpell,WarningSign
    syn region String start=/"/ skip=/[^\\]\\"/ end=/"/ keepend containedin=FootnoteText
    syn region Parenthese start="(" end=")" contains=String,Code,Emphasis containedin=ALLBUT,@NoMD,_Url,Example keepend
    syn match Filepath "\.\+\(/[a-zÀ-ÿ0-9_]\+\(\.[a-zA-Z0-9]\+\)\?\)\+/\?" contains=@NoSpell
    hi def link Parenthese Function
    hi def link Filepath Url
    " i use the Diff... groups, because this is what's all about..?
    hi def link Warning DiffText
    hi def link Missing DiffChange
    hi def link ToReRead DiffDelete
    " TODO: make that 'matchadd()' stuff cleaner
    autocmd BufEnter *.md let x = matchadd("ToReRead", "^??.*")
    autocmd BufLeave *.md call clearmatches(0)
endif

" markdown syntax
" (Pandoc is used as a reference, but it's not fully supported.)
" + polyphony, a markdown syntax extension
"
" thjbdvlt (2024). License MIT

syn cluster NoMD contains=Comment,Code,YamlFrontMatter,LinkDef
syn region String start="^>.*" end="\n\n" contains=EmphasisString,Class keepend
syn match Struct "|" keepend containedin=ALLBUT,@NoMD,Rule
syn match Rule "^--\+$"
syn match Rule "^==\+$"
syn region Brackets matchgroup=Struct start="\[" end="\]" containedin=ALLBUT,@NoMD,ModifiedQuote,Footnote nextgroup=Attribute oneline keepend extend
syn region Attribute start="{[\.#]" end="}" contained conceal cchar=µ
syn match Rule "|[-|=: ]\+|" keepend containedin=ALLBUT,@NoMD
syn match Example "(@[a-z]*)" contains=@NoSpell containedin=ALLBUT,@NoMD
syn region LinkDef start="^\[[^^\]]*\]:" end="$" contains=@NoSpell
syn match _Url "\[[^\]]*\]([^)]\+)" keepend containedin=ALLBUT,@NoMD
syn region Hypertext matchgroup=Struct start="\[" end="\]" containedin=_Url contained keepend
syn region Url matchgroup=Struct start="\]\@<=(" end=")" contained conceal cchar=/
syn region Url matchgroup=Struct start="(" end=")" containedin=_Url contained conceal cchar=/
syn match Url "<\?https\?://\S\+" contains=@NoSpell containedin=ALLBUT,@NoMD,URL keepend
syn region Emphasis start="\*[^[:punct:][:space:]]\@=" skip="\\\*" end="[^[:punct:][:space:]]\@<=\*" contains=@NoSpell keepend
syn region Emphasis start="\*[^[:punct:][:space:]]\@=" skip="\\\*" end="[^[:punct:][:space:]]\@<=\*" contains=@NoSpell keepend transparent containedin=ALLBUT,@NoMD contained
syn region Strong start="\S\@<=__\|__\S\@=" skip="\\__" end="\S\@<=__\|__\S\@="
syn region Code matchgroup=Struct start="`[^`]"rs=e-1 end="`" contains=@NoSpell containedin=ALLBUT,@NoMD
syn match ListItem "^\s*[\-\+\*] \|^\s*\d\+\."
syn match Concept "[^\n]\+\n\n\?:\@=" containedin=ALLBUT,@NoMD
syn region Definition start="^:" end="$" containedin=ALLBUT,@NoMD
syn region Code matchgroup=Struct start="^```[a-z{]\+" end="^```$" contains=@NoSpell keepend
syn match Title "^.\+\n-\+$" contains=TitleRule
syn match Title "^.\+\n=\+$" contains=TitleRule
syn match Title "^#\+ .*" contains=TitleRule
syn match TitleRule "^[=-]\+$" contained
syn match TitleRule "^#\+" contained
syn match FencedDiv "^:::.*$" contains=@NoSpell containedin=NONE keepend
syn region Super matchgroup=SuperSign start="\^\@=\S" end="\^" contains=@NoSpell containedin=Normal,String,FootnoteText oneline keepend
syn region Sub matchgroup=SubSign start="\~\@=\S" end="\~" contains=@NoSpell containedin=Normal,String,FootnoteText oneline keepend
syn region Mark matchgroup=Struct start="==\w\@=" end="==" containedin=ALLBUT,@NoMD,Title,Rule oneline
syn region Comment start="<!--" end="-->" containedin=ALLBUT,@NoMD keepend
syn match htmlTag "<[a-zA-Z]\+\( [^>]\+\)*/\?>" contains=@NoSpell,htmlAttr keepend
syn match htmlTag "</[a-zA-Z]\+>" contains=@NoSpell,htmlAttr keepend
syn region htmlAttr start=/ \@<=[a-z]\+=\"/ skip=/\\"/ end=/"/ containedin=htmlTag contained contains=@NoSpell keepend
syn region htmlAttrVal start=/"/ skip=/\\"/ end=/"/ containedin=htmlAttr contains=@NoSpell contained
syn region YamlFrontmatter matchgroup=Struct start="\%1l^---$" end="^---$" contains=@NoSpell
syn match YamlKey "^[-a-zA-Z_0-9]\+:" containedin=YamlFrontMatter contained contains=@NoSpell
syn match YamlKey "^ *- [-a-zA-Z_0-9]*:" containedin=YamlFrontMatter contained contains=@NoSpell
" " NOTE: No conceal for text BEFORE the Citation, because of the look-behind 
" using too much memory -- proabably because of my Regex being unefficient.
" Anyway, it's probably not so bad, as the Citation Suffix is meaningless
" (e.g. "p. 21"), but the prefix is more likely to be meaningfull.
" syn match CitationText "\[\@<=[^\]]\+@"me=e-1 containedin=Brackets contained conceal
syn region CitationText start="@[a-zÀ-ÿ0-9_]\+"rs=e+1 end="\]"re=e-1 containedin=Brackets contained conceal
syn match CitationKey "@[a-zÀ-ÿ0-9_]\+" containedin=CitationText contained conceal cchar=@ contains=@NoSpell
syn match CitationKey "@[a-zÀ-ÿ0-9_]\+" contains=@NoSpell containedin=ALLBUT,@NoMD,CitationText,CitationKey,Brackets
syn match ModifiedQuote "[a-zÀ-ÿ0-9_]*\[[a-zÀ-ÿ0-9_]\+\][a-zÀ-ÿ0-9_]*" contains=@NoSpell containedin=String contained transparent
syn match ModifiedQuote "\[[^@\]\[]\+\]" contains=@NoSpell containedin=String contained transparent
syn match FootnoteCall "\^[a-zA-Zà-Ÿ0-9_]\+" containedin=Brackets contains=@NoSpell conceal cchar=¶
syn region _Footnote start="^\[\^\S\+\]:" end="$"
syn match Footnote "^\[\^\S\+\]:" containedin=_Footnote contained contains=@NoSpell conceal cchar=¶
syn region FootnoteText start=":\@<=." end="$" containedin=_Footnote contained
syn region FootnoteText matchgroup=Footnote start="\^\[" end="\]" containedin=ALLBUT,@NoMD keepend
syn region FootnoteText start="\[\@<=.\?" end=".\?\]\@=" contained keepend

" i define a few specific highlights by default
hi def Emphasis cterm=italic gui=italic
hi def Strong cterm=bold gui=bold

" the other groups are linked to existing groups
hi def link Struct Statement
hi def link Brackets Constant
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
hi def link Attribute Struct
hi def link TitleRule Struct
hi def link ListItem Struct
hi def link Example Struct
hi def link Rule Struct
hi def link FencedDiv Struct
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

" polyphony: a markdown extension
if exists('g:markdown_polyphony')
    setl commentstring=\,,%s
    syn region Comment start=",," end="$" oneline contains=@NoSpell containedin=ALLBUT,@NoMD keepend 
    syn region Comment matchgroup=Missing start="^ *\.\.\.\+" end="$" containedin=ALLBUT,@NoMD contains=@NoSpell
    syn region CommentWarning start=",," end="!!" containedin=Comment contained contains=@NoSpell,WarningSign oneline
    syn region String start=/"/ skip=/[^\\]\\"/ end=/"/ keepend 
    syn region Parenthese start="(" end=")" contains=String,Code,Emphasis containedin=ALLBUT,@NoMD,_Url,Example,String extend
    syn match Filepath "\.\+\(/[a-zÀ-ÿ0-9_]\+\(\.[a-zA-Z0-9]\+\)\?\)\+/\?" contains=@NoSpell
    hi def link Parenthese Function
    hi def link Filepath Url
    " i use the Diff... groups, because this is what's all about..?
    hi def link Missing DiffAdd
    hi def link ToReRead DiffChange
    hi def link ToReWrite DiffDelete
    hi def link CommentWarning Comment
    " TODO: make that 'matchadd()' stuff cleaner
    " TODO: options for each of these highlight
    autocmd BufEnter *.md let x = matchadd("ToReRead", "^??.*")
    autocmd BufEnter *.md let x = matchadd("ToReWrite", "^!!.*")
    autocmd BufEnter *.md let x = matchadd("ToReWrite", "->.*")
    autocmd BufLeave *.md call clearmatches(0)
endif

let b:current_syntax = "markdown"

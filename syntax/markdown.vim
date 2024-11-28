" MarkDown PolyPhony
" ==================
"
" pandoc markdown syntax plus some stuff:
"
"  - inline string
"  - parentheses
"  - inline comments with ,,
"  - inline comments typed (TODO, Warning) with !! and ...
"    (only at the beginning of a line).
"
" not all pandoc markdown is supported. but this is:
"   - html comment, tag, attributes, attributes values.
"   - classes

" comment with ,,
setl commentstring=\,,%s

" a cluster with stuff in which markdown isn't active
syn cluster NoMD contains=Comment,Code,YamlFrontMatter

" comment with ,,
syn region Comment
            \ start=/,,/ end=/$/
            \ contains=@NoSpell
            \ containedin=ALLBUT,@NoMD
            \ keepend 

" commentaires supplémentaires, en début de ligne
syn region Comment
            \ matchgroup=Missing start=/^ *\.\.\.\+/ end=/$/
            \ containedin=ALLBUT,@NoMD contains=@NoSpell

syn region Comment
            \ matchgroup=Warning start=/^ *\!\!\+/ end=/$/
            \ containedin=ABUT,@NoMDLL contains=@NoSpell,WarningSign

" inline quotes
syn region String
            \ start=/"/ skip=/[^\\]\\"/ end=/"/ 
            \ keepend containedin=FootnoteText

" block quote
syn region String
            \ start="^>.*" end="\n\n"
            \ contains=EmphasisString,Class
            \ keepend

" citations (pandoc citeproc)
syn match Citation
            \ "\[[^\[\]]*@[^\[\]]*\]"
            \ containedin=ALLBUT,@NoMD
            \ keepend
syn match CitationKey
            \ "@[a-zÀ-ÿ0-9_]\+"
            \ containedin=ALLBUT,@NoMD,Example
            \ contains=@NoSpell
            \ conceal cchar=¶
syn region CitationText
            \ start=/\[\@1<=.\?/ end=/.\?\]\@=/
            \ containedin=Citation contained
            \ conceal cchar=¶

" footnotes
syn match FootnoteCall
            \ /.\@<=\[\^\S\+\]/ contains=@NoSpell
            \ conceal cchar=¶
syn region _Footnote
            \ start=/^\[\^\S\+\]:/
            \ end=/$/
syn match Footnote /^\[\^\S\+\]:/
            \ containedin=_Footnote contained
            \ contains=@NoSpell
            \ conceal cchar=¶
syn region FootnoteText
            \ start=/:\@<=./ end=/$/
            \ containedin=_Footnote contained
syn region FootnoteText
            \ matchgroup=Footnote start=/\^\[/
            \ end=/\]/
            \ containedin=ALLBUT,@NoMD
            \ keepend
syn region FootnoteText
            \ start=/\[\@<=.\?/ end=/.\?\]\@=/
            \ contained keepend

" horizontal bar with ---
syn match Rule /^---$/

" parentheses
syn region Parenthese
            \ start="(" end=")"
            \ contains=String,Code,Emphasis
            \ containedin=ALLBUT,@NoMD,_Url,Example
            \ keepend

" example list
syn match Example /(@[a-z]*)/ contains=@NoSpell
            \ containedin=ALLBUT,@NoMD

" url and hypertext
syn match _Url /\[[^\]]\+\]([^)]\+)/ keepend
syn region Hypertext
            \ matchgroup=Struct start=/\[/ end=/\]/ 
            \ containedin=_Url contained
syn region Url
            \ matchgroup=Struct start=/(/ end=/)/ 
            \ containedin=_Url contained
            \ conceal cchar=/
syn match Url "<\?https\?://\S\+"
            \ contains=@NoSpell
            \ containedin=ALLBUT,@NoMD,URL
            \ keepend

" file paths
syn match Filepath
            \ "\.\+\(/[a-zÀ-ÿ0-9_]\+\(\.[a-zA-Z0-9]\+\)\?\)\+/\?"
            \ contains=@NoSpell

" Emphasis
syn region Emphasis
            \ start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@="
            \ contains=@NoSpell

syn region Emphasis
            \ start=/\*/ skip=/\\\*/ end=/\*/
            \ contains=@NoSpell keepend

" Emphasis in other groups (only with '*')
syn region EmphasisString
            \ start="\*" skip="\\\*" end="\*"
            \ contains=@NoSpell containedin=String
            \ contained keepend
syn region EmphasisParenthese
            \ start="\*" skip="\\\*" end="\*"
            \ contains=@NoSpell containedin=Parenthese
            \ contained keepend
syn region EmphasisFootnoteText
            \ start="\*" skip="\\\*" end="\*"
            \ contains=@NoSpell containedin=FootnoteText
            \ contained keepend
syn region EmphasisTitle
            \ start="\*" skip="\\\*" end="\*"
            \ contains=@NoSpell containedin=Title
            \ contained keepend

" strong
syn region Strong
            \ start="\S\@<=__\|__\S\@="
            \ skip="\\__"
            \ end="\S\@<=__\|__\S\@="

" inline code: `
syn region Code
            \ matchgroup=CodeDelimiter
            \ start=/`/
            \ end=/`/
            \ contains=@NoSpell
            \ containedin=ALLBUT,Code,Comment

" yaml frontmatter
syn region YamlFrontmatter
            \ matchgroup=Struct
            \ start=/\%1l^---$/ end=/^---$/
            \ contains=@NoSpell

" keys (fields) in the yaml frontmatter
syn match YamlKey "^[^: ]\+:"
            \ containedin=YamlFrontMatter
            \ contained contains=@NoSpell

" lists
syn match ListItem "^\s*[\-\+\*] \|^\s*\d\+\."

" defintion list
syn match Concept "[^\n]\+\n\n\?:\@=" 
            \ containedin=ALLBUT,@NoMD
syn region Definition start=/^:/ end=/$/ 
            \ containedin=ALLBUT,@NoMD

" code block: ```
syn region Code
            \ matchgroup=CodeDelimiter
            \ start=/^```\S\+/ end=/^```$/
            \ contains=@NoSpell keepend

" titles
syn match Title /^.\+\n-\+$/ contains=TitleRule
syn match Title /^.\+\n=\+$/ contains=TitleRule
syn match Title /^#\+ .*/ contains=TitleRule
syn match TitleRule /^[=-]\+$/ contained
syn match TitleRule /^#\+/ contained

" fenced divs
syn match FencedDiv /^:::.*$/ contains=@NoSpell containedin=NONE keepend

" class: [xiii]{.smallcaps}
" TODO: do this somehow else
syn match _Class
            \ /\[[^\[\]]*\]{\.[a-z]\+}/
            \ contains=@NoSpell keepend
syn region ClassText matchgroup=_Class start=/\[/ end=/\]/
            \ containedin=_Class keepend contained
syn region ClassName matchgroup=_Class start=/{\./ end=/}/
            \ containedin=_Class keepend contained contains=@NoSpell
            \ conceal cchar=|

" subscrit and superscript: 42^ème^
syn region Super
            \ matchgroup=SuperSign start=/\^\@=\S/ end=/\^/
            \ contains=@NoSpell
            \ containedin=Normal,String,FootnoteText
            \ oneline keepend
syn region Sub
            \ matchgroup=SubSign start=/\~\@=\S/ end=/\~/
            \ contains=@NoSpell
            \ containedin=Normal,String,FootnoteText
            \ oneline keepend

syn match Struct /|/
syn region Mark
            \ matchgroup=Struct start=/==/ end=/==/
            \ containedin=ALLBUT,@NoMD

" html (comments, tags, attributes, attribute values)
syn region Comment
            \ start=/<!--/ end=/-->/
            \ containedin=ALLBUT,@NoMD
            \ keepend
" html tag
syn match htmlTag
            \ "<[a-z]\+\( [^>]\+\)*/\?>"
            \ contains=@NoSpell,htmlAttr keepend
syn match htmlTag
            \ "</[a-z]\+>"
            \ contains=@NoSpell,htmlAttr keepend

" html attribute
syn region htmlAttr
            \ start=/ \@<=[a-z]\+=\"/
            \ skip=/\\"/
            \ end=/"/
            \ containedin=htmlTag contained
            \ contains=@NoSpell keepend

" html attribute value
syn region htmlAttrVal
            \ start=/"/ skip=/\\"/ end=/"/
            \ containedin=htmlAttr contains=@NoSpell contained

" i define a few specific highlights by default
hi default Emphasis cterm=italic gui=italic
hi default Strong cterm=bold gui=bold
hi default Concept cterm=underline gui=underline

" the other groups are linked to existing groups
hi default link Struct Statement
hi default link Code Type
hi default link Warning DiffText
hi default link Missing DiffChange
hi default link Parenthese Function

hi default link Citation Struct
hi default link CitationText Constant
hi default link CitationKey Underlined

hi default link Footnote Struct
hi default link FootnoteCall Struct
hi default link FootnoteText Constant

hi default link Super Constant
hi default link SuperSign Struct
hi default link Sub Super
hi default link SubSign SuperSign
hi default link _Class Struct
hi default link ClassText Strong
hi default link ClassName Struct
hi default link TitleRule Struct
hi default link ListItem Struct
hi default link Example Struct
hi default link Rule Struct
hi default link FencedDiv Struct
hi default link CodeDelimiter Struct

hi default link Definition Constant

hi default link YamlKey Struct
hi default link YamlFrontMatter Constant

hi default link HtmlTag Struct
hi default link HtmlAttr Struct
hi default link htmlAttrVal Struct

hi default link Url Underlined
hi default link Hypertext Url
hi default link Filepath Url

hi default link Mark Strong

" emphasis contained in other groups are not in italic
" but least they contains=@NoSpell and have the same color
" as their container
hi default link EmphasisString String
hi default link EmphasisParenthese Parenthese
hi default link EmphasisFootnoteText FootnoteText

let b:current_syntax = "markdown"

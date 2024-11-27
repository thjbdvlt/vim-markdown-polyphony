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

" comment with ,,
syn region Comment
            \ start=/,,/ end=/$/
            \ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

" commentaires supplémentaires, en début de ligne
syn region Comment
            \ matchgroup=Missing start=/^ *\.\.\.\+/
            \ end=/$/
            \ containedin=ALL contains=@NoSpell

syn region Comment
            \ matchgroup=Warning start=/^ *\!\!\+/
            \ end=/$/
            \ containedin=ALL contains=@NoSpell

" inline quotes
syn region String
            \ start=/"/ skip=/[^\\]\\"/ end=/"/ keepend
            \ containedin=FootnoteText
syn region String
            \ start=/«/ skip=/[^\\]\\»/ end=/»/ keepend
            \ containedin=FootnoteText
syn region String
            \ start=/“/ skip=/[^\\]\\”/ end=/”/ keepend
            \ containedin=FootnoteText

" block quote
syn region String start="^>.*" end="\n\n"
            \ contains=EmphasisString,Class
            \ keepend

" citations (pandoc citeproc)
syn match Citation
            \ "\[[^\[\]]*@[^\[\]]*\]"
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend
syn match CitationKey
            \ "@[a-zÀ-ÿ0-9_]\+"
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter,Example
            \ contains=@NoSpell
syn region CitationText
            \ start=/\[\@<=.\?/ end=/.\?\]\@=/
            \ containedin=Citation contained

" footnotes
syn match FootnoteCall
            \ /.\@<=\[\^\S\+\]/ contains=@NoSpell
syn region _Footnote
            \ start=/^\[\^\S\+\]:/
            \ end=/$/
syn match Footnote /^\[\^\S\+\]:/
            \ containedin=_Footnote contained
            \ contains=@NoSpell
syn region FootnoteText
            \ start=/:\@<=./ end=/$/
            \ containedin=_Footnote contained
syn region FootnoteText
            \ matchgroup=Footnote start=/\^\[/
            \ end=/\]/
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend
syn region FootnoteText
            \ start=/\[\@<=.\?/ end=/.\?\]\@=/
            \ contained keepend

" horizontal bar with ---
syn match Rule /^---$/

" parentheses
syn region Parenthese
            \ start="(" end=")"
            \ contains=String,Code
            \ containedin=ALLBUT,Comment,Code,String,Title,EmphasisString,_Url,Example

" example list
syn match Example /(@[a-z]*)/ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter

" url and hypertext
syn match _Url /\[[^\]]\+\]([^)]\+)/ keepend
syn region Hypertext
            \ matchgroup=Struct start=/\[/ end=/\]/ 
            \ containedin=_Url contained
syn region Url
            \ matchgroup=Struct start=/(/ end=/)/ 
            \ containedin=_Url contained
syn match Hypertext "<\?https\?://\S\+"
            \ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter,URL
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
            \ start="\*" skip="\\\*" end="\*"
            \ contains=@NoSpell

" Emphasis + string
syn region EmphasisString
            \ start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@="
            \ containedin=String
            \ contained
            \ contains=@NoSpell
            \ keepend
syn region EmphasisString
            \ start="\*" skip="\\*" end="\*"
            \ containedin=String
            \ contained
            \ contains=@NoSpell
            \ keepend

" Emphasis + parenthese
syn region EmphasisParenthese
            \ start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@="
            \ containedin=Parenthese
            \ contains=@NoSpell
            \ contained
            \ keepend

" strong
syn region Strong
            \ start="\S\@<=__\|__\S\@="
            \ skip="\\__"
            \ end="\S\@<=__\|__\S\@="

" strong + string
syn region StrongString
            \ start="\S\@<=__\|__\S\@="
            \ skip="\\__"
            \ end="\S\@<=__\|__\S\@="
            \ containedin=String
            \ contained
            \ keepend

" strong + parenthese
syn region StrongParenthese
            \ start="\S\@<=__\|__\S\@="
            \ skip="\\__"
            \ end="\S\@<=__\|__\S\@="
            \ containedin=Parenthese
            \ contained
            \ keepend

" inline code: `
syn region Code
            \ start=/[^`]\@<=`\|^`/
            \ skip=/[^\\]\\`/
            \ end=/`[^`]\@=\|`$/
            \ contains=@NoSpell
            \ containedin=ALLBUT,Code,Comment

" code block: ```
syn region Code
            \ start=/^```\S\+/ end=/^```$/
            \ contains=@NoSpell

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
syn match Concept "[^\n]\+\n\n\?:\@=" contains=@NoSpell
syn region Definition start=/^:/ end=/$/

" titles
syn match Title /^.\+\n-\+$/ contains=TitleRule
syn match Title /^.\+\n=\+$/ contains=TitleRule
syn match Title /^#\+ .*/ contains=TitleRule
syn match TitleRule /^[=-]\+$/ contained
syn match TitleRule /^#\+/ contained

" class: [xiii]{.smallcaps}
" TODO: do this somehow else
syn match _Class
            \ /\[[^\[\]]*\]{\.[a-z]\+}/
            \ contains=@NoSpell keepend
syn region ClassText matchgroup=_Class start=/\[/ end=/\]/
            \ containedin=_Class keepend contained
syn region ClassName matchgroup=_Class start=/{\./ end=/}/
            \ containedin=_Class keepend contained contains=@NoSpell

" superscript: 42^ème^
syn match Super
            \ /\^[a-zÀ-ÿ0-9_]\+\^/
            \ contains=@NoSpell
            \ containedin=Normal,String,FootnoteText
            \ keepend
syn match SuperSign 
            \ /\^/ contained containedin=Super

" html (comments, tags, attributes, attribute values)
syn region Comment
            \ start=/<!--/ end=/-->/
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
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

hi default link Citation Struct
hi default link CitationText Constant
hi default link CitationKey Underlined

hi default link Footnote Struct
hi default link FootnoteCall Struct
hi default link FootnoteText Constant

hi default link Super Constant
hi default link SuperSign Struct
hi default link _Class Struct
hi default link ClassText Strong
hi default link ClassName Struct
hi default link TitleRule Struct
hi default link ListItem Struct
hi default link Example Struct
hi default link Rule Struct

hi default link Definition Constant

hi default link YamlKey Struct
hi default link YamlFrontMatter Constant

hi default link HtmlTag Struct
hi default link HtmlAttr Struct
hi default link htmlAttrVal Struct

hi default link Hypertext Underlined
hi default link Url Struct
hi default link Filepath Underlined

hi default link Parenthese Function

let b:current_syntax = "markdown"

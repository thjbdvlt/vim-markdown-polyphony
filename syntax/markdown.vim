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
            \ matchgroup=Missing start=/^ *\.\.\./
            \ end=/$/
            \ containedin=ALL contains=@NoSpell

syn region Comment
            \ matchgroup=Warning start=/^ *\!\!/
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
            \ contains=ItalicString,Class
            \ keepend

" citations (pandoc citeproc)
syn match Citation
            \ "\[[^\[\]]*@[^\[\]]*\]"
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend
syn match CitationKey
            \ "@[a-zÀ-ÿ0-9_]\+"
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
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
            \ containedin=ALLBUT,Comment,Code,String,Title,ItalicString

" url (or file path) in link like this: [magic place](magic url)
syn region Url matchgroup=Paratext
            \ start=/!\?\[[^\[\]]*\](/ end=/)/
            \ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

syn match Url "<\?https\?://\S\+"
            \ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter,URL
            \ keepend

" italic with _
syn region Italic
            \ start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@="
            \ contains=@NoSpell

" italic + string
syn region ItalicString
            \ start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@="
            \ containedin=String
            \ contained
            \ contains=@NoSpell
            \ keepend

" italic with *
syn region Italic
            \ start="\*"
            \ skip="\\\*"
            \ end="\*"
            \ contains=@NoSpell
syn region ItalicString start="\*" skip="\\*" end="\*"
            \ containedin=String
            \ contained
            \ contains=@NoSpell
            \ keepend

" italic + parenthese
syn region ItalicParenthese
            \ start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@="
            \ containedin=Parenthese
            \ contains=@NoSpell
            \ contained
            \ keepend

" bold
syn region Bold
            \ start="\S\@<=__\|__\S\@="
            \ skip="\\__"
            \ end="\S\@<=__\|__\S\@="

" bold
syn region BoldString
            \ start="\S\@<=__\|__\S\@="
            \ skip="\\__"
            \ end="\S\@<=__\|__\S\@="
            \ containedin=String
            \ contained
            \ keepend

" bold
syn region BoldParenthese
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

" headings
syn match Heading "^.\+\n-\+$" contains=TitleMarker
syn match Heading "^.\+\n=\+$" contains=TitleMarker
syn match Heading "^#\+ .*" contains=TitleMarker
syn match HeadingRule "^[=-]\+$" contained
syn match HeadingRule "^#\+" contained

" Class: [xiii]{.smallcaps}
" TODO: do this somehow else
syn match Class "\[[^\[\]]*\]{.[a-z]\+}"
            \ contains=@NoSpell keepend

" Normal text in Class
syn match Normal "\[\@<=[a-z]\+\]\@="
            \ containedin=Class keepend contained

" Superscript: 42^ème^
syn match Super "\^[a-zÀ-ÿ0-9_]\+\^"
            \ contains=@NoSpell
            \ containedin=Normal,String,Paratext
            \ keepend

" html (comments, tags, attributes, attribute values)
syn region htmlComment
            \ start=/<!--/ end=/-->/
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend
" html tag
syn match htmlTag "<[a-z]\+\( [^>]\+\)*/\?>"
            \ contains=@NoSpell,htmlAttr keepend
syn match htmlTag "</[a-z]\+>"
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
hi default Italic cterm=italic gui=italic
hi default Bold cterm=bold gui=bold
hi default Concept cterm=underline gui=underline

" the other groups are linked to existing groups
hi default link Struct Statement

hi default link Citation    Struct
hi default link CitationText Paratext
hi default link CitationKey Underlined

hi default link Footnote    Struct
hi default link FootnoteCall  Struct
hi default link FootnoteText Constant

hi default link Code Type
hi default link TitleMarker Struct
hi default link ListItem Struct
hi default link YamlFrontMatter Function
hi default link YamlKey Struct

hi default link Class Struct
hi default link Superscript Struct

hi default link HtmlTag Struct
hi default link HtmlAttr Operator
hi default link htmlAttrVal Error

hi default link Definition Function
hi default link Url         Underlined
hi default link Parenthese  Function

" hi @comment.warning gui=italic guifg=red

let b:current_syntax = "markdown"

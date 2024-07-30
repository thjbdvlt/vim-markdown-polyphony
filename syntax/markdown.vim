" syntax markdown that focuses on paratext and polyphonic things.
"  - quotes
"  - citation key (for pandoc)
"  - footnotes
"  - parentheses
"
"  and comment with ,, (because html comment are much too long).
"
"  and minimal support for basic markdown syntax,
"  taken from tpope: https://github.com/tpope/vim-markdown
"  - italic (emphasis)
"  - bold (strong)
"  - heading
"  - html comment
"  - code (inline and block)
"
"  TODO:
"  - italic + bold

" comment with ,,
setl commentstring=\,,%s\,,

" comment with ,,
syn region Comment
            \ start=/,,/ end=/,,/
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

" html comments
syn region Comment
            \ start=/<!--/ end=/-->/
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

" citation key: @becker2020
syn match CitationKey "@[a-zÀ-ÿ0-9_]\+"
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ contains=@NoSpell

" inline quotes
syn region String start=/"/ skip=/\\"/ end=/"/
            \ contains=Parenthese,ItalicString
            \ keepend
syn region String start=/«/ skip=/\\»/ end=/»/
            \ contains=Parenthese,ItalicString
            \ keepend
syn region String start=/“/ skip=/\\”/ end=/”/
            \ contains=Parenthese,ItalicString
            \ keepend

" block quote
syn region String start="^> " end="$"
            \ contains=Parenthese,ItalicString
            \ keepend

" [@becker2020], [^1]: ..., [cool thing](./some/path), etc.
syn region Paratext matchgroup=ParaMarker
            \ start="\[" skip="\\\]" end="\]"
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

" [^1]: pretty footnote in a small font
syn region Paratext matchgroup=ParaMarker
            \ start="^\[^\w\+\]:" end="$"
            \ contains=CONTAINED
            \ keepend

" parentheses
syn region Parenthese
            \ start="(" end=")"
            \ contains=String,Code
            \ containedin=ALLBUT,Code

" url (or file path) in link like this: [magic place](magic url)
syn region Url matchgroup=Paratext 
            \ start=/\]\@<=(/ end=/)/
            \ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

" italic with *
syn region Italic
            \ start="\S\@<=\*\|\*\S\@=" 
            \ skip="\\\*"
            \ end="\S\@<=\*\|\*\S\@="  
            \ contains=@NoSpell

" italic with _
syn region Italic
            \ start="\W\@<=_\w\@=\|^_\w\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$"
            \ contains=@NoSpell

" italic + string
syn region ItalicString
            \ start="\W\@<=_\w\@=\|^_\w\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$"
            \ containedin=String
            \ contained
            \ contains=@NoSpell
            \ keepend

" italic + string
syn region ItalicParenthese
            \ start="\W\@<=_\w\@=\|^_\w\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$"
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
            \ start=/`/ skip=/\\`/ end=/`/
            \ contains=@NoSpell
            \ containedin=ALLBUT,Code

" inline code block: ```
syn region Code
            \ start=/^```/ end=/```/
            \ contains=@NoSpell

syn region YamlFrontMatter
            \ matchgroup=Statement
            \ start=/\%1l^---$/ end=/^---$/
            \ contains=@NoSpell

syn match YamlKey "^[^: ]\+:" containedin=YamlFrontMatter contained contains=@NoSpell

" les listes
syn match ListItem "^\- \|^\d\."

" headings
syn match Title "^.\+\n-\+$" contains=TitleMarker
syn match Title "^.\+\n=\+$" contains=TitleMarker
syn match Title "^#\+ .*" contains=TitleMarker
syn match TitleMarker "^[=-]\+$" contained
syn match TitleMarker "^#\+" contained

"  links to highlight groups
hi default Italic cterm=italic
hi default link CitationKey Underlined
hi default link Date        Statement
hi default link Url         Underlined
hi default link Parenthese  Function
hi default link Paratext    Constant
hi default link ParaMarker  Statement
hi default link Footnote    Paratext
hi default link Code Type
hi default link TitleMarker Statement
hi default link ListItem Statement
hi default link YamlFrontMatter Function
hi default link YamlKey Statement

let b:current_syntax = "markdown"

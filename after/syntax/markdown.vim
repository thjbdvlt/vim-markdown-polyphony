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
"  - italic (emphasis), bold (strong)
"  - heading
"  - html comment
"  - code (inline and block)

" comment with ,,
setl commentstring=\,,%s\,,

" comment with ,,
syn region Comment
            \ start=/,,/ end=/,,/
            \ containedin=ALLBUT,Comment,Code

" comment with ,,
syn region Comment
            \ start=/<!--/ end=/-->/
            \ containedin=ALLBUT,Comment,Code

" citation key: @becker2020
syn match CitationKey "@[a-zÀ-ÿ0-9_]\+"
            \ containedin=ALLBUT,Comment,Code
            \ contains=@NoSpell

" inline quotes
syn region String start=/"/ skip=/\\"/ end=/"/
            \ contains=CONTAINED
            \ keepend
syn region String start=/«/ skip=/\\»/ end=/»/
            \ contains=TOP,Parenthese,Code
            \ keepend
syn region String start=/“/ skip=/\\”/ end=/”/
            \ contains=CONTAINED
            \ keepend

" block quote
syn region String start="^> " end="$"
            \ contains=CONTAINED
            \ keepend

" [@becker2020], [^1]: ..., [cool thing](./some/path), etc.
syn region Paratext matchgroup=ParaMarker
            \ start="\[" skip="\\\]" end="\]"
            \ containedin=ALLBUT,Comment,Code
            \ keepend

" [^1]: pretty footnote in a small font
syn region Paratext matchgroup=ParaMarker
            \ start="^\[^\w\+\]:" end="$"
            \ contains=CONTAINED
            \ keepend

" parentheses
syn region Parenthese matchgroup=Parenthese
            \ start="(" end=")"
            \ contains=TOP
            \ containedin=ALLBUT,Code

" url (or file path) in link like this: [magic place](magic url)
syn region Url matchgroup=Paratext 
            \ start=/\]\@<=(/ end=/)/
            \ contains=@NoSpell

" italic with *
syn region Italic matchgroup=Italic
            \ start="\S\@<=\*\|\*\S\@=" 
            \ skip="\\\*"
            \ end="\S\@<=\*\|\*\S\@="  
            \ contains=ALL
            \ keepend

" italic with _
syn region Italic matchgroup=Italic
            \ start="\S\@<=_\|_\S\@=" 
            \ skip="\\_"
            \ end="\S\@<=_\|_\S\@="  
            \ contains=ALL
            \ containedin=ALLBUT,comment,Code
            \ keepend

" inline code: `
syn region Code
            \ start=/`/ skip=/\\`/ end=/`/
            \ contains=@NoSpell

" inline code block: ```
syn region Code
            \ start=/^```/ end=/```/
            \ contains=@NoSpell

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

" additional syntax markdown that focuses on paratext and polyphonic things.
"  - quotes
"  - citation key (for pandoc)
"  - footnotes
"  - parentheses
"
"  and comment with ,, (because html comment are much too long).
"
" this syntax file is just an addition to default markdown syntax file.
" thus, it is very incomplete.

" comment with ,,
setl commentstring=\,,%s\,,

" comment with ,,
syn region Comment 
            \ start=/,,/ end=/,,/
            \ containedin=ALLBUT,Comment,markdownCode,markdownCodeBlock

" citation key: @becker2020
syn match CitationKey "@[a-zÀ-ÿ0-9_]\+" 
            \ containedin=ALLBUT,Comment,markdownCode,markdownCodeBlock

" inline quotes
syn region String start=/"/ end=/"/ contains=Paratext,Footnote keepend
syn region String start=/«/ end=/»/ contains=Paratext,Footnote keepend
syn region String start=/“/ end=/”/ contains=Paratext,Footnote keepend

" block quote
syn region String start="^> " end="$"

" [@becker2020], [^1]: ..., [cool thing](./some/path), etc.
syn region Paratext matchgroup=ParaMarker
            \ start="\[" skip="\\\]" end="\]"
            \ contains=CitationKey,String,Comment,url,Underlined
            \ containedin=ALLBUT,Comment,markdownCode,markdownCodeBloc 
            \ keepend

" [^1]: pretty footnote in a small font
syn region Paratext matchgroup=ParaMarker
            \ start="^\[^\w\+\]:" end="$"
            \ contains=CitationKey,String,Comment,url,Underlined
            \ keepend

syn region Parenthese matchgroup=Parenthese
            \ start="(" end=")"

" url (or file path) in link like this: [magic place](magic url)
syn region Url matchgroup=Paratext start=/\]\@<=(/ end=/)/

" url in text, like: https://on-tenk.fr
syn match Url 
            \ "\(https\?\|ftp\)://\S\+[[:alpha:][:digit:]/]"
            \ containedin=ALLBUT,Comment,markdownCode,markdownCodeBlock

"  links to highlight groups
hi! link  CitationKey Underlined
hi! link  Date        Statement
hi! link  Url         Underlined
hi! link  Parenthese  Function
hi! link  Paratext    Constant
hi! link  ParaMarker  Statement
hi! link  Footnote    Paratext

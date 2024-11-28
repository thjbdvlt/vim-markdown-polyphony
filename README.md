extended markdown syntax for vim, based on [pandoc](https://pandoc.org/MANUAL.html#pandocs-markdown).

- inline quotes
- parentheses
- comments:
    - comments with `,,`
    - missing developpement with `...` (beginning of line)
    - important comment with `!!` (beginning of line)
- ...

the repository also contains a simple bash script to remove these comments (e. g. for pandoc).

quotes and parentheses
----------------------

quotes and parentheses, of course, are not part of _markdown syntax_. these are more like _semantic highlights_.

why that? because i want _inline quotes_ to be the same color as _block quote_ because they play the same role, they have the same kind of difference with the sentences that i write: one color for sentences i wrote, one color for sentences i quote.
this also make me see quickly if a whole paragraph i just 'wrote' is just a bunch of quotation clumsily organised, if a chapter contains too many (or too few) citations.

that's the same logic for parentheses: _syntax highlights_ is supposed to make me see not only the _nature_ (or _role_) of the text components, but also to make me see the _structure_ of my code. and in texts in natural language (such as ones i wrote in markdown), parentheses play a role in this structure. therefore i want them to be highlights, to be visually isolated because they are semantic isolations.

comma comments
--------------

html comments are much too long, sometimes even longer than the comment itself:

```markdown
...as B. shows <!--says?--> in _Art worlds_...
```

that's why i added a shorter and easier-to-write syntax. i never use double commas in my text and commas are very accessible in many keyboards so it seems to be a good option. (i did not want to use `//` becaus i often use this in my notes.)

the bash script is meant to be used as a preprocessing tool. it remove comma comments and add newlines between files (just as Pandoc would do).

```bash
./uncomma *.md | pandoc -
```

if you use [Comment.nvim](https://github.com/numToStr/Comment.nvim) plugin, adding following code will say Comment.nvim to use `,,` syntax for (un)commenting:

```lua
local ft = require('Comment.ft')
ft.set('markdown', {',,%s'})
```

install
-------

just like any other vim plugin, using you plugin manager file to `syntax/markdown.vim`.
if you want to use the additional syntax, you need to set an option:

```vim
let g:markdown_polyphony=1
```

treesitter
----------

if you have treesitter installed, you have to ensure that "markdown" is disabled (or not installed).

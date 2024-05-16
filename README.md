additional markdown highlights for [pandoc luafilter](https://pandoc.org/lua-filters.html):

- quotes
- comments with `,,`
- footnotes
- parentheses
- citation keys (for pandoc)

the repository also contains a [pandoc lua filter](https://pandoc.org/lua-filters.html) to remove `,,` comments when exported with pandoc.

comma comments
--------------

html comments are much too long, sometimes even longer than the comment itself:

```markdown
...as B. shows <!--says?--> in _Art worlds_...
```

that's why i added a shorter and easier-to-write syntax. i never use double commas in my text and commas are very accessible in many keyboards so it seems to be a good option.

to run the lua filter, just run `pandoc` with `-L` option:

```bash
pandoc -L /path/to/luafilter/commacomment.lua 
    \ -i README.md -o README.pdf -f markdown -t pdf
```

if you use [Comment.nvim](https://github.com/numToStr/Comment.nvim) plugin, adding following code will say Comment.nvim to use `,,` syntax for (un)commenting:

```lua
local ft = require('Comment.ft')
ft.set('markdown', {',,%s,,', ',,%s,,'})
```

installation
------------

just like any other vim plugin, or append the content of the syntax file to `after/syntax/markdown.vim`.

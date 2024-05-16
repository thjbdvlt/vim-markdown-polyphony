additional markdown highlights for vim:

- quotes
- comments with `,,`
- footnotes
- parentheses
- citation keys (for pandoc)

the repository also contains a pandoc lua filter to remove `,,` comments when exported with pandoc.

comma comments
--------------

html comments are much too long, even longer than the comment itself:

```markdown
...as B. shows <!--says?--> in _Art worlds_...
```

to run the lua filter, just run `pandoc` with `-L /path/to/commacomment.lua` option:

```bash
pandoc -L ./luafilter/commacomment.lua 
    \ -i README.md -o README.pdf -f markdown -t pdf
```

if you use [Comment.nvim](https://github.com/numToStr/Comment.nvim) plugin, adding following code will say Comment.nvim to use `,,` syntax for (un)commenting:

```lua
local ft = require('Comment.ft')
ft.set('markdown', {',,%s,,', ',,%s,,'})
```

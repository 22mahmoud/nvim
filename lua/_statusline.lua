local o = vim.o

local line = [[]]

-- file path
line = line .. [[%#TermCursor#]]
line = line .. [[ %{luaeval("require('nvim-web-devicons').get_icon(vim.fn.expand('%:e')) or '' ")} ]]
line = line .. [[%2{&modified ? '● ' : ''}]]
line = line .. [[%{expand('%:~:.')} ]] -- relative filepath
line = line .. [[%#StatusLine#]]

-- rhs
line = line .. [[ %= ]]

-- col and line
line = line .. [[%#Title#]]
line = line .. [[ (Ln %l/%L, Col %c) ]]

line = line .. [[%#StatusLine#]]

line = line .. [[ %y ]] -- filetype

o.laststatus = 2
o.statusline = line
o.showmode = true

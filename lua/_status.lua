local o = vim.o

local M = {}

function M.setup()
  local line = [[]]
  line =
    line ..
    [[ %{luaeval("require('nvim-web-devicons').get_icon(vim.fn.expand('%:e')) or '' ")} ]]
  line = line .. [[%2{&modified ? '● ' : ''}]]
  line = line .. [[%{expand('%:~:.')}]] -- relative filepath
  line = line .. [[%2{&readonly ? '' : ''}]]
  line = line .. [[ (Ln %l/%L, Col %c) ]]

  -- rhs
  line = line .. [[ %= ]]
  -- line = line .. [[ %y ]] -- filetype

  o.laststatus = 2
  o.statusline = line
  o.showmode = true
end

return M

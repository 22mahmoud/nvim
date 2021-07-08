local utils = require("ma.utils")

local augroup = utils.augroup

vim.opt.background = "dark"

local function user_highlights()
  vim.cmd [[hi Normal   guibg=NONE ctermbg=NONE]]
  vim.cmd [[hi NormalNC guibg=NONE ctermbg=NONE]]

  vim.cmd [[hi SignColumn        guibg=NONE ctermbg=NONE]]
  vim.cmd [[hi LspReferenceText  gui=NONE]]
  vim.cmd [[hi LspReferenceRead  gui=NONE]]
  vim.cmd [[hi LspReferenceWrite gui=NONE]]

  vim.cmd [[hi GitGutterAdd           guibg=NONE]]
  vim.cmd [[hi GitGutterChange        guibg=NONE]]
  vim.cmd [[hi GitGutterDelete        guibg=NONE]]
  vim.cmd [[hi GitGutterChangeDelete  guibg=NONE]]
end

user_highlights()

augroup(
  "UserHighlights",
  {
    {
      events = {"ColorScheme"},
      targets = {"*"},
      command = function()
        user_highlights()
      end
    }
  }
)

local utils = require("ma.utils")

local augroup = utils.augroup

vim.opt.background = "dark"

vim.cmd [[silent! colorscheme base16-dracula]]
vim.g.airline_theme = "base16"

local function user_highlights()
  vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
  vim.cmd [[hi NormalNC guibg=NONE ctermbg=NONE]]
  vim.cmd [[hi LspReferenceText gui=NONE]]
  vim.cmd [[hi LspReferenceRead gui=NONE]]
  vim.cmd [[hi LspReferenceWrite gui=NONE]]
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

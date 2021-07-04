local utils = require("ma.utils")

local augroup = utils.augroup

vim.g.airline_theme = "base16"
vim.cmd [[colorscheme base16-ashes]]

augroup(
  "UserHighlights",
  {
    {
      events = {"ColorScheme"},
      targets = {"*"},
      command = function()
        vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
      end
    }
  }
)

local utils = require("ma.utils")

local augroup = utils.augroup

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

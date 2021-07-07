local utils = require("ma.utils")
local augroup = utils.augroup

augroup(
  "SetupZenModePlugin",
  {
    {
      events = {"User"},
      targets = {"zen-mode.nvim"},
      command = function()
        require("zen-mode").setup {
          window = {
            backdrop = 1,
            height = 0.85
          },
          plugins = {
            gitsigns = {enabled = false}
          }
        }
      end
    }
  }
)

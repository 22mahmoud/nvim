local M = {}

M.config = function()
  require "nvim-treesitter.configs".setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    },
    rainbow = {
      enable = true
    },
    autotag = {enable = true}
  }
end

return M

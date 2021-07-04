local M = {}

M.config = function()
  require "nvim-treesitter.configs".setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    }
  }
end

return M

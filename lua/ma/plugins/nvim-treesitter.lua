local M = {}

function M.config()
  require "nvim-treesitter.configs".setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true
    },
    indent = {
      enable = true
    }
  }
end

return M

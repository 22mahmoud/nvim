-- load packages
vim.cmd("packadd nvim-treesitter")

require "nvim-treesitter.configs".setup {
  ensure_installed = "all",
  highlight = {
    enable = true
  }
}

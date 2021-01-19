vim.cmd [[packadd nvim-treesitter]]

require "nvim-treesitter.configs".setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
    use_language_tree = true
  },
  indent = {
    enable = true
  }
}

local has_treesitter = pcall(require, "nvim-treesitter")

if not has_treesitter then
  return
end

require "nvim-treesitter.configs".setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },
  indent = {
    enable = true
  },
  autotag = {enable = true},
  autopairs = {enable = true}
}

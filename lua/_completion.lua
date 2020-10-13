local utils = require "utils"

vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.g.completion_matching_ignore_case = 1

utils.map("i", "<Tab>", [[ pumvisible() ? "\<C-n>" : "\<Tab>" ]], {expr = true})

utils.map(
  "i",
  "<S-Tab>",
  [[ pumvisible() ? "\<C-p>" : "\<S-Tab>" ]],
  {expr = true}
)

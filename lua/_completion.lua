local utils = require "utils"

vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.shortmess = vim.o.shortmess .. "c"

vim.g.completion_auto_change_source = 1 -- Change the completion source automatically if no completion availabe
vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}
vim.g.completion_matching_ignore_case = 1
vim.g.completion_trigger_on_delete = 0
vim.g.completion_enable_auto_hover = 0
vim.g.completion_enable_auto_signature = 0
vim.g.completion_chain_complete_list = {
  default = {
    default = {
      {complete_items = {"lsp", "snippet"}},
      {complete_items = {"buffers"}},
      {mode = "<c-p>"},
      {mode = "<c-n>"}
    },
    string = {
      {
        complete_items = {"path"},
        triggered_only = {"/"}
      }
    }
  }
}

vim.g.completion_enable_auto_paren = 1
vim.g.completion_customize_lsp_label = {
    Function = " [function]",
    Method = " [method]",
    Reference = " [reference]",
    Enum = " [enum]",
    Field = "ﰠ [field]",
    Keyword = " [key]",
    Variable = " [variable]",
    Folder = " [folder]",
    Snippet = " [snippet]",
    Operator = " [operator]",
    Module = " [module]",
    Text = "ﮜ[text]",
    Class = " [class]",
    Interface = " [interface]"
}

utils.map("i", "<Tab>", [[ pumvisible() ? "\<C-n>" : "\<Tab>" ]], {expr = true})

utils.map(
  "i",
  "<S-Tab>",
  [[ pumvisible() ? "\<C-p>" : "\<S-Tab>" ]],
  {expr = true}
)

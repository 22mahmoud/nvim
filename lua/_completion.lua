local cmd = vim.cmd
local g = vim.g

-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

g.completion_enable_auto_hover = 0
g.completion_auto_change_source = 1
g.completion_matching_ignore_case = 1
g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}
g.completion_enable_snippet = "vim-vsnip"
g.completion_confirm_key = ""
g.completion_trigger_keyword_length = 2
g.completion_chain_complete_list = {
  default = {
    {complete_items = {"lsp"}},
    {complete_items = {"snippet"}},
    {complete_items = {"buffers"}},
    {complete_items = {"path"}},
    {mode = "<c-p>"},
    {mode = "<c-n>"}
  }
}
g.completion_customize_lsp_label = {
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
  Class = " [class]"
}

cmd [[au BufReadPre,BufNewFile * lua require'completion'.on_attach()]]

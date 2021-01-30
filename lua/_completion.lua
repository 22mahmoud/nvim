local map = vim.api.nvim_set_keymap

require("compe").setup {
  enabled = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  allow_prefix_unmatch = false,
  source = {
    path = true,
    buffer = true,
    vsnip = true,
    nvim_lsp = true,
    nvim_lua = false
  }
}

map("i", "<C-Space>", "compe#complete()", {silent = true, expr = true})
map("i", "<CR>", "compe#confirm({ 'keys': '<Plug>delimitMateCR', 'mode': '' })", {silent = true, expr = true})
map("i", "<C-e>", "compe#close('<C-e>')", {silent = true, expr = true})

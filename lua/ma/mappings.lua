-- navigation & find & search
G.nnoremap('<leader>p', ':find<space>', { silent = false })
G.nnoremap('<leader>rg', ':silent grep ""<left>', { silent = false })
G.nnoremap('<leader>gw', ':silent grep <C-R>=expand("<cword>")<CR><CR>')

-- Move selected line / block of text in visual mode
G.vnoremap('J', ":move '>+1<CR>gv-gv")
G.vnoremap('K', ":move '<-2<CR>gv-gv")

-- better movement between window buffers
G.nnoremap('<c-k>', '<c-w><c-k>')
G.nnoremap('<c-h>', '<c-w><c-h>')
G.nnoremap('<c-j>', '<c-w><c-j>')
G.nnoremap('<c-l>', '<c-w><c-l>')

-- better indenting experience
G.vnoremap('<', '<gv')
G.vnoremap('>', '>gv')

-- buffers
G.nnoremap('<leader>bn', ':bn<cr>')
G.nnoremap('<leader>bp', ':bp<cr>')
G.nnoremap('<leader>bl', ':ls t<cr>:b<space>', { silent = false })
G.nnoremap('<leader>bd', ':bd!<cr>')

-- quick list
G.nnoremap('<leader>qn', ':cn<cr>')
G.nnoremap('<leader>qp', ':cp<cr>')
G.nnoremap('<leader>ql', G.toggle_qf, { nowait = false })
G.nnoremap('<leader>qq', ':cex []<cr>')

-- special remaps
G.nnoremap('n', 'nzz')
G.nnoremap('N', 'Nzz')

-- better command mode navigation
G.cnoremap('<C-b>', '<Left>')
G.cnoremap('<C-f>', '<Right>')
G.cnoremap('<C-n>', '<Down>')
G.cnoremap('<C-p>', '<Up>')
G.cnoremap('<C-e>', '<End>')
G.cnoremap('<C-a>', '<Home>')
G.cnoremap('<C-d>', '<Del>')
G.cnoremap('<C-h>', '<BS>')

-- diagnostics
G.nnoremap('<leader>ds', function()
  vim.diagnostic.open_float(nil, { source = 'always' })
end)
G.nnoremap('<leader>dn', function()
  vim.diagnostic.goto_next { float = false }
end)
G.nnoremap('<leader>dp', function()
  vim.diagnostic.goto_prev { float = false }
end)

-- Terminal window escape
G.tnoremap('<C-x><C-o>', '<C-\\><C-n>')

-- lsp
G.lsp = G.lsp or {}
G.lsp.mappings = {
  n = {
    {
      ',f',
      function()
        vim.lsp.buf.format { async = true }
      end,
      'documentFormattingProvider',
    },
    { 'gr', vim.lsp.buf.references, 'referencesProvider' },
    { 'K', vim.lsp.buf.hover, 'hoverProvider' },
    { 'gi', vim.lsp.buf.implementation, 'implementationProvider' },
    { 'gd', vim.lsp.buf.definition, 'definitionProvider' },
    { 'gD', vim.lsp.buf.declaration, 'declarationProvider' },
    { '<leader>sh', vim.lsp.buf.signature_help, 'signatureHelpProvider' },
    { 'gW', vim.lsp.buf.workspace_symbol, 'workspaceSymbolProvider' },
    { 'ga', vim.lsp.buf.code_action, 'codeActionProvider' },
    { '<leader>l', vim.lsp.codelens.run, 'codeLensProvider' },
    { '<leader>rn', vim.lsp.buf.rename, 'renameProvider' },
  },
  v = {
    {
      ',f',
      function()
        vim.lsp.buf.format { async = true }
      end,
      'documentRangeFormattingProvider',
    },
  },
  i = {
    { '<c-space>', vim.lsp.buf.signature_help, 'signatureHelpProvider' },
  },
}

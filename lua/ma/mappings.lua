-- navigation & find & search
G.nnoremap('<leader>p', ':find<space>', { silent = false })
G.nnoremap('<leader>rg', ':grep<space>', { silent = false })
G.nnoremap('<leader>gw', ':grep <cword> . <cr>')

-- Move selected line / block of text in visual mode
G.vnoremap('J', ":move '>+1<CR>gv-gv")
G.vnoremap('K', ":move '<-2<CR>gv-gv")

-- better movement between window buffers
G.nnoremap('<c-k>', '<c-w><c-k>')
G.nnoremap('<c-h>', '<c-w><c-h>')
G.nnoremap('<c-j>', '<c-w><c-j>')
G.nnoremap('<c-l>', '<c-w><c-l>')

-- better yank behaviour
G.nnoremap('Y', 'y$')

-- better indenting experience
G.vnoremap('<', '<gv')
G.vnoremap('>', '>gv')

-- buffers
G.nnoremap('<leader>bn', ':bn<cr>')
G.nnoremap('<leader>bp', ':bp<cr>')
G.nnoremap('<leader>bl', ':buffers<cr>:buffer<space>')
G.nnoremap('<leader>bd', ':bd!<cr>')

-- quick list
G.nnoremap('<leader>qn', ':cn<cr>')
G.nnoremap('<leader>qp', ':cp<cr>')
G.nnoremap('<leader>ql', G.toggle_qf, { nowait = false })
G.nnoremap('<leader>qq', ':cex []<cr>')

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
  vim.diagnostic.open_float(0, { scope = 'line' })
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
    { ',f', vim.lsp.buf.formatting, 'document_formatting' },
    { 'gr', vim.lsp.buf.references, 'find_references' },
    { 'K', vim.lsp.buf.hover, 'hover' },
    { 'gi', vim.lsp.buf.implementation, 'implementation' },
    { 'gd', vim.lsp.buf.definition, 'goto_definition' },
    { 'gd', vim.lsp.buf.declaration, 'declaration' },
    { 'sh', vim.lsp.buf.signature_help, 'signature_help' },
    { 'gW', vim.lsp.buf.workspace_symbol, 'workspace_symbol' },
    { 'ga', vim.lsp.buf.code_action, 'code_action' },
    { '<leader>l', vim.lsp.codelens.run, 'code_lens' },
    { '<leader>rn', vim.lsp.buf.rename, 'rename' },
  },
  v = {
    { ',f', vim.lsp.buf.range_formatting, 'document_range_formatting' },
  },
  i = {
    { '<c-space>', vim.lsp.buf.signature_help, 'signature_help' },
  },
}

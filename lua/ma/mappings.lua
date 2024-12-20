-- navigation & find & search
G.nnoremap('<leader>p', ':find<space>', { silent = false })
G.nnoremap('<leader>rg', [[:silent grep ''<left>]], { silent = false })
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
G.nnoremap('<leader>qn', ':cn<cr>zz')
G.nnoremap('<leader>qp', ':cp<cr>zz')
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
G.nnoremap('<leader>ds', function() vim.diagnostic.open_float(nil, { source = 'always' }) end)

G.nnoremap('<leader>dn', function() vim.diagnostic.jump { count = 1 } end)

G.nnoremap('<leader>dp', function() vim.diagnostic.jump { count = -1 } end)

-- Terminal window escape
G.tnoremap('<C-x><C-o>', '<C-\\><C-n>')

-- lsp
local methods = vim.lsp.protocol.Methods
G.lsp_mappings = {
  n = {
    {
      'gr',
      vim.lsp.buf.references,
      methods.textDocument_references,
    },
    { 'K', vim.lsp.buf.hover, methods.textDocument_hover },
    { 'gi', vim.lsp.buf.implementation, methods.textDocument_implementation },
    { 'gd', vim.lsp.buf.definition, methods.textDocument_definition },
    { 'gD', vim.lsp.buf.declaration, methods.textDocument_declaration },
    {
      '<leader>sh',
      vim.lsp.buf.signature_help,
      methods.textDocument_signatureHelp,
    },
    { 'gW', vim.lsp.buf.workspace_symbol, methods.workspaceSymbol_resolve },
    { 'ga', vim.lsp.buf.code_action, methods.textDocument_codeAction },
    { '<leader>l', vim.lsp.codelens.run, methods.textDocument_codeLens },
    { '<leader>rn', vim.lsp.buf.rename, methods.textDocument_rename },
    {
      '<leader>ih',
      function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {}) end,
      methods.textDocument_inlayHint,
    },
  },
  v = {},
  i = {
    {
      '<c-space>',
      vim.lsp.buf.signature_help,
      methods.textDocument_signatureHelp,
    },
  },
}

local utils = require 'ma.utils'
local keymap = vim.keymap.set

-- navigation & find & search
keymap('n', '<leader>p', ':find<space>')
keymap('n', '<leader>rg', [[:silent grep ''<left>]])
keymap('n', '<leader>gw', ':silent grep <C-R>=expand("<cword>")<CR><CR>')

-- Move selected line / block of text in visual mode
keymap('v', 'J', ":move '>+1<CR>gv-gv")
keymap('v', 'K', ":move '<-2<CR>gv-gv")

-- better movement between window buffers
keymap('n', '<c-k>', '<c-w><c-k>')
keymap('n', '<c-h>', '<c-w><c-h>')
keymap('n', '<c-j>', '<c-w><c-j>')
keymap('n', '<c-l>', '<c-w><c-l>')

-- better indenting experience
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- buffers
keymap('n', '<s-l>', ':bn<cr>', { silent = true })
keymap('n', '<s-h>', ':bp<cr>', { silent = true })
keymap('n', '<leader>bl', ':ls t<cr>:b<space>')
keymap('n', '<leader>bd', ':bd!<cr>')

-- quick list
keymap('n', '<leader>qn', ':cn<cr>zz')
keymap('n', '<leader>qp', ':cp<cr>zz')
keymap('n', '<leader>ql', utils.toggle_qf, { nowait = false })
keymap('n', '<leader>qq', ':cex []<cr>')

-- special remaps
keymap('n', 'n', 'nzz')
keymap('n', 'N', 'Nzz')

-- better command mode navigation
keymap('c', '<C-b>', '<Left>')
keymap('c', '<C-f>', '<Right>')
keymap('c', '<C-n>', '<Down>')
keymap('c', '<C-p>', '<Up>')
keymap('c', '<C-e>', '<End>')
keymap('c', '<C-a>', '<Home>')
keymap('c', '<C-d>', '<Del>')
keymap('c', '<C-h>', '<BS>')

-- diagnostics
keymap('n', '<leader>ds', function() vim.diagnostic.open_float(nil, { source = 'always' }) end)
keymap('n', '<leader>dn', function() vim.diagnostic.jump { count = 1 } end)
keymap('n', '<leader>dp', function() vim.diagnostic.jump { count = -1 } end)
keymap('n', '<leader>dq', vim.diagnostic.setloclist)

-- Terminal window escape
keymap('t', '<C-x><C-o>', '<C-\\><C-n>')

-- lsp
local methods = vim.lsp.protocol.Methods
G.lsp_mappings = {
  n = {
    { 'gr', vim.lsp.buf.references, methods.textDocument_references },
    { ',f', function() vim.lsp.buf.format { async = true } end, methods.textDocument_formatting },
    { 'K', vim.lsp.buf.hover, methods.textDocument_hover },
    { 'gi', vim.lsp.buf.implementation, methods.textDocument_implementation },
    { 'gd', vim.lsp.buf.definition, methods.textDocument_definition },
    { 'gD', vim.lsp.buf.declaration, methods.textDocument_declaration },
    { '<leader>sh', vim.lsp.buf.signature_help, methods.textDocument_signatureHelp },
    { 'gW', vim.lsp.buf.workspace_symbol, methods.workspaceSymbol_resolve },
    { 'ga', vim.lsp.buf.code_action, methods.textDocument_codeAction },
    { '<leader>l', vim.lsp.codelens.run, methods.textDocument_codeLens },
    { '<leader>rn', vim.lsp.buf.rename, methods.textDocument_rename },
    {
      '<leader>ti',
      function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {}) end,
      methods.textDocument_inlayHint,
    },
  },
  v = {
    { ',f', function() vim.lsp.buf.format { async = true } end, methods.textDocument_formatting },
  },
  i = {
    { '<c-k>', vim.lsp.buf.signature_help, methods.textDocument_signatureHelp },
  },
}

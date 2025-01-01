local utils = require 'ma.utils'
local map = vim.keymap.set

-- navigation & find & search
map('n', '<leader>p', ':find<space>')
map('n', '<leader>rg', [[:silent grep ''<left>]])
map('n', '<leader>gw', ':silent grep <C-R>=expand("<cword>")<CR><CR>')

-- Move selected line / block of text in visual mode
map('v', 'J', ":move '>+1<CR>gv-gv")
map('v', 'K', ":move '<-2<CR>gv-gv")

-- better movement between window buffers
map('n', '<c-k>', '<c-w><c-k>')
map('n', '<c-h>', '<c-w><c-h>')
map('n', '<c-j>', '<c-w><c-j>')
map('n', '<c-l>', '<c-w><c-l>')

-- better indenting experience
map('v', '<', '<gv')
map('v', '>', '>gv')

-- buffers
map('n', '<s-l>', ':bn<cr>', { silent = true })
map('n', '<s-h>', ':bp<cr>', { silent = true })
map('n', '<leader>bl', ':ls t<cr>:b<space>')
map('n', '<leader>bd', ':bd!<cr>')

-- quick list
map('n', '<leader>qn', ':cn<cr>zz')
map('n', '<leader>qp', ':cp<cr>zz')
map('n', '<leader>ql', utils.toggle_qf, { nowait = false })
map('n', '<leader>qq', ':cex []<cr>')

-- special remaps
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

-- better command mode navigation
map('c', '<C-b>', '<Left>')
map('c', '<C-f>', '<Right>')
map('c', '<C-n>', '<Down>')
map('c', '<C-p>', '<Up>')
map('c', '<C-e>', '<End>')
map('c', '<C-a>', '<Home>')
map('c', '<C-d>', '<Del>')
map('c', '<C-h>', '<BS>')

-- diagnostics
map('n', '<leader>ds', function() vim.diagnostic.open_float(nil, { source = 'always' }) end)
map('n', '<leader>dn', function() vim.diagnostic.jump { count = 1 } end)
map('n', '<leader>dp', function() vim.diagnostic.jump { count = -1 } end)
map('n', '<leader>dq', vim.diagnostic.setloclist)

-- Terminal window escape
map('t', '<C-x><C-o>', '<C-\\><C-n>')

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
      '<c-k>',
      vim.lsp.buf.signature_help,
      methods.textDocument_signatureHelp,
    },
  },
}

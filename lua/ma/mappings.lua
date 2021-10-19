local utils = require 'ma.utils'

local nnoremap = utils.nnoremap
local cnoremap = utils.cnoremap
local vnoremap = utils.vnoremap
local tnoremap = utils.tnoremap
local inoremap = utils.inoremap
local toggle_qf = utils.toggle_qf

-- navigation & find & search
nnoremap('<leader>p', ':find<space>', { silent = false })
nnoremap('<leader>rg', ':grep<space>', { silent = false })
nnoremap('<leader>gw', ':grep <cword> . <cr>')

-- Move selected line / block of text in visual mode
vnoremap('J', ":move '>+1<CR>gv-gv")
vnoremap('K', ":move '<-2<CR>gv-gv")

-- better movement between window buffers
nnoremap('<c-k>', '<c-w><c-k>')
nnoremap('<c-h>', '<c-w><c-h>')
nnoremap('<c-j>', '<c-w><c-j>')
nnoremap('<c-l>', '<c-w><c-l>')

-- better yank behaviour
nnoremap('Y', 'y$')

-- better indenting experience
vnoremap('<', '<gv')
vnoremap('>', '>gv')

-- buffers
nnoremap('<leader>bn', ':bn<cr>')
nnoremap('<leader>bp', ':bp<cr>')
nnoremap('<leader>bl', ':buffers<cr>:buffer<space>')
nnoremap('<leader>bd', ':bd!<cr>')

-- quick list
nnoremap('<leader>qn', ':cn<cr>')
nnoremap('<leader>qp', ':cp<cr>')
nnoremap('<leader>ql', toggle_qf, { nowait = false })
nnoremap('<leader>qq', ':cex []<cr>')

-- better command mode navigation
cnoremap('<C-b>', '<Left>')
cnoremap('<C-f>', '<Right>')
cnoremap('<C-n>', '<Down>')
cnoremap('<C-p>', '<Up>')
cnoremap('<C-e>', '<End>')
cnoremap('<C-a>', '<Home>')
cnoremap('<C-d>', '<Del>')
cnoremap('<C-h>', '<BS>')

-- diagnostics
nnoremap('<leader>ds', function()
  vim.diagnostic.open_float(0, { scope = 'line' })
end)
nnoremap('<leader>dn', function()
  vim.diagnostic.goto_next { float = false }
end)
nnoremap('<leader>dp', function()
  vim.diagnostic.goto_prev { float = false }
end)

-- Terminal window escape
tnoremap('<C-x><C-o>', '<C-\\><C-n>')

-- lsp
_.lsp = _.lsp or {}
_.lsp.mappings = {
  n = {
    { ',f', vim.lsp.buf.formatting, 'document_formatting' },
    { 'gr', vim.lsp.buf.references, 'find_references' },
    { 'K', vim.lsp.buf.hover, 'hover' },
    { 'gi', vim.lsp.buf.implementation, 'implementation' },
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

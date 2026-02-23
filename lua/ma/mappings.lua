local utils = require 'ma.utils'

local keymap = vim.keymap.set

-- system clipboard
keymap({ 'n', 'x' }, '<leader>y', '"+y')
keymap('n', '<leader>Y', '"+Y')
keymap('n', '<leader>p', '"+p')
keymap('n', '<leader>P', '"+P')
keymap('x', '<leader>p', '"_d"+P')

-- navigation & find & search
keymap('n', '<leader>ff', ':find<space>')
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

-- quick list
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

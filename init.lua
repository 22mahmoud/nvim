vim.loader.enable()

local o = vim.opt
local keymap = vim.keymap.set

-- plugins
vim.pack.add({
  "https://github.com/tpope/vim-surround",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter"
})

-- options
vim.g.mapleader = ' '

o.lazyredraw = true
o.exrc = true
o.mouse = 'a'
o.confirm = true
o.clipboard = 'unnamedplus'
o.wrap = false
o.winborder = 'single'
o.signcolumn = 'yes'
o.colorcolumn = '80'
o.list = true
o.listchars = {
  trail = '•',
  tab = '» ',
  nbsp = '␣',
}

o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

o.hlsearch = false
o.smartcase = true
o.ignorecase = true

o.splitbelow = true
o.splitright = true

o.swapfile = false
o.undofile = true
o.undolevels = 10000

o.completeopt = { 'menuone', 'noselect', 'fuzzy', 'nosort' }
o.pummaxwidth = 100
o.pumheight = 30
o.pumblend = 5
o.wildmode = { 'longest:full', 'full' }
o.wildoptions = 'pum,fuzzy'
o.wildignorecase = true
o.wildignore = {
  '*.out',
  '*.o',
  '*/.next/*',
  '*/node_modules/*',
  '*/.git/*',
}

-- mappings

-- navigation & find & search
keymap('n', '<leader>p', ':find<space>')
keymap('n', '<leader>rg', [[:silent grep ''<left>]])
keymap('n', '<leader>gw', ':silent grep <C-R>=expand("<cword>")<CR><CR>')

-- better movement between window buffers
keymap('n', '<c-k>', '<c-w><c-k>')
keymap('n', '<c-h>', '<c-w><c-h>')
keymap('n', '<c-j>', '<c-w><c-j>')
keymap('n', '<c-l>', '<c-w><c-l>')

-- better indenting experience
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- buffers
keymap('n', '<s-l>', ':bn<cr>')
keymap('n', '<s-h>', ':bp<cr>')
keymap('n', '<leader>bl', ':ls t<cr>:b<space>')
keymap('n', '<leader>bd', ':bd!<cr>')

-- quick list
keymap('n', '<leader>qn', ':cn<cr>zz')
keymap('n', '<leader>qp', ':cp<cr>zz')
keymap('n', '<leader>ql', function()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  local action = qf_winid > 0 and 'cclose' or 'copen'
  vim.cmd('botright ' .. action)
end)
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

-- config
vim.lsp.enable({ 'lua_ls', 'ts_ls', 'html_ls', 'css_ls', 'jsonls' })

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  ensure_installed = { 'lua', 'jsonc', 'json' },
  indent = { enable = true },
}

require("gruvbox").setup({ transparent_mode = true })
vim.cmd("colorscheme gruvbox")

local o = vim.opt
local g = vim.g

g.mapleader = ' '
g.maplocalleader = ','

-- skip vim plugins
g.loaded_2html_plugin = 1
g.loaded_logipat = 1
g.loaded_matchparen = 1
g.loaded_netrw = 1
g.loaded_netrwFileHandlers = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_rrhelper = 1
g.loaded_spellfile_plugin = 1
g.loaded_tar = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_fzf = 1
g.loaded_zipPlugin = 1
g.loaded_gzip = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_matchit = 1

-- fold
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- base
o.mouse = 'a'
o.scrolloff = 10
o.showmode = false
o.confirm = true
o.title = true
o.titlestring = '%<%F - nvim'
o.clipboard = 'unnamedplus'
o.virtualedit = 'block'
o.exrc = true
o.updatetime = 200
o.timeoutlen = 300
o.colorcolumn = '80'
vim.opt.grepprg =
  [[rg --hidden --glob "!.git" --glob "!**/node_modules/**" --glob "!**/*.lock" --no-heading --smart-case --vimgrep --follow]]

-- ui/display
o.wrap = false
o.termguicolors = true
o.laststatus = 3
o.signcolumn = 'yes'
o.winborder = 'single'
o.shortmess:append { W = true, a = true }
o.list = true
o.listchars = {
  trail = '•',
  tab = '» ',
  nbsp = '␣',
  -- eol = '↲',
  -- space = '⋅',
  -- extends = '❯',
  -- precedes = '❮',
  -- conceal = '┊',
}

require('vim._extui').enable {
  enable = true,
  msg = {
    target = 'cmd',
    timeout = 4000,
  },
}

-- indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- better split behavior
o.splitbelow = true
o.splitright = true

-- backup
o.swapfile = false
o.undofile = true
o.undolevels = 10000

-- search
o.hlsearch = false
o.smartcase = true
o.ignorecase = true

-- completion/menus
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
  '*/__pycache__/*',
  '*/.git/*',
}

-- diagnostics
vim.diagnostic.config {
  severity_sort = true,
  underline = true,
  -- virtual_lines = { current_line = true },
  virtual_text = {
    prefix = '',
    severity = nil,
    source = 'if_many',
    format = nil,
  },
  update_in_insert = false,
  float = {
    header = '',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
  },
}

local o = vim.opt

-- base
o.mouse = 'a'
o.scrolloff = 10
o.showmode = false
o.confirm = true
o.title = true
o.titlestring = '%<%F - nvim'
o.clipboard = 'unnamedplus'
o.virtualedit = 'block'
o.updatetime = 200
o.timeoutlen = 300
o.colorcolumn = '80'

-- ui/display
o.wrap = false
o.termguicolors = true
o.laststatus = 3
o.signcolumn = 'yes'
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
o.completeopt = { 'fuzzy', 'menu', 'menuone', 'noselect' }
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

-- diagnostics
vim.diagnostic.config {
  severity_sort = true,
  underline = true,
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

local o = vim.opt

-- base
o.scrolloff = 10
o.mouse = 'a'
o.mousefocus = true
o.emoji = false
o.confirm = true
o.lazyredraw = true
o.showcmd = false
o.showmode = false
o.title = true
o.titlestring = '%<%F - nvim'
o.clipboard = 'unnamedplus'
o.encoding = 'utf8'
o.fileformats = { 'unix', 'mac', 'dos' }
o.updatetime = 0
o.timeout = true
o.timeoutlen = 500
o.ttimeoutlen = 10
o.showtabline = 0
o.virtualedit = 'block'
o.viewoptions = 'cursor,folds'
o.exrc = true
o.shell = 'bash'
o.ff = 'unix'

-- o.foldenable = false
-- o.foldmethod = 'expr'
-- o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- o.foldtext = 'v:lua.vim.treesitter.foldtext()'
-- o.fillchars = { foldclose = '', foldopen = '' }

-- ui/display
o.wrap = false
o.termguicolors = true
o.textwidth = 80
o.laststatus = 3
o.conceallevel = 2
o.signcolumn = 'yes'
o.colorcolumn = '+1'
o.showmatch = true
o.shortmess:append 'A'
o.shortmess:append 'I'
o.shortmess:append 'O'
o.shortmess:append 'T'
o.shortmess:append 'W'
o.shortmess:append 'a'
o.shortmess:append 'o'
o.shortmess:append 't'
o.list = false
o.listchars = {
  eol = '↲',
  space = '⋅',
  trail = '•',
  extends = '❯',
  precedes = '❮',
  conceal = '┊',
  nbsp = '␣',
}

o.diffopt = {
  'vertical',
  'algorithm:histogram',
  'indent-heuristic',
  'hiddenoff',
  'linematch:60',
}

-- indentation
o.softtabstop = 2
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- better split behavior
o.splitbelow = true
o.splitright = true
o.equalalways = false

-- better grip with 'rg'
if vim.fn.executable 'rg' == 1 then
  o.grepprg = [[rg --hidden --smart-case --vimgrep]]
  o.grepformat = { '%f:%l:%c:%m,%f:%l:%m' }
end

-- backup
o.backup = false
o.writebackup = false
o.swapfile = false
o.undofile = true
o.undolevels = 10000

-- search
o.incsearch = true
o.hlsearch = false
o.smartcase = true
o.ignorecase = true

-- completion/menus
o.path = { '.', ',' }
o.completeopt = { 'menuone', 'noselect', 'noinsert' }
o.complete = { '.', 'b' }
o.pumheight = 15
o.pumblend = 10
o.wildmode = { 'longest:full', 'full' }
o.wildoptions = 'pum'
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

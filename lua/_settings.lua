local cmd = vim.cmd

local apply_options = function(opts)
  for k, v in pairs(opts) do
    if v == true then
      cmd("set " .. k)
    elseif v == false then
      cmd(string.format("set no%s", k))
    else
      cmd(string.format("set %s=%s", k, v))
    end
  end
end

local opts = {
  termguicolors = true,
  hidden = true,
  fileformats = "unix,mac,dos",
  magic = true,
  virtualedit = "block",
  encoding = "utf-8",
  viewoptions = "folds,cursor,curdir,slash,unix",
  sessionoptions = "curdir,help,tabpages,winsize",
  clipboard = "unnamedplus",
  wildignorecase = true,
  wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
  backup = false,
  writebackup = false,
  swapfile = false,
  undofile = true,
  undodir = "~/.config/nvim/undodir",
  history = 2000,
  shada = "!,'300,<50,@100,s10,h",
  smarttab = true,
  shiftround = true,
  timeout = true,
  ttimeout = true,
  timeoutlen = 500,
  ttimeoutlen = 10,
  updatetime = 100,
  redrawtime = 1500,
  ignorecase = true,
  smartcase = true,
  infercase = true,
  incsearch = true,
  hlsearch = false,
  complete = ".,w,b,k",
  inccommand = "split",
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg\\ --hidden\\ --vimgrep\\ --smart-case\\ --",
  breakat = [[\ \	;:,!?]],
  startofline = false,
  splitbelow = true,
  splitright = true,
  switchbuf = "useopen",
  backspace = "indent,eol,start",
  diffopt = "filler,iwhite,internal,algorithm:patience",
  completeopt = "menu,menuone,noselect",
  jumpoptions = "stack",
  showmode = false,
  shortmess = "aoOTIcF",
  scrolloff = 2,
  sidescrolloff = 5,
  foldlevelstart = 99,
  ruler = false,
  list = true,
  showtabline = 2,
  winwidth = 30,
  winminwidth = 10,
  pumheight = 15,
  helpheight = 12,
  previewheight = 12,
  showcmd = false,
  cmdheight = 2,
  cmdwinheight = 5,
  equalalways = false,
  laststatus = 2,
  display = "lastline",
  showbreak = "↳  ",
  listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
  pumblend = 10,
  winblend = 10,
  synmaxcol = 2500,
  formatoptions = "1jcroql",
  textwidth = 80,
  expandtab = true,
  autoindent = true,
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = -1,
  breakindentopt = "shift:2,min:20",
  wrap = false,
  linebreak = true,
  colorcolumn = "80",
  foldenable = true,
  signcolumn = "yes",
  conceallevel = 2,
  concealcursor = "niv"
}

vim.g.mapleader = " "

-- use volta(a node version manager) as node provider
if vim.fn.executable("volta") then
  vim.g.node_host_prog =
    vim.fn.trim(vim.fn.system("volta which neovim-node-host"))
end

apply_options(opts)

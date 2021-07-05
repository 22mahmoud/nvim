local indentation = {
  wrap = false,
  softtabstop = 2,
  textwidth = 80,
  shiftwidth = 2,
  expandtab = true,
  autoindent = true,
  shiftround = true
}

local timings = {
  updatetime = 300,
  timeout = true,
  timeoutlen = 500,
  ttimeoutlen = 10
}

local win_buff = {
  hidden = true,
  splitbelow = true,
  splitright = true,
  scrolloff = 10,
  equalalways = false,
  laststatus = 2
}

local grep = {}
if vim.fn.executable("rg") then
  grep = {
    grepprg = [[rg --hidden --smart-case --vimgrep]],
    grepformat = {"%f:%l:%c:%m"}
  }
end

local complete = {
  path = {".", ","},
  completeopt = {"menuone", "noselect"},
  complete = {".", "w", "b", "k"},
  pumheight = 15,
  pumblend = 10,
  wildmode = {"longest:full", "full"},
  wildcharm = vim.fn.char2nr [[\<C-Z>]],
  wildoptions = "pum",
  wildignorecase = true,
  wildignore = {
    "*.aux",
    "*.out",
    "*.toc",
    "*.o",
    "*.obj",
    "*.dll",
    "*.jar",
    "*.pyc",
    "*.rbc",
    "*.class",
    "*.gif",
    "*.ico",
    "*.jpg",
    "*.jpeg",
    "*.png",
    "*.avi",
    "*.wav",
    "*.webm",
    "*.eot",
    "*.otf",
    "*.ttf",
    "*.woff",
    "*.doc",
    "*.pdf",
    "*.zip",
    "*.tar.gz",
    "*.tar.bz2",
    "*.rar",
    "*.tar.xz",
    ".sass-cache",
    "*/vendor/gems/*",
    "*/vendor/cache/*",
    "*/.bundle/*",
    "*.gem",
    "*/node_modules/*",
    "*/.git/*",
    -- Temp/System
    "*.*~",
    "*~ ",
    "*.swp",
    ".lock",
    ".DS_Store",
    "._*",
    "tags.lock"
  }
}

local display = {
  conceallevel = 2,
  breakindentopt = "sbr",
  linebreak = true,
  signcolumn = "auto",
  ruler = false,
  colorcolumn = {"+1"},
  list = true,
  listchars = {
    eol = " ",
    tab = "│ ",
    extends = "»",
    precedes = "«",
    trail = "•"
  }
}

local search = {
  hlsearch = false,
  incsearch = true,
  smartcase = true,
  ignorecase = true
}

local general = {
  clipboard = "unnamedplus",
  termguicolors = true,
  encoding = "utf-8",
  fileformats = {"unix", "mac", "dos"},
  inccommand = "split",
  showcmd = false,
  shada = {"!", "'1000", "<50", "s10", "h"},
  shortmess = "aoOTIcF"
}

local backup = {
  backup = false,
  writebackup = false,
  swapfile = false,
  undofile = true,
  undodir = vim.fn.stdpath("data") .. "/undo"
}

local mouse = {
  mouse = "a",
  mousefocus = true
}

local options =
  vim.tbl_deep_extend(
  "force",
  indentation,
  timings,
  win_buff,
  grep,
  complete,
  display,
  search,
  general,
  backup,
  mouse,
  vim.opt
)

for k, v in pairs(options) do
  vim.opt[k] = v
end

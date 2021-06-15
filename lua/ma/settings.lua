vim.cmd [[colorscheme gruvbox8_hard]]

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
  scrolloff = 10
}

local grep = {
  grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]],
  grepformat = {"%f:%l:%c:%m"}
}

local wildmode = {
  path = {".", "**"},
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
    -- Cache
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
  inccommand = "split",
  showcmd = false,
  shada = {"!", "'1000", "<50", "s10", "h"},
  completeopt = {"menuone", "noselect"}
}

local backup = {
  backup = false,
  writebackup = false,
  swapfile = false,
  undofile = true,
  undodir = "/home/ashraf/.local/share/nvim/undo"
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
  wildmode,
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

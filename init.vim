lua << EOF
  -- configure runtimepath
  vim.opt.packpath = { vim.fn.stdpath 'data' .. '/site' }
  vim.opt.runtimepath:remove('/usr/share/vim/vimfiles')
  vim.opt.runtimepath:remove('/etc/xdg/nvim')
  vim.opt.runtimepath:remove('/etc/xdg/nvim/after')
  vim.opt.runtimepath:remove('/usr/lib/nvim')

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- skip vim plugins
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_gzip = 1
  vim.g.loaded_logipat = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_spellfile_plugin = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_fzf = 1
  vim.g.loaded_zipPlugin = 1

  -- disable python2
  vim.g.python_host_skip_check = 1
  vim.g.loaded_python_provider = 0

  -- disable perl
  vim.g.perl_host_skip_check = 1
  vim.g.loaded_perl_provider = 0

  -- python3
  vim.g.python3_host_skip_check = 1
  if vim.fn.executable 'python3' then
    vim.g.python3_host_prog = vim.fn.exepath 'python3'
  else
    vim.g.loaded_python3_provider = 0
  end

  -- node
  if vim.fn.executable 'neovim-node-host' then
    if vim.fn.executable 'volta' then
      vim.g.node_host_prog = vim.fn.trim(vim.fn.system 'volta which neovim-node-host')
    else
      vim.g.node_host_prog = vim.fn.exepath 'neovim-node-host'
    end
  else
    vim.g.loaded_node_provider = 0
  end

  -- ruby
  if vim.fn.executable 'neovim-ruby-host' then
    vim.g.ruby_host_prog = vim.fn.exepath 'neovim-ruby-host'
  else
    vim.g.loaded_ruby_provider = 0
  end

  _G.G = {}

  require 'ma.utils'
  require 'ma.fun'

  local function user_highlights()
    vim.cmd [[hi Normal   guibg=NONE ctermbg=NONE]]
    vim.cmd [[hi NormalNC guibg=NONE ctermbg=NONE]]

    vim.cmd [[hi SignColumn        guibg=NONE ctermbg=NONE]]
    vim.cmd [[hi LspReferenceText  gui=NONE]]
    vim.cmd [[hi LspReferenceRead  gui=NONE]]
    vim.cmd [[hi LspReferenceWrite gui=NONE]]

    vim.cmd [[hi GitGutterAdd           guibg=NONE]]
    vim.cmd [[hi GitGutterChange        guibg=NONE]]
    vim.cmd [[hi GitGutterDelete        guibg=NONE]]
    vim.cmd [[hi GitGutterChangeDelete  guibg=NONE]]
  end

  G.augroup('UserHighlights', {
    {
      events = { 'ColorScheme' },
      targets = { '*' },
      command = function()
        user_highlights()
      end,
    },
  })

  require 'ma.settings'
  require 'ma.mappings'
  require 'ma.commands'
  require 'ma.statusline'
  require 'ma.comment'
  require 'ma.plugins'
EOF

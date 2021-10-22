lua << EOF
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
  vim.g.loaded_zipPlugin = 1

  _G.G = {}

  require 'ma.providers'
  require 'ma.utils'
  require 'ma.fun'
  require 'ma.highlight'
  require 'ma.settings'
  require 'ma.mappings'
  require 'ma.commands'
  require 'ma.statusline'
  require 'ma.comment'
  require 'ma.plugins'
EOF

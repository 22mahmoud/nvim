-- configure runtimepath
vim.opt.packpath = { vim.fn.stdpath 'data' .. '/site' }
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles'
vim.opt.runtimepath:remove '/etc/xdg/nvim'
vim.opt.runtimepath:remove '/etc/xdg/nvim/after'
vim.opt.runtimepath:remove '/usr/lib/nvim'

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
    vim.g.node_host_prog = vim.fn.trim(
      vim.fn.system 'volta which neovim-node-host'
    )
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
local utils = require 'ma.utils'

utils.bootstrap()

local set_hl = function(...)
  vim.api.nvim_set_hl(0, ...)
end

local function user_highlights()
  set_hl('Normal', { bg = 'NONE' })
  set_hl('NormalNC', { bg = 'NONE' })
  set_hl('SignColumn', { bg = 'NONE' })

  set_hl('SignColumn', { gui = 'NONE' })
  set_hl('LspReferenceText', { gui = 'NONE' })
  set_hl('LspReferenceRead', { gui = 'NONE' })
  set_hl('LspReferenceWrite', { gui = 'NONE' })
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
require 'ma.statusline'
require 'ma.plugins'

-- Load .nvimrc manually
local local_vimrc = vim.fn.getcwd() .. '/.nvimrc.lua'
if vim.loop.fs_stat(local_vimrc) then
  vim.cmd(string.format('so %s', local_vimrc))
end

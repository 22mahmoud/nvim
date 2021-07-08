vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- skip vim plugins
vim.g.did_install_default_menus = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require "ma.providers"
require "ma.highlight"
require "ma.settings"
require "ma.mappings"

vim.cmd [[runtime! packer/packer_compiled.lua]]
require "ma.plugins"

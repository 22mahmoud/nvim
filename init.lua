vim.loader.enable()
vim.go.packpath = vim.fn.stdpath 'data' .. '/site'

_G.G = {}

require 'ma.utils'
require 'ma.providers'
require 'ma.options'
require 'ma.lsp'
require 'ma.mappings'
require 'ma.autocmds'
require 'ma.statusline'
require 'ma.plugins'

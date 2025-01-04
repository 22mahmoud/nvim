vim.loader.enable()
vim.go.packpath = vim.fn.stdpath 'data' .. '/site'

_G.G = {}

require 'ma.utils'
require 'ma.global'
require 'ma.providers'
require 'ma.plugins'
require 'ma.settings'
require 'ma.mappings'
require 'ma.autocmds'
require 'ma.statusline'
require 'ma.highlight'

require('ma.lsp').setup {
  'ts_ls',
  'biome',
  'jsonls',
  'yamlls',
  'tailwindcss',
  'graphql',
  'lua_ls',
  'efm',
  'ccls',
  'bashls',
  'gopls',
}

require 'ma.exrc'

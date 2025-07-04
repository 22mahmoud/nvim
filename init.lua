vim.loader.enable()
vim.go.packpath = vim.fn.stdpath 'data' .. '/site'

local servers = {
  'ts_ls',
  'biome',
  'html',
  'cssls',
  'css_variables',
  'jsonls',
  'yamlls',
  'tailwindcss',
  'graphql',
  'lua_ls',
  'efm',
  'ccls',
  'bashls',
  'gopls',
  'dockerls',
  'phpactor',
  'taplo',
  'pyright',
  'ruff',
  'djlsp',
}

_G.G = {}

require 'ma.options'
require 'ma.utils'
require 'ma.options'
require('ma.lsp').setup(servers)
require 'ma.mappings'
require 'ma.autocmds'
require 'ma.statusline'
require 'ma.providers'
require 'ma.plugins'
require 'ma.exrc'

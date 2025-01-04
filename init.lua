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
local lsp = require 'ma.lsp'

lsp.setup {
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
}

-- load .nvimrc manually
local project_marker = { '.nvimrc.lua' }
local project_root = vim.fs.root(0, project_marker) or vim.env.HOME
local local_vimrc = vim.fs.joinpath(project_root, '.nvimrc.lua')
if vim.uv.fs_stat(local_vimrc) then
  local source = vim.secure.read(local_vimrc)
  if not source then return end
  vim.cmd(string.format('so %s', local_vimrc))
end

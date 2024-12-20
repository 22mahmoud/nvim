vim.loader.enable()
vim.go.packpath = vim.fn.stdpath 'data' .. '/site'
_G.G = {}

require 'ma.utils'
require 'ma.global'
require 'ma.settings'
require 'ma.mappings'
require 'ma.autocmds'
require 'ma.lsp'
require 'ma.statusline'
require 'ma.plugins'
require 'ma.highlight'

local rc = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, 'nvimrc.lua')
if vim.uv.fs_stat(rc) then vim.cmd(string.format('so %s', rc)) end

-- load .nvimrc manually
local project_marker = { '.nvimrc.lua' }
local project_root = vim.fs.root(0, project_marker) or vim.env.HOME
local local_vimrc = vim.fs.joinpath(project_root, '.nvimrc.lua')
if vim.uv.fs_stat(local_vimrc) then
  local source = vim.secure.read(local_vimrc)
  if not source then return end
  vim.cmd(string.format('so %s', local_vimrc))
end

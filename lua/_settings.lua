local wo = vim.wo
local o = vim.o
local bo = vim.bo
local g = vim.g
local home = vim.fn.expand("$XDG_CONFIG_HOME")

if vim.fn.executable("volta") then
  vim.g.node_host_prog = vim.fn.trim(vim.fn.system("volta which neovim-node-host"))
end

g.mapleader = " "

vim.api.nvim_command("set nocompatible")

-- wo.cursorline = true
-- wo.number = true
-- wo.relativenumber = true
-- wo.signcolumn = "number"

wo.colorcolumn = "80"
o.termguicolors = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
bo.expandtab = true
bo.tabstop = 2
bo.smartindent = true
bo.shiftwidth = 2
wo.scrolloff = 8

o.updatetime = 50
o.hidden = true
wo.wrap = false

o.splitbelow = true
o.splitright = true

o.ignorecase = true
o.smartcase = true

o.clipboard = "unnamedplus"

-- Backup, undo, swap options
o.undofile = true
o.backup = true
o.writebackup = true
o.backupdir = home .. "/nvim/tmp/dir_backup/"
o.directory = home .. "/nvim/tmp/dir_swap/," .. o.directory
o.undodir = home .. "/nvim/tmp/dir_undo/"

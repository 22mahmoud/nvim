local wo = vim.wo
local o = vim.o
local bo = vim.bo
local g = vim.g

g.mapleader = ' '

wo.cursorline = true
wo.relativenumber = true
wo.signcolumn= 'number'

o.cc = '80'
o.termguicolors = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
bo.expandtab = true
bo.tabstop = 2
bo.smartindent = true
bo.shiftwidth = 2

o.updatetime = 50
o.hidden = true
o.backup = false
o.writebackup = false
bo.swapfile = false
wo.wrap = false

o.splitbelow = true
o.splitright = true

o.ignorecase = true
o.smartcase = true

o.clipboard = 'unnamedplus'

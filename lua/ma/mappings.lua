local utils = require("ma.utils")

local nnoremap = utils.nnoremap
local cnoremap = utils.cnoremap
local vnoremap = utils.vnoremap

vim.g.mapleader = " "

-- navigation
nnoremap("<leader>p", ":find ", {silent = false})

-- better movement between window buffers
nnoremap("<c-k>", "<c-w><c-k>")
nnoremap("<c-h>", "<c-w><c-h>")
nnoremap("<c-j>", "<c-w><c-j>")
nnoremap("<c-l>", "<c-w><c-l>")

-- better yank behaviour
nnoremap("Y", "y$")

-- better indenting experience
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- buffers
nnoremap("<leader>bn", ":bn<cr>")
nnoremap("<leader>bp", ":bp<cr>")
nnoremap("<leader>bl", ":buffers<cr>")
nnoremap("<leader>bd", ":bd!<cr>")

-- quick list
nnoremap("<leader>cn", ":cn<cr>")
nnoremap("<leader>cp", ":cp<cr>")
nnoremap("<leader>cl", ":copen<cr>", {nowait = false})
nnoremap("<leader>cc", ":cex []<cr>")

-- better command mode navigation
cnoremap("<C-b>", "<Left>")
cnoremap("<C-f>", "<Right>")
cnoremap("<C-n>", "<Down>")
cnoremap("<C-p>", "<Up>")
cnoremap("<C-e>", "<End>")
cnoremap("<C-a>", "<Home>")
cnoremap("<C-d>", "<Del>")
cnoremap("<C-h>", "<BS>")
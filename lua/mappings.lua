local utils = require("utils")

local nmap = utils.nmap
local cmap = utils.cmap
local vmap = utils.vmap

vim.cmd [[let mapleader="\<space>"]]

-- better movement between window buffers
nmap("<c-h>", "<c-w><c-h>")
nmap("<c-j>", "<c-w><c-j>")
nmap("<c-k>", "<c-w><c-k>")
nmap("<c-l>", "<c-w><c-l>")

-- better yank behaviour
nmap("Y", "y$")

-- better indenting experience
vmap("<", "<gv")
vmap(">", ">gv")

-- buffers
nmap("<leader>bn", ":bn<cr>")
nmap("<leader>bp", ":bp<cr>")
nmap("<leader>bs", ":buffers<cr>")
nmap("<leader>bd", ":bd!<cr>")

-- quick list
nmap("<leader>cn", ":cn<cr>")
nmap("<leader>cp", ":cp<cr>")
nmap("<leader>cs", ":copen<cr>", {nowait = false})
nmap("<leader>cc", ":cex []<cr>")

-- better command mode navigation
cmap("<C-b>", "<Left>")
cmap("<C-f>", "<Right>")
cmap("<C-n>", "<Down>")
cmap("<C-p>", "<Up>")
cmap("<C-e>", "<End>")
cmap("<C-a>", "<Home>")
cmap("<C-d>", "<Del>")
cmap("<C-h>", "<BS>")

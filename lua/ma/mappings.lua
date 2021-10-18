local utils = require("ma.utils")

local nnoremap = utils.nnoremap
local cnoremap = utils.cnoremap
local vnoremap = utils.vnoremap
local tnoremap = utils.tnoremap
local inoremap = utils.inoremap
local toggle_qf = utils.toggle_qf

-- navigation & find & search
nnoremap("<leader>p", ":find<space>", {silent = false})
nnoremap("<leader>rg", ":grep<space>", {silent = false})
nnoremap("<leader>gw", ":grep <cword> . <cr>")

-- Move selected line / block of text in visual mode
vnoremap("J", ":move '>+1<CR>gv-gv")
vnoremap("K", ":move '<-2<CR>gv-gv")

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
nnoremap("<leader>bl", ":buffers<cr>:buffer<space>")
nnoremap("<leader>bd", ":bd!<cr>")

-- quick list
nnoremap("<leader>qn", ":cn<cr>")
nnoremap("<leader>qp", ":cp<cr>")
nnoremap("<leader>ql", toggle_qf, {nowait = false})
nnoremap("<leader>qq", ":cex []<cr>")

-- better command mode navigation
cnoremap("<C-b>", "<Left>")
cnoremap("<C-f>", "<Right>")
cnoremap("<C-n>", "<Down>")
cnoremap("<C-p>", "<Up>")
cnoremap("<C-e>", "<End>")
cnoremap("<C-a>", "<Home>")
cnoremap("<C-d>", "<Del>")
cnoremap("<C-h>", "<BS>")

-- diagnostics
nnoremap("<leader>ds", vim.diagnostic.show_line_diagnostics)
nnoremap("<leader>dn", vim.diagnostic.goto_next)
nnoremap("<leader>dp", vim.diagnostic.goto_prev)

-- Terminal window escape
tnoremap("<C-x><C-o>", "<C-\\><C-n>")

local utils = require("ma.utils")

local map = vim.fn.map
local copy = vim.fn.copy
local setqflist = vim.fn.setqflist

local nnoremap = utils.nnoremap
local imap = utils.imap


local function build_quickfix_list(lines)
  setqflist(map(copy(lines), '{"filename": v:val}'))
  vim.cmd [[copen]]
  vim.cmd [[cc]]
end

vim.g.fzf_action = {
  ["ctrl-q"] = build_quickfix_list,
  ["ctrl-s"] = "split",
  ["ctrl-f"] = "ssplit",
  ["ctrl-t"] = "tab split",
  ["ctrl-v"] = "vsplit"
}

vim.g.fzf_layout = {
  down = "40%"
}

nnoremap("<leader>p", ":Files<cr>")
nnoremap("<leader>bl", ":Buffers<cr>")
nnoremap("<leader>rg", ":Rg!<space>", {silent = false})

imap("<c-x><c-k>", "<plug>(fzf-complete-word)")


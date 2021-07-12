local M = {}

function M.config()
  local utils = require("ma.utils")

  local nnoremap = utils.nnoremap
  local map = vim.fn.map
  local copy = vim.fn.copy
  local setqflist = vim.fn.setqflist

  nnoremap("<leader>p", ":Files<cr>")
  nnoremap("<leader>bl", ":Buffers<cr>")
  nnoremap("<leader>rg", ":Rg!<space>", {silent = false})

  local function build_quickfix_list(lines)
    setqflist(map(copy(lines), '{"filename": v:val}'))
    vim.cmd [[copen]]
    vim.cmd [[cc]]
  end

  vim.env["FZF_DEFAULT_OPTS"] =
    (vim.env["FZF_DEFAULT_OPTS"] or "") .. " " .. '--bind "alt-a:select-all"'

  vim.g.fzf_preview_window = "right:border-left"

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
end

return M

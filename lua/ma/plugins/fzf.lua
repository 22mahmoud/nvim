local M = {}

function M.config()
  local utils = require "ma.utils"
  local actions = require "fzf-lua.actions"
  local fzf_lua = require "fzf-lua"

  local nnoremap = utils.nnoremap
  local map = vim.fn.map
  local setqflist = vim.fn.setqflist

  nnoremap("<leader>p", fzf_lua.files)
  nnoremap("<leader>bl", fzf_lua.buffers)
  nnoremap("<leader>rg", fzf_lua.grep, {silent = false})
  nnoremap("<leader>gw", fzf_lua.grep_cword)

  fzf_lua.setup {
    winopts = {
      win_height = 0.6,
      win_width = 1,
      win_row = 1,
      win_col = 0,
      win_border = false
    },
    fzf_layout = "reverse",
    fzf_args = "",
    fzf_binds = {
      "ctrl-/:toggle-preview",
      "f3:toggle-preview-wrap",
      "shift-down:preview-page-down",
      "shift-up:preview-page-up",
      "ctrl-d:half-page-down",
      "ctrl-u:half-page-up",
      "ctrl-f:page-down",
      "ctrl-b:page-up",
      "ctrl-a:toggle-all",
      "ctrl-l:clear-query"
    },
    preview_border = "noborder", -- border|noborder
    preview_wrap = "nowrap", -- wrap|nowrap
    preview_opts = "hidden", -- hidden|nohidden
    preview_vertical = "down:45%", -- up|down:size
    preview_horizontal = "right:60%", -- right|left:size
    preview_layout = "flex", -- horizontal|vertical|flex
    flip_columns = 120, -- #cols to switch to horizontal on flex
  }
end

return M

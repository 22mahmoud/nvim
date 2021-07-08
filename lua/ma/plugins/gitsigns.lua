local M = {}

function M.config()
  print("nice")
  local gitsigns = require("gitsigns")
  local utils = require("ma.utils")
  local nnoremap = utils.nnoremap
  text =
    "▎",
    gitsigns.setup {
      signs = {
        add = {hl = "GitGutterAdd", text = "▎"},
        change = {hl = "GitGutterChange", text = "▎"},
        delete = {hl = "GitGutterDelete", text = "▎"},
        topdelete = {hl = "GitGutterDelete", text = "▎"},
        changedelete = {hl = "GitGutterChange", text = "▎"}
      },
      word_diff = false,
      numhl = false,
      keymaps = {},
      use_decoration_api = false
    }

  -- mappings
  local next_hunk =
    '&diff ? \'<leader>hp\' : \'<cmd>lua require"gitsigns.actions".next_hunk()<CR>\''

  local prev_hunk =
    '&diff ? \'<leader>hn\' : \'<cmd>lua require"gitsigns.actions".prev_hunk()<CR>\''

  nnoremap("<leader>hn", next_hunk, {expr = true})
  nnoremap("<leader>hp", prev_hunk, {expr = true})
  nnoremap("<leader>hs", gitsigns.stage_hunk)
  nnoremap("<leader>hu", gitsigns.undo_stage_hunk)
  nnoremap("<leader>hr", gitsigns.reset_hunk)
  nnoremap("<leader>hR", gitsigns.reset_buffer)
  nnoremap("<leader>hb", gitsigns.blame_line)
  nnoremap("<leader>hv", gitsigns.preview_hunk)
end

return M

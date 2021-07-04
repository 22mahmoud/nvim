local gitsigns = require("gitsigns")
local utils = require("ma.utils")

local nnoremap = utils.nnoremap

gitsigns.setup {
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "▎",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn"
    },
    change = {
      hl = "GitSignsChange",
      text = "▎",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn"
    },
    delete = {
      hl = "GitSignsDelete",
      text = "契",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn"
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "契",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn"
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "▎",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn"
    }
  },
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true
  },
  use_decoration_api = false
}

-- mappings
local next_hunk =
  '&diff ? \']c\' : \'<cmd>lua require"gitsigns.actions".next_hunk()<CR>\''

local prev_hunk =
  '&diff ? \'[c\' : \'<cmd>lua require"gitsigns.actions".prev_hunk()<CR>\''

nnoremap("<leader>hn", next_hunk, {expr = true})
nnoremap("<leader>hp", prev_hunk, {expr = true})
nnoremap("<leader>hs", gitsigns.stage_hunk)
nnoremap("<leader>hu", gitsigns.undo_stage_hunk)
nnoremap("<leader>hr", gitsigns.reset_hunk)
nnoremap("<leader>hR", gitsigns.reset_buffer)
nnoremap("<leader>hp", gitsigns.preview_hunk)
nnoremap("<leader>hb", gitsigns.blame_line)

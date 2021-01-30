local g = vim.g
local map = vim.api.nvim_set_keymap

g.fzf_action = {
  ["ctrl-s"] = "sp",
  ["ctrl-v"] = "vs",
  ["ctrl-t"] = "tab sp"
}

g.fzf_layout = {
  window = {
    width = 1,
    height = 0.4,
    border = "top",
    yoffset = 1
  }
}

g.fzf_preview_window = {"right:+{2}-/2:hidden", "ctrl-/"}

map("n", "<Leader>p", ":Files<CR>", {noremap = true, silent = true})
map("n", "<Leader>f", "<ESC>:Rg<CR>", {noremap = true, silent = true})
map("n", "<Leader>rg", "<ESC>:Rg<Space>", {noremap = true, silent = false})

if vim.fn.exists(':TestFile') == 0 then
  return
end

local utils = require("ma.utils")

local nnoremap = utils.nnoremap

vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vert botright"

nnoremap("<leader>tf", ":TestFile<cr>")
nnoremap("<leader>tn", ":TestNearest<cr>")
nnoremap("<leader>tl", ":TestLast<cr>")
nnoremap("<leader>ts", ":TestSuite<cr>")

local M = {}

function M.setup()
  local utils = require("ma.utils")

  local nnoremap = utils.nnoremap

  nnoremap("<leader>tf", ":TestFile<cr>")
  nnoremap("<leader>tn", ":TestNearest<cr>")
  nnoremap("<leader>tl", ":TestLast<cr>")
  nnoremap("<leader>ts", ":TestSuite<cr>")
end

function M.config()
  vim.g["test#strategy"] = "neovim"
  vim.g["test#neovim#term_position"] = "vert botright"
end

return M

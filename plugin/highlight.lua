local utils = require("ma.utils")

local augroup = utils.augroup

vim.opt.background = "dark"


local function user_highlights()
  vim.cmd [[hi Normal   guibg=NONE ctermbg=NONE]]
  vim.cmd [[hi NormalNC guibg=NONE ctermbg=NONE]]

  vim.cmd [[hi SignColumn        guibg=NONE ctermbg=NONE]]
  vim.cmd [[hi LspReferenceText  gui=NONE]]
  vim.cmd [[hi LspReferenceRead  gui=NONE]]
  vim.cmd [[hi LspReferenceWrite gui=NONE]]

  vim.cmd [[hi DiffAdd     guibg=NONE]]
  vim.cmd [[hi DiffChange  guibg=NONE]]
  vim.cmd [[hi DiffDelete  guibg=NONE]]
  vim.cmd [[hi DiffAdded   guibg=NONE]]
  vim.cmd [[hi DiffFile    guibg=NONE]]
  vim.cmd [[hi DiffNewFile guibg=NONE]]
  vim.cmd [[hi DiffLine    guibg=NONE]]
  vim.cmd [[hi DiffRemoved guibg=NONE]]
end

user_highlights()

augroup(
  "UserHighlights",
  {
    {
      events = {"ColorScheme"},
      targets = {"*"},
      command = function()
        user_highlights()
      end
    }
  }
)

local diffview = require("diffview")

local M = {}

M.config = function()
  diffview.setup {
    file_panel = {
      ["q"] = "<Cmd>DiffviewClose<CR>"
    },
    view = {
      ["q"] = "<Cmd>DiffviewClose<CR>"
    }
  }
end

return M

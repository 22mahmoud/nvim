local neogit = require("neogit")
local utils = require("ma.utils")

local nnoremap = utils.nnoremap

local M = {}

M.config = function()
  neogit.setup {
    integrations = {
      diffview = true
    }
  }

  nnoremap(
    "<leader>gs",
    function()
      neogit.open({kind = "split"})
    end
  )

  nnoremap(
    "<leader>gc",
    function()
      neogit.open({"commit"})
    end
  )

  nnoremap("<leader>gl", neogit.popups.pull.create)
  nnoremap("<leader>gp", neogit.popups.push.create)
end

return M

local M = {}

function M.config()
  require("ma.theme")
  vim.cmd("colorscheme " .. vim.g.base16_theme_name)
end

return M

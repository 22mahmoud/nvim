vim.g.limelight_conceal_ctermfg = "gray"
vim.g.limelight_conceal_ctermfg = 240
vim.g.limelight_conceal_guifg = "DarkGray"
vim.g.limelight_conceal_guifg = "#777777"

local M = {}

M.goyo_enter = function()
  vim.cmd [[lua require("galaxyline").disable_galaxyline()]]
  vim.cmd [[Limelight]]
end

M.goyo_leave = function()
  vim.cmd [[lua require("galaxyline").galaxyline_augroup()]]
  vim.cmd [[Limelight!]]
end

vim.cmd [[autocmd! User GoyoEnter lua require("_goyo").goyo_enter()]]
vim.cmd [[autocmd! User GoyoLeave lua require("_goyo").goyo_leave()]]

return M

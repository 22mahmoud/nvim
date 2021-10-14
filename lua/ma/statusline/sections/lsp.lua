local statusline_utils = require("ma.statusline.utils")

local block = statusline_utils.block

local function get_lsp_diagnostics()
  local get_diag_count = vim.lsp.diagnostic.get_count

  local e = get_diag_count(0, [[Error]])
  local w = get_diag_count(0, [[Warning]])
  local i = get_diag_count(0, [[Information]])
  local h = get_diag_count(0, [[Hint]])

  return table.concat {
    block(e, "E: %s,"),
    block(w, "W: %s,"),
    block(i, "I: %s,"),
    block(h, "H: %s,")
  }:gsub(",%s$", "") -- remove an extra ", " at the end of line
end

return {
  get_lsp_diagnostics = get_lsp_diagnostics
}

local fmt = string.format

local M = {}

function M.block(value, template)
  if (value == 0 or value == "" or value == nil or not value) then
    return ""
  end

  return fmt((template or "%s") .. " ", value)
end

function M.truncat(data, width)
  local is_truncated = vim.api.nvim_win_get_width(0) < (width or -1)

  return is_truncated and data[2] or data[1]
end

return M

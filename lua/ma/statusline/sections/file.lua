local M = {}

local fn = vim.fn
local opt = vim.opt

function M.get_path()
  local file_name = fn.expand '%:~:.:t'
  local base = fn.expand '%:~:.:h'

  base = (base == nil or base == '.') and '' or base:gsub('/$', '') .. '/'

  local path = base .. file_name

  if path == '/' then
    return ''
  end

  return {
    path,
    fn.pathshorten(path),
  }
end

function M.get_file_icon()
  return G.icons[fn.expand '%:t']
end

function M.get_modified_icon()
  return opt.modified:get() and '●' or ''
end

function M.get_readonly_icon()
  local mod = opt.modifiable:get()
  local ro = opt.readonly:get()

  if mod and not ro then
    return ''
  end

  return (ro and mod) and '' or ''
end

return M

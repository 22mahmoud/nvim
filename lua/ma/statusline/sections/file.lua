local statuslien_utils = require("ma.statusline.utils")
local icons = require("ma.utils").icons

local fn = vim.fn
local opt = vim.opt
local fmt = string.format
local block = statuslien_utils.block

local function get_path()
  local file_name = fn.expand("%:~:.:t")
  local base = fn.expand("%:~:.:h")

  base = (base == nil or base == ".") and "" or base:gsub("/$", "") .. "/"

  local path = base .. file_name

  if path == "/" then
    return ""
  end

  return fmt("%s%s", block(icons[file_name]), path), fn.pathshorten(path)
end

local function get_modified_icon()
  return opt.modified:get() and "●" or ""
end

local function get_readonly_icon()
  local mod = opt.modifiable:get()
  local ro = opt.readonly:get()

  if (mod and not ro) then
    return ""
  end

  return (ro and mod) and "" or ""
end

return {
  get_path = get_path,
  get_modified_icon = get_modified_icon,
  get_readonly_icon = get_readonly_icon
}

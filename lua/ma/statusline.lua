local utils = require("ma.utils")

local augroup = utils.augroup
local fmt = string.format
local fn = vim.fn

local M = {}
_G._.statusline = M

local modes = {
  n = "NORMAL",
  i = "INSERT",
  R = "REPLACE",
  v = "VISUAL",
  V = "V-LINE",
  c = "COMMAND",
  [""] = "V-BLOCK",
  s = "SELECT",
  S = "S-LINE",
  [""] = "S-BLOCK",
  t = "TERMINAL"
}

local function get_mode()
  return modes[vim.fn.mode()] or ""
end

local function get_path()
  local file_name = fn.expand("%:~:.:t")
  local base = fn.expand("%:~:.:h")
  base = (base == nil or base == ".") and "" or base:gsub("/$", "") .. "/"

  local path = base .. file_name

  if path == "/" then
    return ""
  end

  local max_len = math.min(35, math.floor(0.6 * fn.winwidth(0)))

  if (#path + #file_name) > max_len then
    return fn.pathshorten(path)
  end

  return path
end

local function modified()
  return vim.opt.modified:get() and "●" or ""
end

local function readonly()
  local mod = vim.opt.modifiable:get()
  local ro = vim.opt.readonly:get()

  if (mod and not ro) then
    return ""
  end

  return (ro and mod) and "" or ""
end

local function sep(value, template)
  if (value == "" or value == nil or not value) then
    return ""
  end

  return fmt((template or "%s") .. " ", value)
end

function M.get_active_statusline()
  local mode = get_mode()
  local path = get_path()
  local modified_icon = modified()
  local readonly_icon = readonly()

  local lhs =
    table.concat {
    sep(mode, "[%s]"),
    sep(path),
    sep(modified_icon),
    sep(readonly_icon)
  }

  local rhs =
    table.concat {
    sep("%l/%c")
  }

  return lhs .. "%=" .. rhs
end

function M.get_inactive_statusline()
  return [[%f %y %m]]
end

local function active()
  vim.opt.statusline = [[%!luaeval("_.statusline.get_active_statusline()")]]
end

local function inactive()
  vim.opt.statusline = [[%!luaeval("_.statusline.get_inactive_statusline()")]]
end

local function setup()
  augroup(
    "StatusLine",
    {
      {
        events = {"WinEnter", "BufEnter"},
        targets = {"*"},
        command = active
      },
      {
        events = {"WinLeave", "BufLeave"},
        targets = {"*"},
        command = inactive
      }
    }
  )
end

setup()

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
  local base = fn.expand("%:~:.:h"):gsub("/$", "") .. "/"
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

function M.get_active_statusline()
  local mode = get_mode()
  local path = get_path()

  return table.concat {
    mode ~= "" and fmt("[%s] ", mode) or "",
    path
  }
end

function M.get_inactive_statusline()
  return "%f"
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

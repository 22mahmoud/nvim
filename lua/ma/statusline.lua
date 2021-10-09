local utils = require("ma.utils")

local augroup = utils.augroup

local M = {}
_G._.statusline = M

function M.get_active_statusline()
  return "%f"
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

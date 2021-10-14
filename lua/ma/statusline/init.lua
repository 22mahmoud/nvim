local utils = require("ma.utils")
local sections = require("ma.statusline.sections")
local statusline_utils = require("ma.statusline.utils")

local block = statusline_utils.block
local augroup = utils.augroup
local truncat = statusline_utils.truncat

local M = {}
_G._.statusline = M

function M.get_active_statusline()
  local mode = sections.get_mode()
  local path = sections.get_path()
  local modified_icon = sections.get_modified_icon()
  local readonly_icon = sections.get_readonly_icon()
  local diagnostics = sections.get_lsp_diagnostics()
  local file_icon = sections.get_file_icon()

  local lhs =
    table.concat {
    block(truncat(mode, 120), "[%s]"),
    block(file_icon),
    block(truncat(path, 120)),
    block(modified_icon),
    block(readonly_icon)
  }

  local rhs =
    table.concat {
    block(diagnostics, "[%s]"),
    block("%l|%c")
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

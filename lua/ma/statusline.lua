local utils = require("ma.utils")

local augroup = utils.augroup
local spawn = utils.spawn
local fmt = string.format
local fn = vim.fn
local uv = vim.loop

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

local function sep(value, template, space)
  if (value == 0 or value == "" or value == nil or not value) then
    return ""
  end

  return fmt((template or "%s") .. (space or " "), value)
end

local function get_lsp_diagnostics()
  local e = vim.lsp.diagnostic.get_count(0, [[Error]])
  local w = vim.lsp.diagnostic.get_count(0, [[Warning]])
  local i = vim.lsp.diagnostic.get_count(0, [[Information]])
  local h = vim.lsp.diagnostic.get_count(0, [[Hint]])

  return table.concat {
    sep(e, "E: %s", ", "),
    sep(w, "W: %s", ", "),
    sep(i, "I: %s", ", "),
    sep(h, "H: %s", ", ")
  }:gsub(",%s$", "") -- remove an extra ", " at the end of line
end

local function find_git_head_file_path(cb)
  local path = fn.expand("%:p:h")
  spawn(
    "git",
    {"-C", path, "rev-parse", "--absolute-git-dir"},
    function(error, data)
      assert(not error, error)
      if data then
        local head_file_path = data:gsub("\n", "") .. "/HEAD"
        if type(cb) == "function" then
          cb(head_file_path)
        end
      end
    end
  )
end

local function git_get_branch_name(path)
  local head_file_handle = io.open(path)

  if not head_file_handle then
    return
  end

  local HEAD = head_file_handle:read()
  local branch = HEAD:match("ref: refs/heads/(.+)$")

  head_file_handle:close()

  return branch or HEAD:sub(1, 6)
end

local fse = nil
local function watch_git_branch_change(path)
  if (fse) then
    fse:stop()
  end

  fse = uv.new_fs_event()
  uv.fs_event_start(
    fse,
    path,
    {},
    vim.schedule_wrap(
      function()
        find_git_head_file_path(
          function(_path)
            vim.g.branch_name = git_get_branch_name(_path)
            watch_git_branch_change(_path)
          end
        )
      end
    )
  )
end

function M.get_active_statusline()
  local mode = get_mode()
  local path = get_path()
  local modified_icon = modified()
  local readonly_icon = readonly()
  local diagnostics = get_lsp_diagnostics()

  local lhs =
    table.concat {
    sep(mode, "[%s]"),
    sep(path),
    sep(vim.g.branch_name, "( %s)"),
    sep(modified_icon),
    sep(readonly_icon)
  }

  local rhs =
    table.concat {
    sep(diagnostics, "[%s]"),
    sep("%l/%c")
  }

  return lhs .. "%=" .. rhs
end

function M.get_inactive_statusline()
  return [[%f %y %m]]
end

local function active()
  find_git_head_file_path(
    function(path)
      vim.g.branch_name = git_get_branch_name(path)
      watch_git_branch_change(path)
    end
  )

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

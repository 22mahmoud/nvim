local fn = vim.fn
local opt = vim.opt
local fmt = string.format

local M = {}

local function block(value, template, space)
  if value == 0 or value == '' or value == nil or not value then
    return ''
  end

  return fmt((template or '%s') .. (space or ' '), value)
end

local function get_path()
  local file_name = fn.expand '%:~:.:t'
  local base = fn.expand '%:~:.:h'

  base = (base == nil or base == '.') and '' or base:gsub('/$', '') .. '/'

  local path = base .. file_name

  if path == '/' then
    return ''
  end

  return path
end

local CTRL_S = vim.api.nvim_replace_termcodes('<C-S>', true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes('<C-V>', true, true, true)

local modes = setmetatable({
  ['n'] = { long = 'Normal', short = 'N' },
  ['v'] = { long = 'Visual', short = 'V' },
  ['V'] = { long = 'V-Line', short = 'V-L' },
  [CTRL_V] = { long = 'V-Block', short = 'V-B' },
  ['s'] = { long = 'Select', short = 'S' },
  ['S'] = { long = 'S-Line', short = 'S-L' },
  [CTRL_S] = { long = 'S-Block', short = 'S-B' },
  ['i'] = { long = 'Insert', short = 'I' },
  ['R'] = { long = 'Replace', short = 'R' },
  ['c'] = { long = 'Command', short = 'C' },
  ['r'] = { long = 'Prompt', short = 'P' },
  ['!'] = { long = 'Shell', short = 'Sh' },
  ['t'] = { long = 'Terminal', short = 'T' },
}, {
  __index = function()
    return { long = 'Unknown', short = 'U' }
  end,
})

local function get_mode()
  local mode = modes[vim.fn.mode()]

  return mode.long
end

local function get_file_icon()
  return G.icons[fn.expand '%:t']
end

local function get_modified_icon()
  return opt.modified:get() and '●' or ''
end

local function get_readonly_icon()
  local mod = opt.modifiable:get()
  local ro = opt.readonly:get()

  if mod and not ro then
    return ''
  end

  return (ro and mod) and '' or ''
end

local function get_lsp_diagnostics()
  local get_diag_count = function(severity)
    return #vim.diagnostic.get(0, { severity = severity })
  end

  local severity = vim.diagnostic.severity

  local e = get_diag_count(severity.ERROR)
  local w = get_diag_count(severity.WARN)
  local i = get_diag_count(severity.INFO)
  local h = get_diag_count(severity.HINT)

  return table.concat({
    block(e, 'E: %s,'),
    block(w, 'W: %s,'),
    block(i, 'I: %s,'),
    block(h, 'H: %s,'),
  }):gsub(',%s$', '') -- remove an extra ", " at the end of line
end

function M.get_statusline()
  local mode = get_mode()
  local path = get_path()
  local modified_icon = get_modified_icon()
  local readonly_icon = get_readonly_icon()
  local diagnostics = get_lsp_diagnostics()
  local file_icon = get_file_icon()

  local lhs = table.concat {
    block(mode, '[%s]'),
    block(file_icon),
    block(path),
    block(modified_icon),
    block(readonly_icon),
  }

  local rhs = table.concat {
    block(diagnostics, '[%s]'),
    block '%l|%c',
  }

  return lhs .. '%=' .. rhs
end

function M.get_winbar()
  local path = get_path()
  local modified_icon = get_modified_icon()
  local file_icon = get_file_icon()

  local lhs = table.concat {
    block(' ', ' '),
    block(file_icon),
    block(path),
    block(modified_icon),
  }

  return lhs
end

local function statusline()
  vim.opt.statusline = "%{%v:lua.require'ma.statusline'.get_statusline()%}"
end

local function winbar()
  vim.opt.winbar = "%{%v:lua.require'ma.statusline'.get_winbar()%}"
end

local function setup()
  statusline()
  winbar()
end

setup()

return M

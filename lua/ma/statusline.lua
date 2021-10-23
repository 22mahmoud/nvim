local fn = vim.fn
local opt = vim.opt
local fmt = string.format

local M = {}
G.statusline = M

local function block(value, template, space)
  if value == 0 or value == '' or value == nil or not value then
    return ''
  end

  return fmt((template or '%s') .. (space or ' '), value)
end

local function truncat(data, width)
  local is_truncated = vim.api.nvim_win_get_width(0) < (width or -1)

  return is_truncated and data[2] or data[1]
end

local function get_path()
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

  return { mode.long, mode.short }
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
  local get_diag_count = vim.lsp.diagnostic.get_count

  local e = get_diag_count(0, [[Error]])
  local w = get_diag_count(0, [[Warning]])
  local i = get_diag_count(0, [[Information]])
  local h = get_diag_count(0, [[Hint]])

  return {
    table.concat({
      block(e, 'E: %s,'),
      block(w, 'W: %s,'),
      block(i, 'I: %s,'),
      block(h, 'H: %s,'),
    }):gsub(',%s$', ''), -- remove an extra ", " at the end of line

    block(w, 'E: %s', ''),
  }
end

function M.get_active_statusline()
  local mode = get_mode()
  local path = get_path()
  local modified_icon = get_modified_icon()
  local readonly_icon = get_readonly_icon()
  local diagnostics = get_lsp_diagnostics()
  local file_icon = get_file_icon()

  local lhs = table.concat {
    block(truncat(mode, 120), '[%s]'),
    block(file_icon),
    block(truncat(path, 120)),
    block(modified_icon),
    block(readonly_icon),
    block(vim.g.git_head, '( %s)'),
  }

  local rhs = table.concat {
    block(truncat(diagnostics, 160), '[%s]'),
    block '%l|%c',
  }

  return lhs .. '%=' .. rhs
end

function M.get_inactive_statusline()
  return [[%f %y %m]]
end

local function active()
  local directory = vim.fn.expand '%:h'

  G.run_command(
    fmt(
      'git -C %s symbolic-ref --short -q HEAD 2>/dev/null || git -C %s rev-parse --short HEAD 2>/dev/null',
      directory,
      directory
    ),
    {
      on_read = function(data)
        vim.g.git_head = unpack(data)
      end,
    }
  )

  vim.opt.statusline = [[%!luaeval("G.statusline.get_active_statusline()")]]
end

local function inactive()
  vim.opt.statusline = [[%!luaeval("G.statusline.get_inactive_statusline()")]]
end

local function setup()
  G.augroup('StatusLine', {
    {
      events = { 'WinEnter', 'BufEnter' },
      targets = { '*' },
      command = active,
    },
    {
      events = { 'WinLeave', 'BufLeave' },
      targets = { '*' },
      command = inactive,
    },
  })
end

setup()

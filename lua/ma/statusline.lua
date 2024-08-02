local fn = vim.fn
local opt = vim.opt
local fmt = string.format
local api = vim.api

local M = {}

local SPECIAL_FILENAME_PATTERNS = {
  '^index%.',
  '^page%.[jt]sx?$',
  '^route%.[jt]sx?$',
  '^error%.[jt]sx?$',
  '^layout%.[jt]sx?$',
  '^opengraph%-image%.[jt]sx?$',
}

local MODE_MAP = {
  ['n'] = { long = 'NORMAL', short = 'N', color = 'StlineNormal' },
  ['v'] = { long = 'VISUAL', short = 'V', color = 'StlineVisual' },
  ['V'] = { long = 'V-LINE', short = 'V-L', color = 'StlineVisual' },
  [api.nvim_replace_termcodes('<C-V>', true, true, true)] = {
    long = 'V-BLOCK',
    short = 'V-B',
    color = 'StlineVisual',
  },
  ['s'] = { long = 'SELECT', short = 'S', color = 'StlineVisual' },
  ['S'] = { long = 'S-LINE', short = 'S-L', color = 'StlineVisual' },
  [api.nvim_replace_termcodes('<C-S>', true, true, true)] = {
    long = 'S-BLOCK',
    short = 'S-B',
    color = 'StlineVisual',
  },
  ['i'] = { long = 'INSERT', short = 'I', color = 'StlineInsert' },
  ['R'] = { long = 'REPLACE', short = 'R', color = 'StlineReplace' },
  ['c'] = { long = 'COMMAND', short = 'C', color = 'StlineCommand' },
  ['r'] = { long = 'PROMPT', short = 'P', color = 'StlineCommand' },
  ['!'] = { long = 'SHELL', short = 'Sh', color = 'StlineCommand' },
  ['t'] = { long = 'TERMINAL', short = 'T', color = 'StlineTerminal' },
}

local function has_text(s) return s:len() > 0 and s ~= '.' end

local function build_path(tbl) return table.concat(vim.tbl_filter(has_text, tbl), '/') end

local function block(value, highlight, template)
  if not value or value == 0 or value == '' then return '' end
  local text = fmt(template or '%s', value)
  return highlight and string.format('%%#%s#%s%%*', highlight, text) or text
end

local function shorten_path(path)
  return build_path(
    vim.tbl_map(function(dir_name) return dir_name:sub(1, 1) end, vim.split(path, '/'))
  )
end

local function is_special_filename(file_name)
  return vim.tbl_contains(
    vim.tbl_map(
      function(pattern) return file_name:match(pattern) ~= nil end,
      SPECIAL_FILENAME_PATTERNS
    ),
    true
  )
end

local function get_long_path()
  local file_name = fn.expand '%:~:.:t'
  local base = fn.expand '%:~:.:h'
  return build_path { base, file_name }
end

local function get_compact_path()
  local file_name = fn.expand '%:t'
  local full_path = fn.expand '%:~:.:h'

  if full_path == '.' or full_path == '' then return file_name end

  local path_parts = vim.split(full_path, '/')
  local path_length = #path_parts

  if is_special_filename(file_name) and path_length > 0 then
    return build_path {
      shorten_path(build_path(vim.list_slice(path_parts, 1, path_length - 1))),
      path_parts[path_length],
      file_name,
    }
  end

  return build_path { shorten_path(full_path), file_name }
end

local function get_mode()
  local current_mode = vim.fn.mode()
  local mode = MODE_MAP[current_mode] or { long = 'UNKNOWN', short = 'U', color = 'StlineNormal' }
  return mode.long, mode.color
end

local function get_file_icon() return G.icons[fn.expand '%:t'] end
local function get_modified_icon() return opt.modified:get() and '●' or '' end
local function get_readonly_icon()
  local mod, ro = opt.modifiable:get(), opt.readonly:get()
  if mod and not ro then return '' end
  return (ro and mod) and '󰂭' or ''
end

local function get_lsp_diagnostics()
  local function get_diag_count(severity) return #vim.diagnostic.get(0, { severity = severity }) end
  local severity = vim.diagnostic.severity

  return table.concat({
    block(get_diag_count(severity.ERROR), 'StlineDiagError', '  %s '),
    block(get_diag_count(severity.WARN), 'StlineDiagWarn', '  %s '),
    block(get_diag_count(severity.INFO), 'StlineDiagInfo', '  %s '),
    block(get_diag_count(severity.HINT), 'StlineDiagHint', '  %s '),
  }, '')
end

-- Main functions
function M.get_statusline()
  local mode, mode_color = get_mode()
  local path = get_long_path()
  local modified_icon = get_modified_icon()
  local readonly_icon = get_readonly_icon()
  local diagnostics = get_lsp_diagnostics()
  local file_icon = get_file_icon()

  local lhs = table.concat {
    block(mode, mode_color, ' %s '),
    block(file_icon, 'StlineFileIcon', ' %s '),
    block(path, 'StlinePath', '%s '),
    block(modified_icon, 'StlineModified', '%s '),
    block(readonly_icon, 'StlineReadOnly', '%s '),
  }

  local rhs = table.concat {
    diagnostics,
    block('%l|%c', 'StlineLineCol', ' %s '),
  }

  return lhs .. '%=' .. rhs
end

function M.get_winbar()
  local path = get_compact_path()
  local modified_icon = get_modified_icon()
  local file_icon = get_file_icon()

  return table.concat {
    block(file_icon, 'WinBarFileIcon', ' %s'),
    block(path, 'WinBarPath', ' %s '),
    block(modified_icon, 'WinBarModified', '%s '),
  }
end

local function setup_highlights()
  local colors = require('base16-colorscheme').colors
  local highlights = {
    StlineNormal = { fg = colors.base00, bg = colors.base0D },
    StlineInsert = { fg = colors.base00, bg = colors.base0B },
    StlineVisual = { fg = colors.base00, bg = colors.base0E },
    StlineReplace = { fg = colors.base00, bg = colors.base08 },
    StlineCommand = { fg = colors.base00, bg = colors.base0A },
    StlineTerminal = { fg = colors.base00, bg = colors.base0C },
    StlineFileIcon = { fg = colors.base0D, bg = colors.base01 },
    StlinePath = { fg = colors.base05, bg = colors.base01 },
    StlineModified = { fg = colors.base08, bg = colors.base01 },
    StlineReadOnly = { fg = colors.base0A, bg = colors.base01 },
    StlineDiagError = { fg = colors.base08, bg = colors.base01 },
    StlineDiagWarn = { fg = colors.base0A, bg = colors.base01 },
    StlineDiagInfo = { fg = colors.base0C, bg = colors.base01 },
    StlineDiagHint = { fg = colors.base0D, bg = colors.base01 },
    StlineLineCol = { fg = colors.base05, bg = colors.base02 },
    WinBarSeparator = { fg = colors.base03, bg = colors.base00 },
    WinBarFileIcon = { fg = colors.base0D, bg = colors.base00 },
    WinBarPath = { fg = colors.base05, bg = colors.base00 },
    WinBarModified = { fg = colors.base08, bg = colors.base00 },
  }

  for group, color in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, color)
  end
end

local function setup()
  setup_highlights()
  vim.opt.statusline = "%{%v:lua.require'ma.statusline'.get_statusline()%}"
  vim.opt.winbar = "%{%v:lua.require'ma.statusline'.get_winbar()%}"
end

setup()

return M

local fn = vim.fn
local opt = vim.opt
local fmt = string.format
local api = vim.api
local M = {}

local function block(value, highlight, template)
  if value == 0 or value == '' or value == nil or not value then return '' end

  local text = fmt((template or '%s'), value)

  return highlight and string.format('%%#%s#%s%%*', highlight, text) or text
end

local function get_long_path()
  local file_name = fn.expand '%:~:.:t'
  local base = fn.expand '%:~:.:h'
  base = (base == nil or base == '.') and '' or base:gsub('/$', '') .. '/'

  local path = base .. file_name

  if path == '/' then return '' end

  return path
end

local function shorten_directory_name(dir_name) return dir_name:sub(1, 1) end

local function shorten_path(path)
  local parts = vim.split(path, '/')
  local shortened_parts = vim.tbl_map(shorten_directory_name, parts)
  return table.concat(shortened_parts, '/')
end

local function is_special_filename(file_name)
  return file_name:match '^index%.'
    or file_name:match '^page%.[jt]sx?$'
    or file_name:match '^route%.[jt]sx?$'
    or file_name:match '^error%.[jt]sx?$'
    or file_name:match '^layout%.[jt]sx?$'
    or file_name:match '^opengraph-image%.[jt]sx?$'
end

local function get_compact_path()
  local file_name = fn.expand '%:t'
  local full_path = fn.expand '%:~:.:h'

  if full_path == '.' or full_path == '' then return file_name end

  local path_parts = vim.split(full_path, '/')
  local path_length = #path_parts

  if is_special_filename(file_name) and path_length > 0 then
    local parent_dir = path_parts[path_length]
    local shortened_path =
      shorten_path(table.concat(vim.list_slice(path_parts, 1, path_length - 1), '/'))

    return table.concat(
      vim.tbl_filter(
        function(str) return string.len(str) > 0 end,
        { shortened_path, parent_dir, file_name }
      ),
      '/'
    )
  end

  local shortened_path = shorten_path(full_path)
  return shortened_path .. '/' .. file_name
end

local CTRL_S = api.nvim_replace_termcodes('<C-S>', true, true, true)
local CTRL_V = api.nvim_replace_termcodes('<C-V>', true, true, true)

local modes = setmetatable({
  ['n'] = { long = 'NORMAL', short = 'N', color = 'StlineNormal' },
  ['v'] = { long = 'VISUAL', short = 'V', color = 'StlineVisual' },
  ['V'] = { long = 'V-LINE', short = 'V-L', color = 'StlineVisual' },
  [CTRL_V] = { long = 'V-BLOCK', short = 'V-B', color = 'StlineVisual' },
  ['s'] = { long = 'SELECT', short = 'S', color = 'StlineVisual' },
  ['S'] = { long = 'S-LINE', short = 'S-L', color = 'StlineVisual' },
  [CTRL_S] = { long = 'S-BLOCK', short = 'S-B', color = 'StlineVisual' },
  ['i'] = { long = 'INSERT', short = 'I', color = 'StlineInsert' },
  ['R'] = { long = 'REPLACE', short = 'R', color = 'StlineReplace' },
  ['c'] = { long = 'COMMAND', short = 'C', color = 'StlineCommand' },
  ['r'] = { long = 'PROMPT', short = 'P', color = 'StlineCommand' },
  ['!'] = { long = 'SHELL', short = 'Sh', color = 'StlineCommand' },
  ['t'] = { long = 'TERMINAL', short = 'T', color = 'StlineTerminal' },
}, {
  __index = function() return { long = 'UNKNOWN', short = 'U', color = 'StlineNormal' } end,
})

local function get_mode()
  local mode = modes[vim.fn.mode()]
  return mode.long, mode.color
end

local function get_file_icon() return G.icons[fn.expand '%:t'] end

local function get_modified_icon() return opt.modified:get() and '●' or '' end

local function get_readonly_icon()
  local mod = opt.modifiable:get()
  local ro = opt.readonly:get()

  if mod and not ro then return '' end

  return (ro and mod) and '󰂭' or ''
end

local function get_lsp_diagnostics()
  local get_diag_count = function(severity) return #vim.diagnostic.get(0, { severity = severity }) end

  local severity = vim.diagnostic.severity

  local e = get_diag_count(severity.ERROR)
  local w = get_diag_count(severity.WARN)
  local i = get_diag_count(severity.INFO)
  local h = get_diag_count(severity.HINT)

  return table.concat({
    block(e, 'StlineDiagError', '  %s '),
    block(w, 'StlineDiagWarn', '  %s '),
    block(i, 'StlineDiagInfo', '  %s '),
    block(h, 'StlineDiagHint', '  %s '),
  }, '')
end

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

  local lhs = table.concat {
    block(file_icon, 'WinBarFileIcon', ' %s'),
    block(path, 'WinBarPath', ' %s '),
    block(modified_icon, 'WinBarModified', '%s '),
  }

  return lhs
end

local function statusline()
  vim.opt.statusline = "%{%v:lua.require'ma.statusline'.get_statusline()%}"
end

local function winbar() vim.opt.winbar = "%{%v:lua.require'ma.statusline'.get_winbar()%}" end

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
    api.nvim_set_hl(0, group, color)
  end
end

local function setup()
  setup_highlights()
  statusline()
  winbar()
end

setup()

return M

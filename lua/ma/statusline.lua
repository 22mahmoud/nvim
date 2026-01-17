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
  '^loading%.[jt]sx?$',
  '^not%-found%.[jt]sx?$',
  '^template%.[jt]sx?$',
  '^default%.[jt]sx?$',
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
  ['nt'] = { long = 'NORMAL', short = 'N-T', color = 'StlineNormal' },
  ['niI'] = { long = 'NORMAL', short = 'N', color = 'StlineNormal' },
  ['niR'] = { long = 'NORMAL', short = 'N', color = 'StlineNormal' },
  ['niV'] = { long = 'NORMAL', short = 'N', color = 'StlineNormal' },
}

-- Cache for performance
local cache = {
  devicons_ok = nil,
  devicons = nil,
}

local function get_hl_color(name)
  local hl = api.nvim_get_hl(0, { name = name, link = false })
  return {
    fg = hl.fg and fmt('#%06x', hl.fg) or nil,
    bg = hl.bg and fmt('#%06x', hl.bg) or nil,
  }
end

local function has_text(s) return s and s:len() > 0 and s ~= '.' end

local function build_path(tbl) return table.concat(vim.tbl_filter(has_text, tbl), '/') end

local function get_bufname() return api.nvim_buf_get_name(0) end

local function block(value, highlight, template)
  if not value or value == 0 or value == '' then return '' end
  local text = fmt(template or '%s', value)
  return highlight and fmt('%%#%s#%s%%*', highlight, text) or text
end

local function shorten_path(path)
  return build_path(
    vim.tbl_map(
      function(dir_name) return dir_name:sub(1, 1) end,
      vim.split(path, '/', { plain = true })
    )
  )
end

local function is_special_filename(file_name)
  for _, pattern in ipairs(SPECIAL_FILENAME_PATTERNS) do
    if file_name:match(pattern) then return true end
  end

  return false
end

local function get_long_path()
  local bufname = get_bufname()
  if bufname == '' then return '' end

  local file_name = fn.fnamemodify(bufname, ':t')
  local base = fn.fnamemodify(bufname, ':~:.:h')
  return build_path { base, file_name }
end

local function get_compact_path()
  local bufname = get_bufname()
  if bufname == '' then return '' end

  local file_name = fn.fnamemodify(bufname, ':t')
  local full_path = fn.fnamemodify(bufname, ':~:.:h')

  if full_path == '.' or full_path == '' then return file_name end

  local path_parts = vim.split(full_path, '/', { plain = true })
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
  local current_mode = api.nvim_get_mode().mode
  local mode = MODE_MAP[current_mode] or { long = 'UNKNOWN', short = 'U', color = 'StlineNormal' }
  return mode.long, mode.color
end

local function get_file_icon()
  -- Lazy load nvim-web-devicons
  if cache.devicons_ok == nil then
    cache.devicons_ok, cache.devicons = pcall(require, 'nvim-web-devicons')
  end

  if not cache.devicons_ok then return nil end

  local bufname = get_bufname()
  if bufname == '' then return nil end

  local filename = fn.fnamemodify(bufname, ':t')
  local extension = fn.fnamemodify(bufname, ':e')

  return cache.devicons.get_icon(filename, extension, { default = true })
end

local function get_modified_icon() return vim.bo.modified and '●' or '' end

local function get_readonly_icon()
  if vim.bo.readonly or not vim.bo.modifiable then return '󰌾' end
  return ''
end

local function get_lsp_diagnostics()
  if not vim.diagnostic.is_enabled { bufnr = 0 } then return '' end

  local severity = vim.diagnostic.severity
  local counts = vim.diagnostic.count(0)

  local function get_diag_count(level) return counts[level] or 0 end

  return table.concat({
    block(get_diag_count(severity.ERROR), 'StlineDiagError', '  %s '),
    block(get_diag_count(severity.WARN), 'StlineDiagWarn', '  %s '),
    block(get_diag_count(severity.INFO), 'StlineDiagInfo', ' 󰌶 %s '),
    block(get_diag_count(severity.HINT), 'StlineDiagHint', '  %s '),
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

  local lhs = table.concat({
    block(mode, mode_color, ' %s '),
    string.len(path) > 0 and block(file_icon, 'StlineFileIcon', ' %s ') or '',
    string.len(path) > 0 and block(path, 'StlinePath', '%s ') or block(' ', 'StlinePath', '%s'),
    block(modified_icon, 'StlineModified', '%s '),
    block(readonly_icon, 'StlineReadOnly', '%s '),
  }, '')

  local rhs = table.concat({
    diagnostics,
    block('%l:%c', mode_color, '  %s '),
  }, '')

  return lhs .. '%=' .. rhs
end

function M.get_winbar()
  local path = get_compact_path()
  local modified_icon = get_modified_icon()
  local file_icon = get_file_icon()

  return table.concat({
    string.len(path) > 0 and block(file_icon, 'WinBarFileIcon', ' %s ') or '',
    string.len(path) > 0 and block(path, 'WinBarPath', '%s ') or block(' ', 'WinBarPath', '%s'),
    block(modified_icon, 'WinBarModified', '%s '),
  }, '')
end

function M.setup_highlights()
  local highlights = {
    StlineNormal = {
      fg = get_hl_color('Cursor').fg,
      bg = get_hl_color('Function').fg,
      bold = true,
    },
    StlineInsert = {
      fg = get_hl_color('Cursor').fg,
      bg = get_hl_color('String').fg,
      bold = true,
    },
    StlineVisual = {
      fg = get_hl_color('Cursor').fg,
      bg = get_hl_color('Type').fg,
      bold = true,
    },
    StlineReplace = {
      fg = get_hl_color('Cursor').fg,
      bg = get_hl_color('Error').fg,
      bold = true,
    },
    StlineCommand = {
      fg = get_hl_color('Cursor').fg,
      bg = get_hl_color('Special').fg,
      bold = true,
    },
    StlineTerminal = {
      fg = get_hl_color('Cursor').fg,
      bg = get_hl_color('WarningMsg').fg,
      bold = true,
    },
    StlineGitBranch = {
      fg = get_hl_color('Special').fg,
      bg = get_hl_color('ColorColumn').bg,
    },
    StlineFileIcon = {
      fg = get_hl_color('Function').fg,
      bg = get_hl_color('ColorColumn').bg,
    },
    StlinePath = {
      fg = get_hl_color('Normal').fg,
      bg = get_hl_color('ColorColumn').bg,
    },
    StlineModified = {
      fg = get_hl_color('Error').fg,
      bg = get_hl_color('ColorColumn').bg,
    },
    StlineReadOnly = {
      fg = get_hl_color('WarningMsg').fg,
      bg = get_hl_color('ColorColumn').bg,
    },
    StlineDiagError = {
      fg = get_hl_color('DiagnosticError').fg,
      bg = get_hl_color('ColorColumn').bg,
    },
    StlineDiagWarn = {
      fg = get_hl_color('DiagnosticWarn').fg,
      bg = get_hl_color('ColorColumn').bg,
    },
    StlineDiagInfo = {
      fg = get_hl_color('DiagnosticInfo').fg,
      bg = get_hl_color('ColorColumn').bg,
    },
    StlineDiagHint = {
      fg = get_hl_color('DiagnosticHint').fg,
      bg = get_hl_color('ColorColumn').bg,
    },
    WinBarFileIcon = {
      fg = get_hl_color('Function').fg,
      bg = get_hl_color('Normal').bg,
    },
    WinBarPath = {
      fg = get_hl_color('Normal').fg,
      bg = get_hl_color('Normal').bg,
    },
    WinBarModified = {
      fg = get_hl_color('Error').fg,
      bg = get_hl_color('Normal').bg,
    },
  }

  for group, color in pairs(highlights) do
    api.nvim_set_hl(0, group, color)
  end
end

local function setup()
  opt.statusline = "%{%v:lua.require'ma.statusline'.get_statusline()%}"
  opt.winbar = "%{%v:lua.require'ma.statusline'.get_winbar()%}"
end

setup()

return M

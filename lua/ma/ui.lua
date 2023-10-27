local open_floating_preview = vim.lsp.util.open_floating_preview
local make_floating_popup_options = vim.lsp.util.make_floating_popup_options

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
  local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

  local default_opts = {
    max_width = max_width,
    max_height = max_height,
  }

  local buf, win = open_floating_preview(
    contents,
    syntax,
    vim.tbl_extend('force', opts or {}, default_opts),
    ...
  )

  return buf, win
end

function vim.lsp.util.make_floating_popup_options(width, height, opts, ...)
  return make_floating_popup_options(
    width,
    height,
    vim.tbl_deep_extend('force', opts or {}, { border = 'rounded' }),
    ...
  )
end

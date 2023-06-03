local loaded = pcall(require, 'base16-colorscheme')

if not loaded then
  return
end

pcall(require, 'ma.theme')

local colorscheme = vim.g.base16_theme_name or 'base16-gruvbox-dark-hard'

local function user_highlights()
  local opts = { guibg = nil }

  G.hl('Normal', opts)
  G.hl('NormalNC', opts)
  G.hl('NormalSB', opts)
  G.hl('NormalFloat', opts)
  G.hl('SignColumn', opts)
  G.hl('LineNr', opts)
  G.hl('LspReferenceText', opts)
  G.hl('LspReferenceRead', opts)
  G.hl('LspReferenceWrite', opts)
  G.hl('VertSplit', opts)
  G.hl('FloatBorder', opts)
end

G.augroup('UserHighlights', {
  {
    events = 'ColorScheme',
    targets = '*',
    command = user_highlights,
  },
})

vim.cmd('colorscheme ' .. colorscheme)

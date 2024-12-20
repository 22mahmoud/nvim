pcall(require, 'ma.theme')

local statusline = require 'ma.statusline'

local function user_highlights()
  local opts = { guibg = nil }

  G.hl('Normal', opts)
  G.hl('NormalNC', opts)
  G.hl('NormalSB', opts)
  G.hl('NormalFloat', opts)
  G.hl('SignColumn', opts)
  G.hl('LineNr', opts)
  G.hl('VertSplit', opts)
  G.hl('FloatBorder', opts)

  statusline.setup_highlights()
end

G.augroup('UserHighlights', {
  {
    events = 'ColorScheme',
    pattern = '*',
    command = user_highlights,
  },
})

local loaded = pcall(require, 'base16-colorscheme')
if not loaded then return end

vim.cmd('colorscheme ' .. (vim.g.base16_theme_name or 'base16-gruvbox-dark-hard'))

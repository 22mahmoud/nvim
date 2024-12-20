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

user_highlights()

G.augroup('UserHighlights', {
  {
    events = 'ColorScheme',
    pattern = '*',
    command = user_highlights,
  },
})

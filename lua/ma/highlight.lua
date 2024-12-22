local statusline = require 'ma.statusline'

local colorscheme_rc = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, 'ricing', 'colorscheme.lua')
if vim.uv.fs_stat(colorscheme_rc) then vim.cmd(string.format('so %s', colorscheme_rc)) end

local function user_highlights()
  local opts = { guibg = nil }

  G.hl('Normal', opts)
  G.hl('NormalNC', opts)
  G.hl('NormalSB', opts)
  G.hl('NormalFloat', opts)
  G.hl('SignColumn', opts)
  G.hl('VertSplit', opts)
  G.hl('FloatBorder', opts)
  --
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

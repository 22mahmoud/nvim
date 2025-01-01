local statusline = require 'ma.statusline'

local colorscheme_rc = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, 'ricing', 'colorscheme.lua')
if vim.uv.fs_stat(colorscheme_rc) then vim.cmd(string.format('so %s', colorscheme_rc)) end

local function user_highlights()
  local highlights = {
    'Normal',
    'NormalNC',
    'NormalSB',
    'NormalFloat',
    'SignColumn',
    'VertSplit',
    'FloatBorder',
  }

  local opts = { guibg = nil }

  for _, key in pairs(highlights) do
    vim.api.nvim_set_hl(0, key, opts)
  end

  statusline.setup_highlights()
end

user_highlights()

vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
  group = vim.api.nvim_create_augroup('UserHighlights', {}),
  callback = user_highlights,
})

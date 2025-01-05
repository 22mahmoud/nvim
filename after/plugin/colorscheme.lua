local colorscheme_rc = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, 'ricing', 'colorscheme.lua')
if vim.uv.fs_stat(colorscheme_rc) then
  vim.cmd(string.format('so %s', colorscheme_rc))
else
  vim.cmd.colorscheme 'tokyonight'
end

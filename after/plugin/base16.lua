local loaded = pcall(require, 'base16-colorscheme')
if not loaded then return end

vim.cmd('colorscheme ' .. (vim.g.base16_theme_name or 'base16-gruvbox-dark-hard'))

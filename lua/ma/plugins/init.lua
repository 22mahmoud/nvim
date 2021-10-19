local fmt = string.format

local function packadd(plugin)
  vim.cmd(fmt('packadd %s', plugin))

  pcall(require, fmt('ma.plugins.%s', plugin))
end

packadd 'nvim-base16'
packadd 'nvim-treesitter'
packadd 'nvim-lspconfig'
packadd 'vim-surround'

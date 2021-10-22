local function packadd(plugin)
  vim.cmd('packadd ' .. plugin)
end

packadd 'nvim-base16'
packadd 'nvim-treesitter'
packadd 'nvim-lspconfig'

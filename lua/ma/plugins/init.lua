local fmt = string.format

local function packadd(plugin)
  vim.cmd(fmt("packadd %s", plugin))

  pcall(require, fmt("ma.plugins.%s", plugin))
end

packadd("nvim-base16")
packadd("nvim-treesitter")
packadd("nvim-lspconfig")
packadd("vim-surround")

local function plugins_hooks()
  vim.cmd [[helptags ALL]]
  vim.cmd [[silent TSUpdate]]
end

vim.defer_fn(plugins_hooks, 0)

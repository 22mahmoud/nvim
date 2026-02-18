local cmd = vim.api.nvim_create_user_command

local plugins = {
  -- colors/ui
  { src = 'https://github.com/RRethy/nvim-base16', name = 'nvim-base16' },
  { src = 'https://github.com/nvim-mini/mini.icons', name = 'nvim-mini-icons' },

  -- editor,
  { src = 'https://github.com/nvim-mini/mini.surround', name = 'nvim-mini-surround' },
  { src = 'https://github.com/stevearc/oil.nvim', name = 'nvim-oil' },

  -- treesitter
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    name = 'nvim-treesitter',
    version = 'main',
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    name = 'nvim-treesitter-textobjects',
    version = 'main',
  },
}

vim.pack.add(plugins)

cmd('PkgUpdate', function() vim.pack.update(nil, { target = 'lockfile' }) end, {})

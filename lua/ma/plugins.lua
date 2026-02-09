local cmd = vim.api.nvim_create_user_command

local plugins = {
  -- colors/ui
  { src = 'https://github.com/RRethy/nvim-base16', name = 'nvim-base16' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons', name = 'nvim-web-devicons' },

  -- editor,
  { src = 'https://github.com/kylechui/nvim-surround', name = 'nvim-surround' },
  { src = 'https://github.com/tpope/vim-repeat', name = 'vim-repeat' },
  { src = 'https://github.com/stevearc/oil.nvim', name = 'nvim-oil' },

  -- treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', name = 'nvim-treesitter' },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    name = 'nvim-treesitter-textobjects',
  },
}

vim.pack.add(plugins)

cmd('PkgUpdate', function() vim.pack.update(nil, { force = true }) end, {})

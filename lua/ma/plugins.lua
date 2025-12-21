local cmd = vim.api.nvim_create_user_command

vim.pack.add {
  -- colors/ui
  'https://github.com/RRethy/nvim-base16',
  'https://github.com/catppuccin/nvim',
  'https://github.com/folke/tokyonight.nvim',

  -- editor
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/stevearc/oil.nvim',

  -- debug
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/mfussenegger/nvim-dap-python',

  -- treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
  'https://github.com/windwp/nvim-ts-autotag',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'master' },
  'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',
}

cmd('PkgUpdate', function() vim.pack.update(nil, { force = true }) end, {})

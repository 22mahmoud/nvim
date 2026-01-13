local cmd = vim.api.nvim_create_user_command

vim.pack.add {
  -- colors/ui
  'https://github.com/RRethy/nvim-base16',
  'https://github.com/catppuccin/nvim',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',

  -- lsp
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/creativenull/efmls-configs-nvim',

  -- editor
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-mini/mini.snippets',

  -- debug
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/mfussenegger/nvim-dap-python',

  -- treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  'https://github.com/windwp/nvim-ts-autotag',
}

cmd('PkgUpdate', function() vim.pack.update(nil, { force = true }) end, {})

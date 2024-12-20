local pkg = require 'ma.pkg-manager'

-- colors/ui
pkg.use 'RRethy/nvim-base16'

-- editor
pkg.use 'tpope/vim-surround.git'
pkg.use 'tpope/vim-repeat'

-- lsp
pkg.use 'neovim/nvim-lspconfig'
pkg.use 'folke/lazydev.nvim'
pkg.use 'Bilal2453/luvit-meta'
pkg.use 'b0o/SchemaStore.nvim'
pkg.use 'stevearc/conform.nvim'

-- treesitter
pkg.use 'nvim-treesitter/nvim-treesitter'
pkg.use 'windwp/nvim-ts-autotag'
pkg.use 'nvim-treesitter/nvim-treesitter-textobjects'
pkg.use 'JoosepAlviste/nvim-ts-context-commentstring'

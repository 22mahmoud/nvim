vim.cmd [[packadd packer.nvim]]

return require('packer').startup(
  function()
    use {'wbthomason/packer.nvim', opt = true}

    -- themeing, ui
    use 'gruvbox-community/gruvbox'

    -- treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      opt = true,
      run = function() vim.cmd [[TSUpdate]] end
    }

    -- lsp
    use 'neovim/nvim-lspconfig'
    use {
      'nvim-lua/completion-nvim',
      requires = {
        'steelsojka/completion-buffers',
        'hrsh7th/vim-vsnip',
        'hrsh7th/vim-vsnip-integ'
      }
    }

    -- lua
    use {
      'tjdevries/nlua.nvim',
      requires = {
        'euclidianAce/BetterLua.vim'
      }
    }

    -- file explorer
    use {
      'kyazdani42/nvim-tree.lua',
      opt = true, 
      requires = {
        'kyazdani42/nvim-web-devicons'
      }
    }

    -- js,ts,jsx
    use 'maxmellon/vim-jsx-pretty'
    use 'leafgarland/typescript-vim'
  end
)

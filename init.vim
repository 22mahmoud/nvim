call plug#begin(stdpath('data') . '/plugged')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'folke/zen-mode.nvim', { 'on': ['ZenMode'] }

  Plug 'terrortylor/nvim-comment'
  Plug 'RRethy/nvim-base16'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'norcalli/nvim-colorizer.lua'

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'windwp/nvim-autopairs', { 'as': 'autopairs' }
  Plug 'windwp/nvim-ts-autotag', {'for': ['javascriptreact', 'html', 'svelte']}

  Plug 'junegunn/fzf', { 'on' : ['FZF', 'Files', 'Rg', 'Rg!', 'Buffers']}
  Plug 'junegunn/fzf.vim', { 'on' : ['FZF', 'Files', 'Rg', 'Rg!', 'Buffers']}

  Plug 'neovim/nvim-lspconfig'
  Plug 'lukas-reineke/indent-blankline.nvim'

  " git
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'rhysd/conflict-marker.vim'

  Plug 'vim-test/vim-test', { 'on': ['TestFile', 'TestNearest', 'TestLast', 'TestSuite']}
call plug#end()

lua require "ma.providers"

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

let mapleader = " "

let base16colorspace=256
silent! colorscheme base16-dracula
let g:airline_theme = 'base16'

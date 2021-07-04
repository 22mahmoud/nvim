local packer = require("packer")

local fmt = string.format

local function conf(name)
  require(fmt("ma.plugins.%s", name))
end

local function plugins(use)
  use "wbthomason/packer.nvim"

  use "fnune/base16-vim"
  use "vim-airline/vim-airline"
  use "vim-airline/vim-airline-themes"

  use {"nvim-treesitter/nvim-treesitter", config = conf("treesitter")}

  use {"neovim/nvim-lspconfig", config = conf("lspconfig")}

  use "junegunn/fzf"
  use {"junegunn/fzf.vim", config = conf("fzf")}
end

return packer.startup(plugins)

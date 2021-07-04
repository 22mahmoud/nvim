local packer = require("packer")

local fmt = string.format

local function conf(name)
  local module = require(fmt("ma.plugins.%s", name))
  return module.config()
end

local function plugins(use)
  -- utils
  use "wbthomason/packer.nvim"
  use "nvim-lua/plenary.nvim"

  -- theme & look
  use "fnune/base16-vim"
  use "vim-airline/vim-airline"
  use "vim-airline/vim-airline-themes"
  use {"nvim-treesitter/nvim-treesitter", config = conf("treesitter")}

  -- git
  use {
    "lewis6991/gitsigns.nvim",
    config = conf("gitsigns"),
    requires = "plenary.nvim"
  }
  use {
    "TimUntersberger/neogit",
    config = conf("neogit"),
    requires = "plenary.nvim"
  }

  -- lsp
  use {"neovim/nvim-lspconfig", config = conf("lspconfig")}

  -- find
  use "junegunn/fzf"
  use {"junegunn/fzf.vim", config = conf("fzf")}
end

return packer.startup(plugins)

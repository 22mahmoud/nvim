local fmt = string.format

local packer = require("packer")

local function conf(name)
  require(fmt("ma.plugins.%s", name))
end

local function plugins(use)
  use "wbthomason/packer.nvim"

  use "lifepillar/vim-gruvbox8"

  use {"nvim-treesitter/nvim-treesitter", config = conf("treesitter")}

  use {"neovim/nvim-lspconfig", config = conf("lspconfig")}

  use "junegunn/fzf"
  use {"junegunn/fzf.vim", config = conf("fzf")}
end

return packer.startup(plugins)

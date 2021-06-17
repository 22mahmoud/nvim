local fmt = string.format

local packer = require("packer")

local function conf(name)
  require(fmt("ma.plugins.%s", name))
end

local function plugins()
  use "lifepillar/vim-gruvbox8"
  use {"nvim-treesitter/nvim-treesitter", config = conf("treesitter")}
  use "christoomey/vim-tmux-navigator"
  use {"neovim/nvim-lspconfig", config = conf("lspconfig")}
end

return packer.startup(plugins)

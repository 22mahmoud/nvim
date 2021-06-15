local fmt = string.format

local packer = require("packer")

local function conf(name)
  return require(fmt("ma.plugins.%s", name))
end

local function plugins()
  use "lifepillar/vim-gruvbox8"
  use "christoomey/vim-tmux-navigator"
  use {"neovim/nvim-lspconfig", config = conf("lspconfig")}
end

return packer.startup(plugins)

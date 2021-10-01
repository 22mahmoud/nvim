local fn = vim.fn
local fmt = string.format

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  vim.cmd(
    fmt("!git clone https://github.com/wbthomason/packer.nvim %s", install_path)
  )
  vim.cmd "packadd packer.nvim"
end

local has_packer, packer = pcall(require, "packer")
if not has_packer then
  return
end

local function conf(name)
  return require(fmt("ma.plugins.%s", name))
end

local join_paths = require("packer.util").join_paths

packer.init {
  compile_path = join_paths(
    vim.fn.stdpath("config"),
    "packer",
    "packer_compiled.lua"
  )
}

return packer.startup {
  function(use)
    use "wbthomason/packer.nvim"

    use {
      "RRethy/nvim-base16",
      config = conf("nvim-base16").config
    }

    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = conf("nvim-treesitter").config
    }

    -- lsp
    use {
      "neovim/nvim-lspconfig",
      event = "BufReadPre",
      config = conf("lspconfig").config
    }

    use "tpope/vim-surround"
  end
}

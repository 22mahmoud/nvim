local fmt = string.format
local fn, notify = vim.fn, vim.notify
local stdpath, system, glob, empty = fn.stdpath, fn.system, fn.glob, fn.empty

local install_path = fmt("%s/site/pack/packer/opt/packer.nvim", stdpath "data")

if empty(glob(install_path)) > 0 then
  notify "Downloading packer.nvim..."
  notify(
    system {
      "git",
      "clone",
      "https://github.com/wbthomason/packer.nvim",
      install_path
    }
  )

  vim.cmd "packadd! packer.nvim"
else
  vim.cmd "packadd! packer.nvim"
end

local function plugins(use)
  -- utils
  use {"wbthomason/packer.nvim", opt = true}
  use "nvim-lua/plenary.nvim"
  use "windwp/nvim-autopairs"

  -- theme & look
  -- use "fnune/base16-vim"
  use "RRethy/nvim-base16"
  use "vim-airline/vim-airline"
  use "vim-airline/vim-airline-themes"
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "p00f/nvim-ts-rainbow",
      "windwp/nvim-ts-autotag"
    }
  }

  -- git
  use {"https://github.com/sindrets/diffview.nvim"}
  use {"lewis6991/gitsigns.nvim"}
  use {"TimUntersberger/neogit"}

  -- lsp
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("ma.lspconfig")
    end
  }

  -- find
  use "junegunn/fzf"
  use {"junegunn/fzf.vim"}
end

require("packer").startup {
  plugins,
  config = {
    display = {
      open_cmd = "100vnew [packer]"
    }
  }
}

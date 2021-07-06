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
  use {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {check_ts = true}
      require("nvim-treesitter.configs").setup {autopairs = {enable = true}}
    end
  }
  use {
    "vim-test/vim-test",
    cmd = {"TestFile", "TestNearest", "TestSuite", "TestFile"},
    keys = {"<leader>tf", "<leader>tn", "<leader>ts", "<leader>tl"}
  }
  use {
    "terrortylor/nvim-comment",
    keys = {"gc", "gcc"},
    config = function()
      require("nvim_comment").setup({create_mappings = true})
    end
  }
  use {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup {
        window = {
          backdrop = 1,
          height = 0.85
        },
        plugins = {
          gitsigns = {enabled = false}
        }
      }
    end
  }

  -- theme & look
  use "RRethy/nvim-base16"
  use "vim-airline/vim-airline"
  use "vim-airline/vim-airline-themes"
  use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
  use {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    ft = {
      "html",
      "javascriptreact"
    },
    requires = {"nvim-treesitter/nvim-treesitter"}
  }
  use {
    "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("colorizer").setup()
      vim.cmd "ColorizerReloadAllBuffers"
    end
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    setup = function()
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_char = "▏"

      vim.g.indent_blankline_filetype_exclude = {
        "help",
        "terminal"
      }

      vim.g.indent_blankline_buftype_exclude = {"terminal"}

      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = true
    end
  }

  -- git
  use {"lewis6991/gitsigns.nvim", requires = {"nvim-lua/plenary.nvim"}}

  -- lsp
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("ma.lspconfig")
    end
  }

  -- find
  use "junegunn/fzf"
  use "junegunn/fzf.vim"
end

require("packer").startup {
  plugins,
  config = {
    display = {
      open_cmd = "100vnew [packer]"
    }
  }
}

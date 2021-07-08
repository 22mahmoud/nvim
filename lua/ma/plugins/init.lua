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

return packer.startup(
  function(use)
    use "wbthomason/packer.nvim"
    use "nvim-lua/plenary.nvim"

    use {
      "vim-test/vim-test",
      cmd = {"TestFile", "TestNearest", "TestSuite", "TestFile"},
      setup = conf("vim-test").setup,
      config = conf("vim-test").config
    }

    use "kyazdani42/nvim-web-devicons"
    use {
      "RRethy/nvim-base16",
      config = conf("nvim-base16").config
    }
    use {
      "vim-airline/vim-airline",
      requires = {"vim-airline/vim-airline-themes"},
      config = function()
        vim.g.airline_theme = "base16"
      end
    }

    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = conf("nvim-treesitter").config
    }

    use {
      "windwp/nvim-ts-autotag",
      event = "InsertEnter",
      ft = {
        "html",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "svelte"
      },
      requires = {"nvim-treesitter/nvim-treesitter"},
      config = function()
        require("nvim-ts-autotag").setup()
      end
    }

    use {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup {
          check_ts = false
        }
      end
    }

    use {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({"*"}, {mode = "background"})
      end
    }

    use {
      "terrortylor/nvim-comment",
      keys = {"gc"},
      config = function()
        require("nvim_comment").setup({create_mappings = true})
      end
    }

    use {
      "junegunn/limelight.vim",
      cmd = {"Limelight"},
      config = function()
        vim.g.limelight_conceal_ctermfg = "gray"
        vim.g.limelight_conceal_guifg = "#777777"
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
          },
          on_open = function()
            vim.cmd [[Limelight]]
          end,
          on_close = function()
            vim.cmd [[Limelight!]]
          end
        }
      end
    }

    -- git
    use {
      "lewis6991/gitsigns.nvim",
      event = "BufRead",
      requires = {"nvim-lua/plenary.nvim"},
      config = conf("gitsigns").config
    }
    use {
      "rhysd/conflict-marker.vim",
      event = "BufRead",
      setup = conf("conflict-marker").setup,
      config = conf("conflict-marker").config
    }
    use {
      "ruifm/gitlinker.nvim",
      requires = "nvim-lua/plenary.nvim",
      keys = {"<localleader>gu"},
      config = function()
        require("gitlinker").setup({mappings = "<localleader>gu"})
      end
    }

    use {
      "sindrets/diffview.nvim",
      cmd = "DiffviewOpen",
      module = "diffview",
      setup = function()
        local nnoremap = require("ma.utils").nnoremap

        nnoremap("<leader>gd", "<Cmd>DiffviewOpen<CR>")
      end,
      config = function()
        require("diffview").setup {
          key_bindings = {
            file_panel = {q = "<Cmd>DiffviewClose<CR>"},
            view = {q = "<Cmd>DiffviewClose<CR>"}
          }
        }
      end
    }

    -- lsp
    use {
      "neovim/nvim-lspconfig",
      event = "BufReadPre",
      config = conf("lspconfig").config
    }
    use {
      "folke/trouble.nvim",
      cmd = {"Trouble", "TroubleToggle"},
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup {}
      end
    }

    use {
      "junegunn/fzf.vim",
      cmd = {"Files", "FZF", "Rg"},
      requires = {"junegunn/fzf"},
      setup = conf("fzf").setup,
      config = conf("fzf").config
    }

    -- tpope
    use "tpope/vim-eunuch"
    use "tpope/vim-sleuth"
    use "tpope/vim-repeat"
    use {
      "tpope/vim-surround",
      config = function()
        local xmap = require("ma.utils").xmap
        xmap("s", "<Plug>VSurround")
        xmap("s", "<Plug>VSurround")
      end
    }
  end
)

return require("packer").startup(
  function()
    use {"wbthomason/packer.nvim"}

    use {"iamcco/markdown-preview.nvim", run = "cd app && npm install"}

    use {
      "brooth/far.vim",
      config = function()
        vim.cmd [[
        let g:far#source = 'rg'
        let g:far#enable_undo=1
        ]]
      end
    }
    use "tpope/vim-surround"
    use {
      "tpope/vim-repeat",
      config = function()
        vim.cmd [[silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)]]
      end
    }
    use {"tpope/vim-commentary"}
    use {
      "tpope/vim-dadbod",
      requires = {
        {
          "kristijanhusak/vim-dadbod-ui",
          config = function()
            vim.g.db_ui_use_nerd_fonts = true
            vim.g.db_ui_show_database_icon = true
            vim.api.nvim_command [[
              hi NotificationInfo guifg=yourcolor guibg=yourcolor
              hi NotificationWarning guifg=yourcolor guibg=yourcolor
              hi NotificationError guifg=yourcolor guibg=yourcolor
            ]]
            vim.g.db_ui_table_helpers = {
              mongodb = {
                List = "{table}.find().pretty()",
                Count = "{table}.find().size()"
              }
            }
          end
        }
      }
    }

    -- themeing, ui
    use {"kyazdani42/nvim-web-devicons"}
    use {"lifepillar/vim-gruvbox8"}
    use {"glepnir/zephyr-nvim"}
    use {"bluz71/vim-moonfly-colors"}
    use {"tjdevries/colorbuddy.nvim"}
    use {"ishan9299/modus-theme-vim"}
    use {
      "Yggdroot/indentLine",
      config = function()
      end
    }
    use {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require "colorizer".setup {
          "*",
          css = {rgb_fn = true},
          scss = {rgb_fn = true},
          sass = {rgb_fn = true},
          stylus = {rgb_fn = true},
          vim = {names = true},
          tmux = {names = false},
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          html = {
            mode = "foreground"
          }
        }
      end
    }
    use {
      "glepnir/galaxyline.nvim",
      config = function()
        require("_galaxyline")
      end
    }

    use "nvim-lua/plenary.nvim"
    use "nvim-lua/popup.nvim"

    -- treesitter
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("_treesitter")
      end,
      requires = {
        {"nvim-treesitter/nvim-treesitter-textobjects"},
        {"p00f/nvim-ts-rainbow"},
        {"windwp/nvim-ts-autotag"}
      }
    }

    -- lsp
    use {
      "neovim/nvim-lspconfig",
      config = function()
        require("lsp")
      end
    }
    use {
      "glepnir/lspsaga.nvim"
    }
    use {
      "hrsh7th/nvim-compe",
      config = function()
        require("_completion")
      end,
      requires = {
        "hrsh7th/vim-vsnip"
      }
    }

    use {"onsails/lspkind-nvim"}

    -- lua
    use {
      "tjdevries/nlua.nvim",
      requires = {
        "euclidianAce/BetterLua.vim"
      }
    }

    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-telescope/telescope-fzy-native.nvim"
      },
      config = function()
        require("_telescope")
      end
    }

    -- file explorer
    use {
      "kyazdani42/nvim-tree.lua",
      config = function()
        require("_tree")
      end
    }

    use "christoomey/vim-tmux-navigator"

    -- git
    use {
      "tpope/vim-fugitive",
      config = function()
        vim.api.nvim_set_keymap(
          "n",
          "<leader>gs",
          ":Gstatus<CR>",
          {noremap = true, silent = true}
        )
      end
    }

    use {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup(
          {
            signs = {
              add = {hl = "SignAdd", text = "┃"},
              change = {hl = "SignChange", text = "┃"},
              delete = {hl = "SignDelete", text = "┃"},
              topdelete = {hl = "SignDelete", text = "┃"},
              changedelete = {hl = "SignChange", text = "┃"}
            },
            sign_priority = 5
          }
        )
      end
    }

    -- testing
    use {
      "vim-test/vim-test",
      config = function()
        require("_vim-test")
      end
    }

    -- debugging
    use {
      "mfussenegger/nvim-dap",
      requires = {
        {"theHamsta/nvim-dap-virtual-text"},
        {"nvim-telescope/telescope-dap.nvim"}
      },
      config = function()
        require("_dap")
      end
    }

    -- autopairs
    use {
      "Raimondi/delimitMate",
      config = function()
        vim.cmd [[
          au FileType html let b:delimitMate_matchpairs = "(:),[:],{:}"
        ]]
      end
    }

    -- api client
    -- use {
    --   "22mahmoud/nvim_rest"
    -- }

    use {
      "junegunn/goyo.vim",
      requires = {
        {
          "junegunn/limelight.vim"
        }
      },
      config = function()
        require("_goyo")
      end
    }

    use {
      "plasticboy/vim-markdown",
      requires = {
        {"godlygeek/tabular"}
      },
      config = function()
        vim.g.vim_markdown_folding_disabled = 1
        vim.g.vim_markdown_fenced_languages = {
          "js=javascript",
          "jsx=javascriptreact"
        }
      end
    }
  end
)

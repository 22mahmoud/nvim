vim.cmd [[packadd packer.nvim]]

return require("packer").startup(
  function()
    use {"wbthomason/packer.nvim", opt = true}

    -- themeing, ui
    use "gruvbox-community/gruvbox"
    use {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require "colorizer".setup {
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

    -- treesitter
    use {
      "nvim-treesitter/nvim-treesitter",
      opt = true,
      run = function()
        vim.cmd [[TSUpdate]]
      end
    }

    -- lsp
    use "neovim/nvim-lspconfig"
    use {
      "nvim-lua/completion-nvim",
      requires = {
        "steelsojka/completion-buffers",
        "hrsh7th/vim-vsnip",
        "hrsh7th/vim-vsnip-integ"
      }
    }

    use {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup()
      end
    }

    -- lua
    use {
      "tjdevries/nlua.nvim",
      requires = {
        "euclidianAce/BetterLua.vim"
      }
    }

    -- telescope
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzy-native.nvim",
        "nvim-telescope/telescope-fzf-writer.nvim"
      }
    }

    -- file explorer
    use {
      "kyazdani42/nvim-tree.lua",
      opt = true,
      requires = {
        "kyazdani42/nvim-web-devicons"
      }
    }

    -- formatter
    use {
      "mhartington/formatter.nvim",
      opt = true
    }

    -- js,ts,jsx
    -- because treesitter breaks jsx indentation
    use "maxmellon/vim-jsx-pretty"
    use "leafgarland/typescript-vim"

    use "christoomey/vim-tmux-navigator"

    -- git
    use {
      "lewis6991/gitsigns.nvim",
      requires = {
        "nvim-lua/plenary.nvim"
      },
      config = function()
        require("gitsigns").setup()
      end
    }

    -- testing
    use {
      "vim-test/vim-test",
      config = function()
        vim.cmd [[let test#strategy = "neovim"]]
      end
    }

    -- debugging
    use {
      "mfussenegger/nvim-dap",
      config = function()
        local dap = require("dap")

        dap.adapters.node2 = {
          type = "executable",
          command = "node",
          args = {os.getenv("HOME") .. "/repos/vscode-node-debug2/out/src/nodeDebug.js"}
        }

        dap.configurations.javascript = {
          {
            type = "node2",
            request = "launch",
            program = "${workspaceFolder/file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal"
          }
        }
      end
    }
  end
)

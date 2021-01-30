vim.cmd [[packadd nvim-treesitter]]
vim.cmd [[packadd nvim-treesitter-textobjects]]

require "nvim-treesitter.configs".setup {
  ensure_installed = "all",
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner"
      }
    }
  },
  refactor = {
    highlight_definitions = {enable = true}
  }
}

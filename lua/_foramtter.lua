vim.cmd [[packadd formatter.nvim]]

local map = vim.api.nvim_set_keymap
local api = vim.api

local prettier = {
  function()
    return {
      exe = "prettier",
      args = {"--stdin-filepath", api.nvim_buf_get_name(0), "--single-quote"},
      stdin = true
    }
  end
}

require("formatter").setup(
  {
    logging = false,
    filetype = {
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = prettier,
      css = prettier,
      scss = prettier,
      html = prettier,
      svelte = prettier,
      vue = prettier,
      rust = {
        -- Rustfmt
        function()
          return {
            exe = "rustfmt",
            args = {"--emit=stdout"},
            stdin = true
          }
        end
      },
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      }
    }
  }
)

map("n", ",f", [[:Format<CR>]], {noremap = true, silent = true})

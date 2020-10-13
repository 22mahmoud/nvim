-- load packages
vim.cmd("packadd formatter.nvim")

local map = require("utils").map
local api = vim.api

local prettier = {
  prettier = function()
    return {
      exe = "prettier",
      args = {"--stdin-filepath", api.nvim_buf_get_name(0)},
      stdin = true
    }
  end
}

require("format").setup(
  {
    javascript = prettier,
    javascriptreact = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    css = prettier,
    html = prettier,
    svelte = prettier,
    lua = {
      luafmt = function()
        return {
          exe = "luafmt",
          args = {"--indent-count", 2, "--line-width", 80, "--stdin"},
          stdin = true
        }
      end
    },
    rust = {
      rustfmt = function()
        return {
          exe = "rustfmt",
          args = {},
          stdin = true
        }
      end
    }
  }
)

-- vim.api.nvim_command('autocmd BufWrite * :Format')
map("n", ",f", ":Format<CR>", {silent = true})

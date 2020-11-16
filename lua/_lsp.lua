local lspconfig = require "lspconfig"
local configs = require "lspconfig/configs"
-- local completion = require "completion"
local utils = require "utils"

local on_attach = function(client)
  -- completion.on_attach(client)

  local opts = {noremap = true, silent = true}
  utils.map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  utils.map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  utils.map("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  utils.map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  utils.map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  utils.map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  utils.map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  utils.map(
    "n",
    "<leader>ld",
    "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
    opts
  )
  utils.map("n", "[c", ":vim.lsp.diagnostic.goto_prev()<CR>", opts)
  utils.map("n", "]c", ":vim.lsp.diagnostic.goto_next()<CR>", opts)
end

require("nlua.lsp.nvim").setup(
  lspconfig,
  {
    on_attach = on_attach
  }
)

configs.svelte = {
  default_config = {
    cmd = {"svelteserver", "--stdio"},
    filetypes = {"svelte"},
    root_dir = lspconfig.util.root_pattern(
      "package.json",
      "tsconfig.json",
      ".git"
    ),
    settings = {}
  }
}

local servers = {
  bashls = {},
  vimls = {},
  tsserver = {},
  jsonls = {},
  clangd = {},
  svelte = {},
  metals = {},
  html = {
    filetypes = {"html", "jinja"}
  },
  -- sumneko_lua = {
  --   settings = {
  --     Lua = {
  --       runtime = {
  --         version = "LuaJIT",
  --         path = vim.split(package.path, ";")
  --       },
  --       completion = {
  --         keywordSnippet = "Disable"
  --       },
  --       diagnostics = {
  --         enable = true,
  --         globals = {"vim", "mp"}
  --       },
  --       workspace = {
  --         library = {
  --           [vim.fn.expand("$VIMRUNTIME/lua")] = true,
  --           [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
  --         }
  --       }
  --     }
  --   }
  -- },
  vuels = {}
  -- cssls = {},
}

for server, config in pairs(servers) do
  config.on_attach = on_attach
  lspconfig[server].setup(config)
end

local lspconfig = require "lspconfig"
local root_pattern = require("lspconfig/util").root_pattern
local lsp_mappings = require("ma.plugins.nvim-lspconfig.mappings")
local lsp_autocommands = require("ma.plugins.nvim-lspconfig.autocmds")
local publishDiagnostics = require("ma.plugins.nvim-lspconfig.diagnostic")
local lsp_kind = require("ma.plugins.nvim-lspconfig.lsp_kind")
local sumneko_lua = require("ma.plugins.nvim-lspconfig.sumneko_lua")

local lsp = vim.lsp

local function lsp_handlers()
  lsp.handlers["textDocument/publishDiagnostics"] = publishDiagnostics

  lsp.handlers["textDocument/signatureHelp"] =
    lsp.with(lsp.handlers.signature_help, {border = "single"})

  lsp.handlers["textDocument/hover"] =
    lsp.with(lsp.handlers.hover, {border = "single"})
end


local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  lsp_mappings(client, bufnr)
  lsp_autocommands(client)
end

local function setup_servers(servers)
  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits"
    }
  }

  for server, config in pairs(servers) do
    lspconfig[server].setup(
      vim.tbl_deep_extend(
        "force",
        {on_attach = on_attach, capabilities = capabilities},
        config
      )
    )
  end
end

local servers = {
  tsserver = {
    root_dir = root_pattern(
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      ".git",
      vim.fn.getcwd()
    )
  },
  eslint = {},
  html = {},
  cssls = {},
  bashls = {},
  clangd = {},
  pyright = {},
  vimls = {},
  sumneko_lua = sumneko_lua,
}

local function setup()
  lsp_kind.setup()
  lsp_handlers()
  setup_servers(servers)
end

setup()

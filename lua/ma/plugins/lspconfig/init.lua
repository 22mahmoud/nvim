local M = {}

function M.config()
  require("ma.plugins.lspconfig.diagnostic")

  local root_pattern = require("lspconfig/util").root_pattern
  local lspconfig = require("lspconfig")

  local custom_attach = require("ma.plugins.lspconfig.custom_attach")
  local efm_config = require("ma.plugins.lspconfig.efm_config")
  local sumneko_config = require("ma.plugins.lspconfig.sumneko_lua")

  vim.lsp.protocol.CompletionItemKind = {
    "   (Text) ",
    "   (Method)",
    "   (Function)",
    "   (Constructor)",
    "   (Field)",
    "  (Variable)",
    "   (Class)",
    " ﰮ  (Interface)",
    "   (Module)",
    " 襁 (Property)",
    "   (Unit)",
    "   (Value)",
    " 練 (Enum)",
    "   (Keyword)",
    "   (Snippet)",
    "   (Color)",
    "   (File)",
    "   (Reference)",
    "   (Folder)",
    "   (EnumMember)",
    "   (Constant)",
    "   (Struct)",
    "   (Event)",
    "   (Operator)",
    "   (TypeParameter)"
  }

  -- add snippet support
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits"
    }
  }

  local servers = {}

  servers.efm = efm_config

  servers.sumneko_lua = sumneko_config

  servers.tsserver = {
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      custom_attach(client, bufnr)
    end,
    root_dir = root_pattern(
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      ".git",
      vim.fn.getcwd()
    )
  }

  servers.html = {
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      custom_attach(client, bufnr)
    end
  }

  servers.cssls = {
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      custom_attach(client, bufnr)
    end
  }

  servers.bashls = {
    on_attach = custom_attach
  }

  servers.clangd = {
    on_attach = custom_attach
  }

  servers.pyright = {
    on_attach = custom_attach
  }

  servers.vimls = {
    on_attach = custom_attach
  }

  for server, config in pairs(servers) do
    lspconfig[server].setup(
      vim.tbl_deep_extend("force", {capabilities = capabilities}, config)
    )
  end
end

return M

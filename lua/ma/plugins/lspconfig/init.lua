local lspconfig = require("lspconfig")
local root_pattern = require("lspconfig/util").root_pattern
local custom_attach = require("ma.plugins.lspconfig.custom_attach")
local sumneko_client = require("ma.plugins.lspconfig.sumneko_client")
local efm_config = require("ma.plugins.lspconfig.efm_config")

local sumneko_binary = sumneko_client.sumneko_binary
local sumneko_root_path = sumneko_client.sumneko_root_path

local servers = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

servers.sumneko_lua = {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  on_attach = function(client, bufnr)
    custom_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
  end,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";")
      },
      diagnostics = {
        globals = {"vim", "use"}
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      },
      telemetry = {
        enable = false
      }
    }
  }
}

servers.tsserver = {
  on_attach = function(client, bufnr)
    custom_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
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
    custom_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.cssls = {
  on_attach = function(client, bufnr)
    custom_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.efm = efm_config

for server, config in pairs(servers) do
  lspconfig[server].setup(
    vim.tbl_deep_extend("force", {capabilities = capabilities}, config)
  )
end

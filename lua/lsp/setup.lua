local lspconfig = require("lspconfig")
local nlua = require("nlua.lsp.nvim")
local util = require("lspconfig/util")
local mappings = require("lsp.mappings")
local efmConfig = require("lsp.efm")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nlua.setup(
  lspconfig,
  {
    on_attach = function(client)
      mappings(client)
    end,
    globals = {"use"}
  }
)

local servers = {}

servers.bashls = {
  on_attach = function(client)
    mappings(client)
  end
}

servers.vimls = {
  on_attach = function(client)
    mappings(client)
  end
}

servers.tsserver = {
  on_attach = function(client)
    mappings(client)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.jsonls = {
  on_attach = function(client)
    mappings(client)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.clangd = {
  on_attach = function(client)
    mappings(client)
  end
}

servers.svelte = {
  on_attach = function(client)
    mappings(client)
  end
}

servers.jedi_language_server = {
  on_attach = function(client)
    mappings(client)
  end
}

servers.intelephense = {
  on_attach = function(client)
    mappings(client)
  end
}

servers.dockerls = {
  on_attach = function(client)
    mappings(client)
  end
}

servers.html = {
  on_attach = function(client)
    mappings(client)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.vuels = {
  on_attach = function(client)
    mappings(client)
  end
}

servers.cssls = {
  on_attach = function(client)
    mappings(client)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.gopls = {
  cmd = {"gopls", "serve"},
  settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}},
  on_attach = function(client)
    mappings(client)
  end
}

servers.tsserver = {
  root_dir = util.root_pattern(
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
    vim.fn.getcwd()
  ),
  on_attach = function(client)
    mappings(client)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.efm = efmConfig

for server, config in pairs(servers) do
  lspconfig[server].setup(
    vim.tbl_deep_extend("force", {capabilities = capabilities}, config)
  )
end

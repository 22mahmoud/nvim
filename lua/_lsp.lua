local lspconfig = require('lspconfig')
local completion = require('completion')
local nlua = require('nlua.lsp.nvim')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local custom_attach = function(client) 
  completion.on_attach(client)
end

nlua.setup(lspconfig, {
  on_attach = custom_attach,
  globals = {
    "use"
  }
})

local servers = {
  bashls = {},
  vimls = {},
  tsserver = {},
  jsonls = {},
  clangd = {},
  svelte = {},
  jedi_language_server = {},
  intelephense = {},
  dockerls = {},
  html = {},
  vuels = {},
  cssls = {},
}

servers.gopls = {
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true
      },
      staticcheck = true
    }
  }
}

for server, config in pairs(servers) do
  lspconfig[server].setup(
    vim.tbl_deep_extend("force", {
      on_attach = custom_attach,
      capabilities = capabilities
    }, config)
  )
end

local lspconfig = require("lspconfig")
local nlua = require("nlua.lsp.nvim")
local util = require("lspconfig/util")
local custom_attach = require("lsp.custom_attach")
local efmConfig = require("lsp.efm")
local lspsaga = require("lspsaga")
local lspkind = require("lspkind")

lspkind.init()

lspsaga.init_lsp_saga({use_saga_diagnostic_sign = false})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nlua.setup(
  lspconfig,
  {
    root_dir = util.root_pattern(
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      ".git",
      vim.fn.getcwd()
    ),
    on_attach = function(client)
      custom_attach(client)
    end,
    globals = {"use", "awesome"}
  }
)

local servers = {}

servers.bashls = {
  on_attach = function(client)
    custom_attach(client)
  end
}

servers.vimls = {
  on_attach = function(client)
    custom_attach(client)
  end
}

servers.jsonls = {
  on_attach = function(client)
    custom_attach(client)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.clangd = {
  on_attach = function(client)
    custom_attach(client)
  end
}

servers.svelte = {
  filetypes = {"svelte"},
  on_attach = function(client)
    custom_attach(client)
    client.server_capabilities.completionProvider.triggerCharacters = {
      ".",
      '"',
      "'",
      "`",
      "/",
      "@",
      "*",
      "#",
      "$",
      "+",
      "^",
      "(",
      "[",
      "-",
      ":"
    }
  end,
  settings = {
    svelte = {
      plugin = {
        html = {
          completions = {
            enable = true,
            emmet = false
          }
        },
        svelte = {
          completions = {
            enable = true,
            emmet = false
          }
        },
        css = {
          completions = {
            enable = true,
            emmet = false
          }
        }
      }
    }
  }
}

servers.jedi_language_server = {
  on_attach = function(client)
    custom_attach(client)
  end
}

servers.intelephense = {
  on_attach = function(client)
    custom_attach(client)
  end
}

servers.dockerls = {
  on_attach = function(client)
    custom_attach(client)
  end
}

servers.html = {
  on_attach = function(client)
    custom_attach(client)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.vuels = {
  on_attach = function(client)
    custom_attach(client)
  end
}

servers.cssls = {
  on_attach = function(client)
    custom_attach(client)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.gopls = {
  cmd = {"gopls", "serve"},
  settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}},
  on_attach = function(client)
    custom_attach(client)
  end
}

servers.tsserver = {
  filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
  root_dir = util.root_pattern(
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
    vim.fn.getcwd()
  ),
  on_attach = function(client)
    custom_attach(client)
    client.resolved_capabilities.document_formatting = false
  end
}

servers.efm = efmConfig

for server, config in pairs(servers) do
  lspconfig[server].setup(
    vim.tbl_deep_extend("force", {capabilities = capabilities}, config)
  )
end

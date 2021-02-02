local lspconfig = require("lspconfig")
local nlua = require("nlua.lsp.nvim")
local util = require("lspconfig/util")
local map = vim.api.nvim_set_keymap

require "_diagnostic"

local mapper = function(mode, key, result)
  map(
    mode,
    key,
    "<cmd>lua " .. result .. "<cr>",
    {noremap = true, silent = true}
  )
end

-- snippets support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local custom_attach = function(client, _, server)
  local ft = vim.api.nvim_buf_get_option(0, "filetype")

  -- integrate fzf with lsp events
  require("lspfuzzy").setup {}

  -- let efm server handles linting and formatting stuff
  if server == "efm" then
    client.resolved_capabilities.document_formatting = true
  else
    client.resolved_capabilities.document_formatting = false
  end

  if ft ~= "lua" then
    mapper("n", "K", "vim.lsp.buf.hover()")
  end

  mapper("n", "ga", "vim.lsp.buf.code_action()")
  mapper("n", "gr", "vim.lsp.buf.references()")
  mapper("n", "gd", "vim.lsp.buf.definition()")
  mapper("n", "gD", "vim.lsp.buf.implementation()")
  mapper("n", ",f", "vim.lsp.buf.formatting()")
  mapper("n", "<leader>r", "vim.lsp.buf.rename()")

  -- diagnostic
  map(
    "n",
    "<leader>dd",
    ":LspDiagnostics 0<CR>",
    {noremap = true, silent = true}
  )
  mapper("n", "<leader>dn", "vim.lsp.diagnostic.goto_next()")
  mapper("n", "<leader>dn", "vim.lsp.diagnostic.goto_next()")
  mapper("n", "<leader>dp", "vim.lsp.diagnostic.goto_prev()")
  mapper("n", "<leader>ds", "vim.lsp.diagnostic.show_line_diagnostics()")
end

nlua.setup(
  lspconfig,
  {
    on_attach = function(client, bufnr)
      custom_attach(client, bufnr, "sumneko_lua")
    end,
    globals = {"use"}
  }
)

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
  cssls = {}
}

servers.gopls = {
  cmd = {"gopls", "serve"},
  settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}}
}

servers.tsserver = {
  root_dir = util.root_pattern(
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
    vim.fn.getcwd()
  )
}

local prettier = {
  formatCommand = "./node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
  formatStdin = true
}

local eslint_d = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local luafmt = {
  formatCommand = "luafmt -i 2 -l 80 --stdin",
  formatStdin = true
}

servers.efm = {
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  filetypes = {
    "javascript",
    "typescript",
    "typescriptreact",
    "javascriptreact",
    "css",
    "scss",
    "json",
    "html",
    "lua"
  },
  init_options = {documentFormatting = true},
  settings = {
    languages = {
      typescript = {prettier, eslint_d},
      javascript = {prettier, eslint_d},
      typescriptreact = {prettier, eslint_d},
      javascriptreact = {prettier, eslint_d},
      css = {prettier},
      scss = {prettier},
      json = {prettier},
      html = {prettier},
      lua = {luafmt}
    }
  }
}

for server, config in pairs(servers) do
  lspconfig[server].setup(
    vim.tbl_deep_extend(
      "force",
      {
        on_attach = function(client, bufnr)
          custom_attach(client, bufnr, server)
        end
      },
      config
    )
  )
end

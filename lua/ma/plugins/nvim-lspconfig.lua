local lspconfig = require "lspconfig"
local root_pattern = require("lspconfig/util").root_pattern

local lsp = vim.lsp
local fn = vim.fn

local keys_mapping = {
  n = {
    {",f", lsp.buf.formatting, "document_formatting"},
    {"gr", lsp.buf.references, "find_references"},
    {"K", lsp.buf.hover, "hover"},
    {"gi", lsp.buf.implementation, "implementation"},
    {"gi", lsp.buf.implementation, "implementation"},
    {"gd", lsp.buf.definition, "goto_definition"},
    {"gd", lsp.buf.declaration, "declaration"},
    {"sh", lsp.buf.signature_help, "signature_help"},
    {"gW", lsp.buf.workspace_symbol, "workspace_symbol"},
    {"ga", lsp.buf.code_action, "code_action"},
    {"<leader>l", lsp.codelens.run, "code_lens"},
    {"<leader>rn", lsp.buf.rename, "rename"}
  },
  v = {
    {",f", lsp.buf.range_formatting, "document_range_formatting"}
  },
  i = {
    {"<c-space>", lsp.buf.signature_help, "signature_help"}
  }
}

local function lsp_import_on_completion(bufnr)
  local completed_item = vim.v.completed_item
  if
    not (completed_item and completed_item.user_data and
      completed_item.user_data.nvim and
      completed_item.user_data.nvim.lsp and
      completed_item.user_data.nvim.lsp.completion_item)
   then
    return
  end

  local item = completed_item.user_data.nvim.lsp.completion_item
  lsp.buf_request(
    bufnr,
    "completionItem/resolve",
    item,
    function(_, _, result)
      if result and result.additionalTextEdits then
        lsp.util.apply_text_edits(result.additionalTextEdits, bufnr)
      end
    end
  )
end

local function get_sumneko_cmd()
  local os = jit.os
  local cache_dir = vim.fn.stdpath("cache")

  local sumneko_root_path =
    string.format("%s/lspconfig/sumneko_lua/lua-language-server", cache_dir)

  local sumneko_bin =
    string.format("%s/bin/%s/lua-language-server", sumneko_root_path, os)

  return {
    sumneko_bin,
    "-E",
    string.format("%s/main.lua", sumneko_root_path)
  }
end

local function create_buf_mapper(client, bufnr)
  return function(mode)
    return function(lhs, rhs, capability)
      if capability and not client.resolved_capabilities[capability] then
        return
      end

      local mapper = _.utils.map(mode, {silent = true, noremap = true})
      mapper(lhs, rhs, {bufnr = bufnr})
    end
  end
end

local function publishDiagnostics(error, result, ctx)
  lsp.diagnostic.on_publish_diagnostics(error, result, ctx)

  local bufnr = vim.uri_to_bufnr(result.uri)
  if bufnr ~= vim.api.nvim_get_current_buf() then
    return
  end

  local diagnostics = vim.diagnostic.get(bufnr)

  fn.setloclist(
    0,
    {},
    "r",
    {
      title = "LSP errors",
      bufnr = bufnr,
      items = vim.diagnostic.toqflist(diagnostics)
    }
  )
end

local function lsp_handlers()
  lsp.handlers["textDocument/publishDiagnostics"] = publishDiagnostics

  lsp.handlers["textDocument/signatureHelp"] =
    lsp.with(lsp.handlers.signature_help, {border = "single"})

  lsp.handlers["textDocument/hover"] =
    lsp.with(lsp.handlers.hover, {border = "single"})
end

local function lsp_mappings(client, bufnr)
  local mapper = create_buf_mapper(client, bufnr)
  for mode, y in pairs(keys_mapping) do
    local map = mapper(mode)
    for _, mapping in pairs(y) do
      map(unpack(mapping))
    end
  end
end

local function lsp_autocommands(client, bufnr)
  if client.resolved_capabilities.document_highlight then
    _.utils.augroup(
      "LspDocumentHighlight",
      {
        {
          events = {"CursorHold"},
          targets = {"<buffer>"},
          command = lsp.buf.document_highlight
        },
        {
          events = {"CursorMoved"},
          targets = {"<buffer>"},
          command = lsp.buf.clear_references
        }
      }
    )
  end

  if client.resolved_capabilities.code_lens then
    _.utils.augroup(
      "LspCodeLens",
      {
        {
          events = {"BufEnter", "CursorHold", "InsertLeave"},
          targets = {"<buffer>"},
          command = lsp.codelens.refresh
        }
      }
    )
  end

  _.utils.augroup(
    "LspAutoImport",
    {
      {
        events = {"CompleteDone"},
        targets = {"*"},
        command = function ()
          lsp_import_on_completion(bufnr)
        end
      }
    }
  )
end

local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  lsp_mappings(client, bufnr)
  lsp_autocommands(client, bufnr)
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
  sumneko_lua = {
    cmd = get_sumneko_cmd(),
    root_dir = root_pattern(".git", vim.fn.getcwd()),
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";")
        },
        diagnostics = {
          globals = {"vim"}
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
}

local function setup()
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

  lsp_handlers()

  setup_servers(servers)
end

setup()

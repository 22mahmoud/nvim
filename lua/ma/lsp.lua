local lspconfig = require 'lspconfig'
local methods = vim.lsp.protocol.Methods

local cmp = require 'ma.completion'

local M = {}

local function lsp_highlight_document(client, bufnr)
  if not client.supports_method(methods.textDocument_documentHighlight) then
    return
  end

  G.augroup('LspDocumentHighlight', {
    {
      events = { 'CursorHold', 'CursorHoldI' },
      buffer = bufnr,
      command = vim.lsp.buf.document_highlight,
    },
    {
      events = { 'CursorMoved' },
      buffer = bufnr,
      command = vim.lsp.buf.clear_references,
    },
  })
end

local function lsp_code_lens_refresh(client, bufnr)
  if not client.supports_method(methods.textDocument_codeLens) then
    return
  end

  G.augroup('LspCodeLens', {
    {
      events = { 'BufEnter', 'CursorHold', 'InsertLeave' },
      buffer = bufnr,
      command = vim.lsp.codelens.refresh,
    },
  })
end

local function setup_lsp_kind()
  vim.lsp.protocol.CompletionItemKind = {
    '󰉿 (Text)',
    '󰆧 (Method)',
    '󰊕 (Function)',
    ' (Constructor)',
    '󰜢 (Field)',
    '󰀫 (Variable)',
    '󰠱 (Class)',
    ' (Interface)',
    ' (Module)',
    '󰜢 (Property)',
    '󰑭 (Unit)',
    '󰎠 (Value)',
    ' (Enum)',
    '󰌋 (Keyword)',
    ' (Snippet)',
    '󰏘 (Color)',
    '󰈙 (File)',
    '󰈇 (Reference)',
    '󰉋 (Folder)',
    ' (EnumMember)',
    '󰏿 (Constant)',
    '󰙅 (Struct)',
    ' (Event)',
    '󰆕 (Operator)',
    '  (TypeParameter)',
  }
end

local function set_lsp_buffer_keybindings(client, bufnr)
  local mappings = {
    n = G.nmap,
    i = G.imap,
    v = G.vmap,
  }

  for mode, keybindings in pairs(G.lsp_mappings) do
    local map = mappings[mode]

    for _, mapping in pairs(keybindings) do
      local lhs, rhs, capability = unpack(mapping)

      -- skip mapping if capability not enabled
      if capability and not client.supports_method(capability) then
        goto continue
      end

      map(lhs, rhs, { buffer = bufnr })

      ::continue::
    end
  end
end

function M.get_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  return capabilities
end

local function setup_omnifunc(client, bufnr)
  if not client.supports_method(methods.textDocument_completion) then
    return
  end

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end

M.on_attach = G.applySpec {
  setup_omnifunc,
  lsp_highlight_document,
  lsp_code_lens_refresh,
  set_lsp_buffer_keybindings,
  cmp.attach,
}

function M.get_config_opts()
  return {
    on_attach = M.on_attach,
    capabilities = M.get_client_capabilities(),
    flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    },
  }
end

local function load_neodev()
  local loaded, neodev = pcall(require, 'neodev')

  if loaded then
    neodev.setup {}
  end
end

function M.setup(servers)
  load_neodev()

  setup_lsp_kind()

  local config = M.get_config_opts()

  for server, user_config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend('force', config, user_config))
  end
end

return M

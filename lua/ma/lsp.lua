local lspconfig = require 'lspconfig'
local methods = vim.lsp.protocol.Methods

local augroup = vim.api.nvim_create_augroup
local clear = vim.api.nvim_clear_autocmds

local M = {}

local function lsp_highlight_document(client, bufnr)
  if not client.supports_method(methods.textDocument_documentHighlight) then return end

  local group = augroup('LspDocumentHighlight', { clear = false })

  clear { group = group, buffer = bufnr }

  G.augroup(group, {
    {
      events = { 'CursorHold', 'CursorHoldI' },
      buffer = bufnr,
      command = vim.lsp.buf.document_highlight,
    },
    {
      events = { 'CursorMoved', 'CursorMovedI' },
      buffer = bufnr,
      command = vim.lsp.buf.clear_references,
    },
  })
end

local function lsp_code_lens_refresh(client, bufnr)
  if not client.supports_method(methods.textDocument_codeLens) then return end

  local group = augroup('LspCodeLens', { clear = false })

  clear { group = group, buffer = bufnr }
  G.augroup(group, {
    {
      events = { 'BufEnter', 'CursorHold', 'InsertLeave' },
      buffer = bufnr,
      command = vim.lsp.codelens.refresh,
    },
  }, { clear = false })
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
      if capability and client.supports_method(capability) then
        map(lhs, rhs, { buffer = bufnr })
      end
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
  if not client.supports_method(methods.textDocument_completion) then return end

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end

G.augroup('UserLspAttach', {
  {
    events = 'LspAttach',
    command = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      G.augroup('RefreshTsLsp', {
        {
          events = { 'BufWritePost' },
          pattern = { '*.js', '*.ts', '*.tsx', '*.jsx' },
          command = function(ctx)
            if client then client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match }) end
          end,
        },
      })

      G.applySpec {
        setup_omnifunc,
        lsp_highlight_document,
        lsp_code_lens_refresh,
        set_lsp_buffer_keybindings,
      }(client, args.buf)
    end,
  },
})

function M.get_config_opts()
  return {
    capabilities = M.get_client_capabilities(),
    flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    },
  }
end

function M.setup(servers)
  setup_lsp_kind()

  local config = M.get_config_opts()

  for server, user_config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend('force', config, user_config))
  end
end

return M

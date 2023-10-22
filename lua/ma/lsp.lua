local lspconfig = require 'lspconfig'
local methods = vim.lsp.protocol.Methods

local M = {}

local function lsp_highlight_document(client)
  if not client.supports_method(methods.textDocument_documentHighlight) then
    return
  end

  G.augroup('LspDocumentHighlight', {
    {
      events = { 'CursorHold', 'CursorHoldI' },
      targets = { '<buffer>' },
      command = vim.lsp.buf.document_highlight,
    },
    {
      events = { 'CursorMoved' },
      targets = { '<buffer>' },
      command = vim.lsp.buf.clear_references,
    },
  })
end

local function lsp_code_lens_refresh(client)
  if not client.supports_method(methods.textDocument_codeLens) then
    return
  end

  G.augroup('LspCodeLens', {
    {
      events = { 'BufEnter', 'CursorHold', 'InsertLeave' },
      targets = { '<buffer>' },
      command = vim.lsp.codelens.refresh,
    },
  })
end

local function floating_preview_popup()
  local original_fn = vim.lsp.util.open_floating_preview

  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
    local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

    local default_opts = {
      max_width = max_width,
      max_height = max_height,
    }

    return original_fn(
      contents,
      syntax,
      vim.tbl_extend('force', opts or {}, default_opts),
      ...
    )
  end
end

local function floating_window_borders()
  local original_fn = vim.lsp.util.make_floating_popup_options

  function vim.lsp.util.make_floating_popup_options(width, height, opts, ...)
    return original_fn(
      width,
      height,
      vim.tbl_deep_extend('force', opts or {}, { border = 'rounded' }),
      ...
    )
  end
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

  for mode, keybindings in pairs(G.lsp.mappings) do
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

function M.on_attach(client, bufnr)
  if client.supports_method(methods.textDocument_completion) then
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end

  lsp_highlight_document(client)
  lsp_code_lens_refresh(client)
  set_lsp_buffer_keybindings(client, bufnr)
end

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
  floating_preview_popup()
  floating_window_borders()

  local config = M.get_config_opts()

  for server, user_config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend('force', config, user_config))
  end
end

return M

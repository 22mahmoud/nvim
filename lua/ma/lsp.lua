local M = {}

local border = {
  { '╭' },
  { '─' },
  { '╮' },
  { '│' },
  { '╯' },
  { '─' },
  { '╰' },
  { '│' },
}

local function lsp_highlight_document(client)
  if not client.server_capabilities.documentHighlightProvider then
    return
  end

  G.augroup('LspDocumentHighlight', {
    {
      events = { 'CursorHold' },
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
  if not client.server_capabilities.codeLensProvider then
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

  vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
    local max_width = math.max(math.floor(vim.opt.columns:get() * 0.7), 80)
    local max_height = math.max(math.floor(vim.opt.lines:get() * 0.3), 30)

    local default_opts = {
      max_width = max_width,
      max_height = max_height,
      separator = false,
    }

    return original_fn(
      contents,
      syntax,
      vim.tbl_extend('force', opts or {}, default_opts)
    )
  end
end

local function floating_window_borders()
  local original_fn = vim.lsp.util.make_floating_popup_options

  vim.lsp.util.make_floating_popup_options = function(width, height, opts)
    return original_fn(
      width,
      height,
      vim.tbl_deep_extend('force', opts or {}, { border = border })
    )
  end
end

local function setup_lsp_kind()
  vim.lsp.protocol.CompletionItemKind = {
    '   (Text)',
    '   (Method)',
    '   (Function)',
    '   (Constructor)',
    '   (Field)',
    '   (Variable)',
    '   (Class)',
    ' ﰮ  (Interface)',
    '   (Module)',
    ' 襁 (Property)',
    '   (Unit)',
    '   (Value)',
    ' 練 (Enum)',
    '   (Keyword)',
    '   (Snippet)',
    '   (Color)',
    '   (File)',
    '   (Reference)',
    '   (Folder)',
    '   (EnumMember)',
    '   (Constant)',
    '   (Struct)',
    '   (Event)',
    '   (Operator)',
    '   (TypeParameter)',
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
      if capability and not client.server_capabilities[capability] then
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
  vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'
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

function M.setup(servers)
  local lspconfig = require 'lspconfig'

  floating_preview_popup()

  floating_window_borders()

  setup_lsp_kind()

  local config = M.get_config_opts()

  for server, user_config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend('force', config, user_config))
  end
end

return M

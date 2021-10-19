local M = {}

local function lsp_highlight_document(client)
  if not client.resolved_capabilities.document_highlight then
    return
  end

  _.utils.augroup('LspDocumentHighlight', {
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
  if not client.resolved_capabilities.code_lens then
    return
  end

  _.utils.augroup('LspCodeLens', {
    {
      events = { 'BufEnter', 'CursorHold', 'InsertLeave' },
      targets = { '<buffer>' },
      command = vim.lsp.codelens.refresh,
    },
    {
      events = { 'InsertLeave' },
      targets = { '<buffer>' },
      command = vim.lsp.codelens.display,
    },
  })
end

local function setup_lsp_kind()
  vim.lsp.protocol.CompletionItemKind = {
    '   (Text) ',
    '   (Method)',
    '   (Function)',
    '   (Constructor)',
    '   (Field)',
    '  (Variable)',
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

local function set_lsp_buffer_keybindings(client, bufnr, keymaps)
  local mappings = {
    n = _.utils.nmap,
    i = _.utils.imap,
    v = _.utils.vmap,
  }

  for mode, keybindings in pairs(keymaps) do
    local map = mappings[mode]

    for _, mapping in pairs(keybindings) do
      local lhs, rhs, capability = unpack(mapping)

      -- skip mapping if capability not enabled
      if capability and not client.resolved_capabilities[capability] then
        goto continue
      end

      map(lhs, rhs, { bufnr = bufnr })

      ::continue::
    end
  end
end

local function publishDiagnostics(error, result, ctx)
  vim.lsp.diagnostic.on_publish_diagnostics(error, result, ctx)

  local bufnr = vim.uri_to_bufnr(result.uri)
  if bufnr ~= vim.api.nvim_get_current_buf() then
    return
  end

  local diagnostics = vim.diagnostic.get(bufnr)

  vim.fn.setloclist(0, {}, 'r', {
    title = 'LSP errors',
    bufnr = bufnr,
    items = vim.diagnostic.toqflist(diagnostics),
  })
end

local function setup_lsp_handlers()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = publishDiagnostics

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'single' }
  )

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'single' }
  )
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
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  lsp_highlight_document(client)
  lsp_code_lens_refresh(client)
  set_lsp_buffer_keybindings(client, bufnr, _.lsp.mappings)
end

function M.get_config_opts()
  return {
    on_attach = M.on_attach,
    capabilities = M.get_client_capabilities(),
  }
end

function M.setup(servers)
  local lspconfig = require 'lspconfig'

  setup_lsp_handlers()

  setup_lsp_kind()

  local config = M.get_config_opts()

  for server, user_config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend('force', config, user_config))
  end
end

return M

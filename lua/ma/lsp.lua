local cmd = vim.api.nvim_create_user_command
local methods = vim.lsp.protocol.Methods
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local open_floating_preview = vim.lsp.util.open_floating_preview

local M = {}

local servers = {
  'ts_ls',
  'biome',
  'html',
  'cssls',
  'css_variables',
  'jsonls',
  'yamlls',
  'tailwindcss',
  'graphql',
  'lua_ls',
  'efm',
  'ccls',
  'bashls',
  'gopls',
  'dockerls',
  'phpactor',
  'taplo',
  'pyright',
  'ruff',
  'djlsp',
  'gdscript'
}

---@param client vim.lsp.Client
---@param bufnr number
function M.lsp_highlight_document(client, bufnr)
  if not client:supports_method(methods.textDocument_documentHighlight) then return end

  autocmd('CursorHold', { buffer = bufnr, callback = vim.lsp.buf.document_highlight })
  autocmd('CursorHoldI', { buffer = bufnr, callback = vim.lsp.buf.document_highlight })
  autocmd('CursorMoved', { buffer = bufnr, callback = vim.lsp.buf.clear_references })
end

---@param client vim.lsp.Client
---@param bufnr number
function M.lsp_code_lens_refresh(client, bufnr)
  if not client:supports_method(methods.textDocument_codeLens) then return end

  autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
  })
end

---@param client vim.lsp.Client
---@param bufnr number
function M.set_lsp_buffer_keybindings(client, bufnr)
  local keymap = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr }) end

  if client:supports_method(methods.textDocument_formatting) then
    keymap('n', ',f', vim.lsp.buf.format)
  end

  if client:supports_method(methods.textDocument_signatureHelp) then
    keymap('n', 'gs', vim.lsp.buf.signature_help)
  end

  if client:supports_method(methods.textDocument_declaration) then
    keymap('n', 'gD', vim.lsp.buf.declaration)
  end
end

---@param client vim.lsp.Client
---@param bufnr number
function M.auto_format_on_save(client, bufnr)
  if not vim.g.lsp_auto_format then return end

  if
    not client:supports_method(methods.textDocument_willSaveWaitUntil)
    and client:supports_method(methods.textDocument_formatting)
  then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup('UserLspAttach', { clear = false }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.format { bufnr = bufnr, id = client.id, timeout_ms = 1000 } end,
    })
  end
end

---@param client vim.lsp.Client
---@param bufnr number
function M.setup_cmp(client, bufnr)
  if not client:supports_method(methods.textDocument_completion) then return end

  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
end

---@param client vim.lsp.Client
---@param bufnr number
function M.type_formatting(client, bufnr)
  if not client:supports_method(methods.textDocument_onTypeFormatting, bufnr) then return end

  vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
end

function M.open_floating_preview(contents, syntax, _opts)
  local opts = vim.tbl_extend('force', {
    max_width = math.min(math.floor(vim.o.columns * 0.7), 100),
    max_height = math.min(math.floor(vim.o.lines * 0.3), 30),
  }, _opts or {})

  return open_floating_preview(contents, syntax, opts)
end

function M.get_client_capabilities()
  return vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = {
      completion = {
        completionItem = {
          resolveSupport = {
            properties = {
              'documentation',
              'detail',
              'additionalTextEdits',
              'command',
              'data',
            },
          },
        },
        completionList = {
          itemDefaults = {
            'commitCharacters',
            'editRange',
            'insertTextFormat',
            'insertTextMode',
            'data',
          },
        },
      },
    },
  })
end

function M.setup_lsp_kind()
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

function M.setup()
  vim.lsp.util.open_floating_preview = M.open_floating_preview
  M.setup_lsp_kind()

  vim.lsp.config('*', {
    capabilities = M.get_client_capabilities(),
    root_markers = { '.git', 'package.json' },
  })

  autocmd({ 'LspAttach' }, {
    group = augroup('UserLspAttach', {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      for _, fn in ipairs {
        M.setup_cmp,
        M.lsp_highlight_document,
        M.lsp_code_lens_refresh,
        M.set_lsp_buffer_keybindings,
        M.type_formatting,
        M.auto_format_on_save,
      } do
        fn(client, args.buf)
      end
    end,
  })

  vim.lsp.enable(servers)
end

cmd('LspReload', function()
  for _, client in ipairs(vim.lsp.get_clients()) do
    client:stop()
  end

  vim.cmd [[edit!]]
end, {})

M.setup()

return M

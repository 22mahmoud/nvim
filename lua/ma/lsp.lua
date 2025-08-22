local utils = require 'ma.utils'

local cmd = vim.api.nvim_create_user_command

local M = {}

local methods = vim.lsp.protocol.Methods
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local auclear = vim.api.nvim_clear_autocmds
local open_floating_preview = vim.lsp.util.open_floating_preview

---@param client vim.lsp.Client
---@param bufnr number
function M.lsp_highlight_document(client, bufnr)
  if not client:supports_method(methods.textDocument_documentHighlight, bufnr) then return end

  local group = augroup('LspDocumentHighlight', { clear = false })

  autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })

  autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })

  autocmd({ 'LspDetach' }, {
    group = augroup('UserLspDetach', { clear = true }),
    callback = function(event)
      vim.lsp.buf.clear_references()
      auclear { group = group, buffer = event.buf }
    end,
  })
end

---@param client vim.lsp.Client
---@param bufnr number
function M.lsp_code_lens_refresh(client, bufnr)
  if not client:supports_method(methods.textDocument_codeLens, bufnr) then return end

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
  if client:supports_method(methods.textDocument_formatting) then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function() vim.lsp.buf.format { bufnr = bufnr, id = client.id } end,
    })
  end
end

---@param client vim.lsp.Client
---@param bufnr number
function M.setup_cmp(client, bufnr)
  if not client:supports_method(methods.textDocument_completion, bufnr) then return end

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  vim.lsp.completion.enable(true, client.id, bufnr)
end

function M.override_floating_preview()
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
    local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

    local _opts = vim.tbl_extend('force', opts or {}, {
      max_width = max_width,
      max_height = max_height,
    })

    return open_floating_preview(contents, syntax, _opts, ...)
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

function M.setup(servers)
  M.override_floating_preview()
  M.setup_lsp_kind()

  vim.lsp.config('*', {
    capabilities = M.get_client_capabilities(),
    root_markers = { '.git', 'package.json' },
  })

  autocmd({ 'LspAttach' }, {
    group = augroup('UserLspAttach', {}),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if not client or not args.buf then return end

      utils.applySpec {
        M.setup_cmp,
        M.lsp_highlight_document,
        M.lsp_code_lens_refresh,
        M.set_lsp_buffer_keybindings,
        -- M.auto_format_on_save,
      }(client, args.buf)
    end,
  })

  vim.lsp.enable(servers)
end

cmd('LspReload', function()
  vim.lsp.stop_client(vim.lsp.get_clients())
  vim.cmd [[edit!]]
end, {})

return M

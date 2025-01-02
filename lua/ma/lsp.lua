local utils = require 'ma.utils'

local M = {}

local methods = vim.lsp.protocol.Methods
local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local auclear = vim.api.nvim_clear_autocmds
local open_floating_preview = vim.lsp.util.open_floating_preview

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

function M.lsp_code_lens_refresh(client, bufnr)
  if not client:supports_method(methods.textDocument_codeLens, bufnr) then return end

  autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
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

function M.set_lsp_buffer_keybindings(client, bufnr)
  for mode, keybindings in pairs(G.lsp_mappings) do
    for _, mapping in pairs(keybindings) do
      local lhs, rhs, capability = unpack(mapping)

      -- skip mapping if capability not enabled
      if capability and client:supports_method(capability, bufnr) then
        ---@diagnostic disable-next-line: param-type-mismatch
        keymap(mode, lhs, rhs, { buffer = bufnr })
      end
    end
  end
end

function M.setup_cmp(client, bufnr)
  if not client:supports_method(methods.textDocument_completion, bufnr) then return end

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  vim.lsp.completion.enable(true, client.id, bufnr)
end

function M.override_floating_preview()
  local border = {
    { '┌', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '┐', 'FloatBorder' },
    { '│', 'FloatBorder' },
    { '┘', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '└', 'FloatBorder' },
    { '│', 'FloatBorder' },
  }

  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
    local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

    local default_opts = {
      max_width = max_width,
      max_height = max_height,
      border = border,
    }

    local buf, win = open_floating_preview(
      contents,
      syntax,
      vim.tbl_extend('force', opts or {}, default_opts),
      ...
    )

    return buf, win
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

function M.setup(servers)
  M.override_floating_preview()
  M.setup_lsp_kind()

  vim.lsp.config('*', { capabilities = M.get_client_capabilities(), root_markers = { '.git' } })

  autocmd({ 'LspAttach' }, {
    group = augroup('UserLspAttach', {}),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      utils.applySpec {
        M.setup_cmp,
        M.lsp_highlight_document,
        M.lsp_code_lens_refresh,
        M.set_lsp_buffer_keybindings,
      }(client, args.buf)
    end,
  })

  vim.lsp.enable(servers)
end

return M

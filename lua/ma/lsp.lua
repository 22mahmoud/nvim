local methods = vim.lsp.protocol.Methods

local augroup = vim.api.nvim_create_augroup
local clear = vim.api.nvim_clear_autocmds
local open_floating_preview = vim.lsp.util.open_floating_preview

local function lsp_highlight_document(client, bufnr)
  if not client:supports_method(methods.textDocument_documentHighlight, bufnr) then return end

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
  if not client:supports_method(methods.textDocument_codeLens, bufnr) then return end

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
      if capability and client:supports_method(capability, bufnr) then
        map(lhs, rhs, { buffer = bufnr })
      end
    end
  end
end

local function setup_omnifunc(client, bufnr)
  if not client:supports_method(methods.textDocument_completion, bufnr) then return end

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end

G.augroup('UserLspAttach', {
  {
    events = 'LspAttach',
    command = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      G.augroup('RefreshTsLsp', {
        {
          events = { 'BufWritePost' },
          pattern = { '*.js', '*.ts', '*.tsx', '*.jsx' },
          command = function(ctx)
            if client then client:notify('$/onDidChangeTsOrJsFile', { uri = ctx.match }) end
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

  local buf, win =
    open_floating_preview(contents, syntax, vim.tbl_extend('force', opts or {}, default_opts), ...)

  return buf, win
end

setup_lsp_kind()

local utils = require("ma.utils")

local nnoremap = utils.nnoremap
local augroup = utils.augroup

local function custom_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

  if client.resolved_capabilities.document_highlight then
    augroup(
      "LspCursorCommands",
      {
        {
          events = {"CursorHold"},
          targets = {"<buffer>"},
          command = vim.lsp.buf.document_highlight
        },
        {
          events = {"CursorHoldI"},
          targets = {"<buffer>"},
          command = vim.lsp.buf.document_highlight
        },
        {
          events = {"CursorMoved"},
          targets = {"<buffer>"},
          command = vim.lsp.buf.clear_references
        }
      }
    )
  end

  -- Mappings.
  local opts = {bufnr = bufnr}

  if client.resolved_capabilities.declaration then
    nnoremap('gD', vim.lsp.buf.declaration, opts)
  end

  if client.resolved_capabilities.hover and (ft ~= 'vim' or ft ~= 'lua') then
    nnoremap('K', vim.lsp.buf.hover, opts)
  end

  if client.resolved_capabilities.goto_definition then
    nnoremap('gd', vim.lsp.buf.definition, opts)
  end

  if client.resolved_capabilities.implementation then
    nnoremap('gi', vim.lsp.buf.implementation, opts)
  end

  if client.resolved_capabilities.rename then
    nnoremap('<leader>r', vim.lsp.buf.rename, opts)
  end

  if client.resolved_capabilities.code_action then
    nnoremap('ga', vim.lsp.buf.code_action, opts)
    nnoremap('ga', vim.lsp.buf.range_code_action, opts)
  end

  if client.resolved_capabilities.find_references then
    nnoremap('gr', vim.lsp.buf.references, opts)
  end

  if client.resolved_capabilities.document_formatting then
      nnoremap(',f', vim.lsp.buf.formatting, opts)
  end

  nnoremap('<leader>dn', vim.lsp.diagnostic.goto_next, opts)
  nnoremap('<leader>dp', vim.lsp.diagnostic.goto_prev, opts)
  nnoremap('<leader>ds', vim.lsp.diagnostic.show_line_diagnostics, opts)
end

return custom_attach

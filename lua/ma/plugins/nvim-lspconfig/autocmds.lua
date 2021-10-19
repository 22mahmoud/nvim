local lsp = vim.lsp

local function lsp_autocommands(client)
  if client.resolved_capabilities.document_highlight then
    _.utils.augroup(
      "LspDocumentHighlight",
      {
        {
          events = {"CursorHold"},
          targets = {"<buffer>"},
          command = lsp.buf.document_highlight
        },
        {
          events = {"CursorMoved"},
          targets = {"<buffer>"},
          command = lsp.buf.clear_references
        }
      }
    )
  end

  if client.resolved_capabilities.code_lens then
    _.utils.augroup(
      "LspCodeLens",
      {
        {
          events = {"BufEnter", "CursorHold", "InsertLeave"},
          targets = {"<buffer>"},
          command = lsp.codelens.refresh
        }
      }
    )
  end
end

return lsp_autocommands

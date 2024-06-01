local M = {}

local lsp = vim.lsp

local function process_lsp_response(request_result, processor)
  if not request_result then return {} end

  local response = {}

  for client_id, item in pairs(request_result) do
    if not item.error and item.result then
      vim.list_extend(response, processor(item.result, client_id) or {})
    end
  end

  return response
end

local function on_complete_done()
  local completed_item = vim.v.completed_item

  local item = vim.tbl_get(completed_item or {}, 'user_data', 'nvim', 'lsp', 'completion_item')

  if not item then return end

  local bufnr = vim.api.nvim_get_current_buf()

  lsp.buf_request_all(bufnr, lsp.protocol.Methods.completionItem_resolve, item, function(response)
    local edits = process_lsp_response(
      response,
      function(result) return result.additionalTextEdits end
    )

    if not edits then return end

    vim.lsp.util.apply_text_edits(edits, bufnr, 'utf-8')
  end)
end

function M.attach(client, bufnr)
  G.augroup('TSLspImportOnCompletion', {
    {
      events = 'CompleteDonePre',
      buffer = bufnr,
      command = on_complete_done,
    },
  })
end

return M

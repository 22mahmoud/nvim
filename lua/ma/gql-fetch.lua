local fn = vim.fn
local api = vim.api

local M = {}

local tmp_name = 'gql_results'

local function get_or_create_buf()
  local existing_bufnr = fn.bufnr(tmp_name)

  local bufnr = existing_bufnr ~= -1 and existing_bufnr or api.nvim_create_buf(true, false)

  if existing_bufnr == -1 then api.nvim_buf_set_name(bufnr, tmp_name) end

  api.nvim_set_option_value('buftype', 'nofile', { buf = bufnr })
  api.nvim_set_option_value('ft', 'http', { buf = bufnr })
  api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

  return bufnr
end

local function get_req_body()
  local filename = api.nvim_buf_get_name(0)
  local _, lines = pcall(fn.readfile, filename)
  return vim.json.encode { query = table.concat(lines, '\n') }
end

local function on_curl_complete(bufnr)
  return function(obj)
    local result = obj.stdout
    if not result then return end

    -- Split headers and body
    local parts = vim.split(result, '\r?\n\r?\n', { plain = false })
    local headers = vim.split(parts[1] or '', '\n', { trimempty = true })
    local json_lines = fn.split(fn.system({ 'jq', '-M', '.' }, parts[2]), '\n')

    api.nvim_buf_set_lines(bufnr, 0, #headers, false, headers)
    api.nvim_buf_set_lines(bufnr, -1, -1, false, { '' })
    api.nvim_buf_set_lines(bufnr, -1, -1, false, json_lines)

    if fn.bufwinnr(bufnr) == -1 then vim.cmd('vert sb ' .. tmp_name) end
  end
end

local function get_schema_url()
  local rcfile = '.graphqlrc.json'
  local _, content = pcall(fn.readfile, rcfile)
  local _, parsed = pcall(vim.json.decode, table.concat(content, '\n'))
  return parsed.schema
end

function M.run()
  local bufnr = get_or_create_buf()
  local req_body = get_req_body()
  if req_body == '' then return end

  local url = get_schema_url()
  if not url then return end

  local args = {
    'curl',
    '-i',
    url,
    '-d',
    req_body,
    '-K',
    '.curlrc',
  }

  vim.system(args, { text = true }, vim.schedule_wrap(on_curl_complete(bufnr)))
end

return M

local fn = vim.fn
local api = vim.api

local M = {}

local tmp_name = 'gql_results'

local function get_or_create_buf()
  local existing_bufnr = fn.bufnr(tmp_name)

  local bufnr = existing_bufnr ~= -1 and existing_bufnr or api.nvim_create_buf(true, false)

  if existing_bufnr == -1 then api.nvim_buf_set_name(bufnr, tmp_name) end

  api.nvim_set_option_value('buftype', 'nofile', { buf = bufnr })
  api.nvim_set_option_value('ft', 'httpResult', { buf = bufnr })
  api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

  return bufnr
end

local function get_req_body()
  local filename = api.nvim_buf_get_name(0)

  local req_body = fn.system(
    string.format([[jq -cMn --arg query "$(cat %s)" '{"query":$query}' | tr -d '\n']], filename)
  )

  return req_body
end

local function on_curl_complete(bufnr)
  return function(obj)
    local result = obj.stdout

    if not result then return end

    local data = fn.split(result, '\n\n')
    local headers = fn.split(data[1], '\n')
    local encoded_json = fn.json_encode(data[2])
    local json = fn.split(fn.system(string.format('echo %s | jq "."', encoded_json)), '\n')

    api.nvim_buf_set_lines(bufnr, 0, #headers, false, headers)

    local lines_count = api.nvim_buf_line_count(bufnr) - 1
    api.nvim_buf_set_lines(bufnr, lines_count, lines_count + #json, false, json)

    if fn.bufwinnr(bufnr) == -1 then vim.cmd([[vert sb ]] .. tmp_name) end
  end
end

function M.run()
  local bufnr = get_or_create_buf()
  local req_body = get_req_body()

  local url = fn.system [[cat .graphqlrc.json | jq -r ".schema" | tr -d "\n"]]

  vim.system(
    { 'curl', url, '-K', '.curlrc', '-d', req_body },
    { text = true },
    vim.schedule_wrap(on_curl_complete(bufnr))
  )
end

return M

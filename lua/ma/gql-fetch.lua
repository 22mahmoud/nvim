local api = vim.api

local M = {}

local tmp_name = 'gql_results'

---@return integer
local function get_or_create_buf()
  local existing_bufnr = vim.fn.bufnr(tmp_name)
  local bufnr = existing_bufnr ~= -1 and existing_bufnr or api.nvim_create_buf(false, true)

  if existing_bufnr == -1 then api.nvim_buf_set_name(bufnr, tmp_name) end

  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].buftype = 'nofile'
  vim.bo[bufnr].filetype = 'http'
  api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

  return bufnr
end

---@return string?
local function get_req_body()
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  local query = table.concat(lines, '\n')
  if query:find '%S' == nil then return nil end

  local ok, encoded = pcall(vim.json.encode, { query = query })
  if not ok then
    vim.notify('gql-fetch: failed to encode query', vim.log.levels.ERROR)
    return nil
  end

  return encoded
end

---@param bufnr integer
local function on_curl_complete(bufnr)
  ---@param obj vim.SystemCompleted
  return function(obj)
    if obj.code ~= 0 then
      vim.notify('gql-fetch: curl failed: ' .. (obj.stderr or ''), vim.log.levels.ERROR)
      return
    end

    local result = obj.stdout
    if not result or result == '' then return end

    -- Split headers and body
    local parts = vim.split(result, '\r?\n\r?\n', { plain = false })
    local headers = vim.split(parts[1] or '', '\n', { trimempty = true })
    local body = parts[2] or ''

    -- Format JSON asynchronously
    vim.system(
      { 'jq', '-M', '.' },
      { stdin = body, text = true },
      vim.schedule_wrap(function(jq)
        local json_lines
        if jq.code == 0 and jq.stdout then
          json_lines = vim.split(jq.stdout, '\n', { trimempty = true })
        else
          json_lines = vim.split(body, '\n', { trimempty = true })
        end

        api.nvim_buf_set_lines(bufnr, 0, -1, false, headers)
        api.nvim_buf_set_lines(bufnr, -1, -1, false, { '' })
        api.nvim_buf_set_lines(bufnr, -1, -1, false, json_lines)

        if vim.fn.bufwinnr(bufnr) == -1 then vim.cmd('vert sb ' .. tmp_name) end
      end)
    )
  end
end

---@return string?
local function get_schema_url()
  local matches = vim.fs.find('.graphqlrc.json', {
    upward = true,
    path = vim.uv.cwd(),
    limit = 1,
  })

  if #matches == 0 then
    vim.notify('gql-fetch: .graphqlrc.json not found', vim.log.levels.WARN)
    return nil
  end

  local ok, content = pcall(vim.fn.readfile, matches[1])
  if not ok then
    vim.notify('gql-fetch: failed to read ' .. matches[1], vim.log.levels.ERROR)
    return nil
  end

  local parse_ok, parsed = pcall(vim.json.decode, table.concat(content, '\n'))
  if not parse_ok or not parsed or not parsed.schema then
    vim.notify('gql-fetch: invalid .graphqlrc.json or missing schema field', vim.log.levels.ERROR)
    return nil
  end

  return parsed.schema
end

function M.run()
  local req_body = get_req_body()
  if not req_body then return end

  local url = get_schema_url()
  if not url then return end

  local bufnr = get_or_create_buf()

  vim.system({
    'curl',
    '-i',
    url,
    '-d',
    req_body,
    '-K',
    '.curlrc',
  }, { text = true }, vim.schedule_wrap(on_curl_complete(bufnr)))
end

return M

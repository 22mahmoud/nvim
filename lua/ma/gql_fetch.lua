local fn = vim.fn
local api = vim.api
local uv = vim.loop

local function run()
  local tmp_name = 'gql_results'
  local existing_bufnr = fn.bufnr(tmp_name)
  local result_bufnr = existing_bufnr ~= -1 and existing_bufnr
    or api.nvim_create_buf(true, 'nomodeline')

  if existing_bufnr == -1 then
    api.nvim_buf_set_name(result_bufnr, tmp_name)
  end

  api.nvim_buf_set_option(result_bufnr, 'buftype', 'nofile')
  api.nvim_buf_set_option(result_bufnr, 'ft', 'httpResult')

  local filename = api.nvim_buf_get_name(0)
  local req_body = fn.system(
    string.format(
      [[jq -cMn --arg query "$(cat %s)" '{"query":$query}' | tr -d '\n']],
      filename
    )
  )
  local url = fn.system [[cat .graphqlrc.json | jq -r ".schema" | tr -d "\n"]]

  local stdout = uv.new_pipe()
  local result = ''
  local handle

  local function cb()
    handle:close()
    stdout:read_stop()
    stdout:close()

    api.nvim_buf_set_lines(result_bufnr, 0, -1, false, {})

    local data = fn.split(result, '\r\n\r\n')
    local headers = fn.split(data[1], '\r\n')
    local encoded_json = fn.json_encode(data[2])
    local json =
      fn.split(fn.system(string.format('echo %s | jq "."', encoded_json)), '\n')

    api.nvim_buf_set_lines(result_bufnr, 0, #headers, false, headers)
    local lines_count = api.nvim_buf_line_count(result_bufnr) - 1
    api.nvim_buf_set_lines(
      result_bufnr,
      lines_count,
      lines_count + #json,
      false,
      json
    )

    if fn.bufwinnr(result_bufnr) == -1 then
      vim.cmd([[vert sb ]] .. tmp_name)
    end
  end

  handle = uv.spawn('curl', {
    args = { url, '-K', '.curlrc', '-d', req_body },
    stdio = { nil, stdout, nil },
  }, vim.schedule_wrap(cb))

  local function on_read(error, data)
    if error or not data then
      return
    end

    result = result .. data
  end

  uv.read_start(stdout, on_read)
end

vim.keymap.set('n', ',e', run, { noremap = true })

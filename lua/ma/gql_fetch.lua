local fn = vim.fn
local api = vim.api
local uv = vim.loop

-- [x] run function
local function run()
  -- [x] create or get the result buffer number
  local tmp_name = 'gql_results'
  local existing_bufnr = fn.bufnr(tmp_name)
  local result_bufnr = existing_bufnr ~= -1 and existing_bufnr
    or api.nvim_create_buf(true, 'nomodeline')

  -- [x] if buffer is not exist assign the tmp name
  if existing_bufnr == -1 then
    api.nvim_buf_set_name(result_bufnr, tmp_name)
  end

  -- [x] set options buftype
  api.nvim_buf_set_option(result_bufnr, 'buftype', 'nofile')
  api.nvim_buf_set_option(result_bufnr, 'ft', 'httpResult')

  -- [x] get filename
  local filename = api.nvim_buf_get_name(0)
  -- [x] get req body using jq
  local req_body = fn.system(
    string.format([[jq -cMn --arg query "$(cat %s)" '{"query":$query}' | tr -d '\n']], filename)
  )
  -- [x] get the url from .graphqlrc.json
  local url = fn.system [[cat .graphqlrc.json | jq -r ".schema" | tr -d "\n"]]

  local stdout = uv.new_pipe()
  local result = ''
  local handle

  local function cb()
    -- [x] close connection
    handle:close()
    stdout:read_stop()
    stdout:close()

    -- [x] delete buf contnet
    api.nvim_buf_set_lines(result_bufnr, 0, -1, false, {})

    -- [x] parse the headers and body
    local data = fn.split(result, '\r\n\r\n')
    local headers = fn.split(data[1], '\r\n')
    local encoded_json = fn.json_encode(data[2])
    local json = fn.split(fn.system(string.format('echo %s | jq "."', encoded_json)), '\n')

    -- [x] write headers and body into the buf
    api.nvim_buf_set_lines(result_bufnr, 0, #headers, false, headers)
    local lines_count = api.nvim_buf_line_count(result_bufnr) - 1
    api.nvim_buf_set_lines(result_bufnr, lines_count, lines_count + #json, false, json)

    -- [ ] check if buf opened on the window
    if fn.bufwinnr(result_bufnr) == -1 then
      vim.cmd([[vert sb ]] .. tmp_name)
    end
  end

  -- [x] create handle and loop with schedule_wrap cb
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

  -- [x] read_start to start the uv
  uv.read_start(stdout, on_read)
end

-- [x] keymap ,e
vim.keymap.set('n', ',e', run, { noremap = true })

_G.G = {}

-- configure runtimepath
vim.opt.packpath = { vim.fn.stdpath 'data' .. '/site' }

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- skip vim plugins
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_fzf = 1
vim.g.loaded_zipPlugin = 1

-- disable python2
vim.g.python_host_skip_check = 1
vim.g.loaded_python_provider = 0

-- disable perl
vim.g.perl_host_skip_check = 1
vim.g.loaded_perl_provider = 0

-- python3
vim.g.python3_host_skip_check = 1
if vim.fn.executable 'python3' then
  vim.g.python3_host_prog = vim.fn.exepath 'python3'
else
  vim.g.loaded_python3_provider = 0
end

-- node
if vim.fn.executable 'neovim-node-host' then
  if vim.fn.executable 'volta' then
    vim.g.node_host_prog =
      vim.fn.trim(vim.fn.system 'volta which neovim-node-host')
  else
    vim.g.node_host_prog = vim.fn.exepath 'neovim-node-host'
  end
else
  vim.g.loaded_node_provider = 0
end

-- ruby
if vim.fn.executable 'neovim-ruby-host' then
  vim.g.ruby_host_prog = vim.fn.exepath 'neovim-ruby-host'
else
  vim.g.loaded_ruby_provider = 0
end

local utils = require 'ma.utils'

utils.bootstrap()

local function user_highlights()
  local opts = { guibg = nil }

  G.hl('Normal', opts)
  G.hl('NormalNC', opts)
  G.hl('NormalSB', opts)
  G.hl('NormalFloat', opts)
  G.hl('SignColumn', opts)
  G.hl('LineNr', opts)
  G.hl('LspReferenceText', opts)
  G.hl('LspReferenceRead', opts)
  G.hl('LspReferenceWrite', opts)
  G.hl('VertSplit', opts)
  G.hl('FloatBorder', opts)
end

G.augroup('UserHighlights', {
  {
    events = 'ColorScheme',
    targets = '*',
    command = user_highlights,
  },
})

require 'ma.settings'
require 'ma.mappings'
require 'ma.statusline'
require 'ma.plugins'

G.nnoremap(',e', function()
  local api = vim.api
  local fn = vim.fn
  local tmp_name = 'gql_results'
  local existing_bufnr = fn.bufnr(tmp_name)
  local result_bufnr = existing_bufnr ~= -1 and existing_bufnr
    or api.nvim_create_buf(false, 'nomodeline')

  if existing_bufnr == -1 then
    api.nvim_buf_set_name(result_bufnr, tmp_name)
  end

  api.nvim_buf_set_option(result_bufnr, 'modifiable', true)
  api.nvim_buf_set_option(result_bufnr, 'buftype', 'nofile')
  api.nvim_buf_set_option(result_bufnr, 'ft', 'httpResult')

  local filename = api.nvim_buf_get_name(0)
  local body = fn.system(
    string.format(
      [[jq -Mcn --arg query "$(cat %s)" '{"query":$query}']],
      filename
    )
  )

  local url = fn.system [[cat .graphqlrc.json | jq -Mcr ".schema" | tr -d "\n"]]

  local uv = vim.loop
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local result = ''
  local handle = nil

  handle = uv.spawn(
    'curl',
    {
      args = { url, '-K', '.curlrc', '-d', body },
      stdio = { nil, stdout, stderr },
    },
    vim.schedule_wrap(function()
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      handle:close()
      api.nvim_buf_set_lines(result_bufnr, 0, -1, false, {})

      local headers = nil
      local json = nil
      local data = fn.split(result, '\r\n\r\n')
      if #data > 1 then
        headers = vim.fn.split(data[1], '\r\n')
        json = data[2]
      else
        json = data[1]
      end

      local encoded_json = vim.fn.json_encode(json)
      json = vim.split(
        vim.fn.system(string.format([[printf '%%s' %s | jq -M "."]], encoded_json)),
        '\n'
      )

      if headers then
        api.nvim_buf_set_lines(result_bufnr, 0, #headers, false, headers)
      end

      if json then
        local line_count = vim.api.nvim_buf_line_count(result_bufnr) - 1
        api.nvim_buf_set_lines(
          result_bufnr,
          line_count,
          line_count + #json,
          false,
          json
        )
      end

      if vim.fn.bufwinnr(result_bufnr) == -1 then
        vim.cmd([[vert sb]] .. result_bufnr)
        api.nvim_buf_set_option(result_bufnr, 'modifiable', false)
      end

      api.nvim_buf_call(result_bufnr, function()
        fn.cursor(1, 1)
      end)
    end)
  )

  local function on_read(err, data)
    if not data then
      return
    end

    result = result .. data
  end

  -- uv.read_start''stderr, on_read_headers)
  uv.read_start(stdout, on_read)
end)

-- Load .nvimrc manually
local local_vimrc = vim.fn.getcwd() .. '/.nvimrc.lua'
if vim.loop.fs_stat(local_vimrc) then
  local source = vim.secure.read(local_vimrc)
  if not source then
    return
  end

  vim.cmd(string.format('so %s', local_vimrc))
end

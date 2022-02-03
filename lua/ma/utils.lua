local fmt = string.format
local fn = vim.fn
local empty = fn.empty
local filter = fn.filter
local getwininfo = fn.getwininfo
local tbl_extend = vim.tbl_extend
local uv = vim.loop

local M = {}

M._store = {}

M._create = function(f)
  table.insert(M._store, f)
  return #M._store
end

M._execute = function(id)
  return M._store[id]()
end

function M.P(...)
  print(vim.inspect(...))

  return ...
end

local function has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

local function tbl_filter(func, t)
  vim.validate { func = { func, 'c' }, t = { t, 't' } }

  local out = {}
  for key, value in next, t do
    if func(value, key) then
      out[key] = value
    end
  end

  return out
end

local function is_map_args(value, key)
  if type(value) ~= 'boolean' then
    return false
  end
  local valid_args = {
    'buffer',
    'nowait',
    'silent',
    'script',
    'expr',
    'unique',
  }
  return has_value(valid_args, key)
end

function M.map(mode, default_options)
  if not mode then
    return
  end

  return function(lhs, rhs, extra_options)
    if not lhs or not rhs then
      return
    end

    default_options = default_options or {}
    extra_options = extra_options or {}

    local opts = tbl_extend(
      'keep',
      tbl_filter(is_map_args, extra_options),
      default_options
    )

    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

function M.sign_define(name, text)
  vim.fn.sign_define(name, {
    texthl = name,
    text = text,
    numhl = '',
    linehl = '',
  })
end

function M.augroup(name, commands)
  vim.cmd('augroup ' .. name)
  vim.cmd 'autocmd!'
  for _, c in ipairs(commands) do
    local command = c.command
    if type(command) == 'function' then
      local fn_id = M._create(command)
      command = fmt('lua require("ma.utils")._execute(%s)', fn_id)
    end
    vim.cmd(
      fmt(
        'autocmd %s %s %s %s',
        table.concat(c.events, ','),
        table.concat(c.targets or {}, ','),
        table.concat(c.modifiers or {}, ' '),
        command
      )
    )
  end
  vim.cmd 'augroup END'
end

function M.command(name, rhs, user_opts)
  local default_opts = { force = true }
  local opts = vim.tbl_extend('keep', user_opts or {}, default_opts)

  vim.api.nvim_add_user_command(name, rhs, opts)
end

function M.abbrev(mode, lhs, rhs)
  if type(rhs) == 'function' then
    local fn_id = M._create(rhs)
    rhs = fmt('lua require("ma.utils")._execute(%s)', fn_id)
  end

  vim.cmd(fmt('%sabbrev <buffer> %s %s', mode, lhs, rhs))
end

function M.toggle_qf()
  local locations = vim.fn.getqflist()

  -- if no quickfix list then do nothing
  if vim.tbl_isempty(locations) then
    return
  end

  if empty(filter(getwininfo(), 'v:val.quickfix')) == 1 then
    -- open qflist 100% horizontally
    vim.cmd [[botright copen]]
  else
    vim.cmd [[cclose]]
  end
end

M.icons = setmetatable({
  -- Exact Match
  ['gruntfile.coffee'] = '',
  ['gruntfile.js'] = '',
  ['gruntfile.ls'] = '',
  ['gulpfile.coffee'] = '',
  ['gulpfile.js'] = '',
  ['gulpfile.ls'] = '',
  ['mix.lock'] = '',
  ['dropbox'] = '',
  ['.ds_store'] = '',
  ['.gitconfig'] = '',
  ['.gitignore'] = '',
  ['.gitlab-ci.yml'] = '',
  ['.bashrc'] = '',
  ['.zshrc'] = '',
  ['.vimrc'] = '',
  ['.gvimrc'] = '',
  ['_vimrc'] = '',
  ['_gvimrc'] = '',
  ['.bashprofile'] = '',
  ['favicon.ico'] = '',
  ['license'] = '',
  ['node_modules'] = '',
  ['react.jsx'] = '',
  ['procfile'] = '',
  ['dockerfile'] = '',
  ['docker-compose.yml'] = '',
  -- Extension
  ['styl'] = '',
  ['sass'] = '',
  ['scss'] = '',
  ['htm'] = '',
  ['html'] = '',
  ['slim'] = '',
  ['ejs'] = '',
  ['css'] = '',
  ['less'] = '',
  ['md'] = '',
  ['mdx'] = '',
  ['markdown'] = '',
  ['rmd'] = '',
  ['json'] = '',
  ['js'] = '',
  ['mjs'] = '',
  ['jsx'] = '',
  ['rb'] = '',
  ['php'] = '',
  ['py'] = '',
  ['pyc'] = '',
  ['pyo'] = '',
  ['pyd'] = '',
  ['coffee'] = '',
  ['mustache'] = '',
  ['hbs'] = '',
  ['conf'] = '',
  ['ini'] = '',
  ['yml'] = '',
  ['yaml'] = '',
  ['toml'] = '',
  ['bat'] = '',
  ['jpg'] = '',
  ['jpeg'] = '',
  ['bmp'] = '',
  ['png'] = '',
  ['gif'] = '',
  ['ico'] = '',
  ['twig'] = '',
  ['cpp'] = '',
  ['c++'] = '',
  ['cxx'] = '',
  ['cc'] = '',
  ['cp'] = '',
  ['c'] = '',
  ['cs'] = '',
  ['h'] = '',
  ['hh'] = '',
  ['hpp'] = '',
  ['hxx'] = '',
  ['hs'] = '',
  ['lhs'] = '',
  ['lua'] = '',
  ['java'] = '',
  ['sh'] = '',
  ['fish'] = '',
  ['bash'] = '',
  ['zsh'] = '',
  ['ksh'] = '',
  ['csh'] = '',
  ['awk'] = '',
  ['ps1'] = '',
  ['ml'] = 'λ',
  ['mli'] = 'λ',
  ['diff'] = '',
  ['db'] = '',
  ['sql'] = '',
  ['dump'] = '',
  ['clj'] = '',
  ['cljc'] = '',
  ['cljs'] = '',
  ['edn'] = '',
  ['scala'] = '',
  ['go'] = '',
  ['dart'] = '',
  ['xul'] = '',
  ['sln'] = '',
  ['suo'] = '',
  ['pl'] = '',
  ['pm'] = '',
  ['t'] = '',
  ['rss'] = '',
  ['f#'] = '',
  ['fsscript'] = '',
  ['fsx'] = '',
  ['fs'] = '',
  ['fsi'] = '',
  ['rs'] = '',
  ['rlib'] = '',
  ['d'] = '',
  ['erl'] = '',
  ['hrl'] = '',
  ['ex'] = '',
  ['exs'] = '',
  ['eex'] = '',
  ['leex'] = '',
  ['vim'] = '',
  ['ai'] = '',
  ['psd'] = '',
  ['psb'] = '',
  ['ts'] = '',
  ['tsx'] = '',
  ['jl'] = '',
  ['pp'] = '',
  ['vue'] = '﵂',
  ['elm'] = '',
  ['swift'] = '',
  ['xcplayground'] = '',
}, {
  __index = function(table, key)
    local ext = key:match '%.(.+)$'

    return ext and table[ext] or ''
  end,
})

function M.run_command(user_cmd, user_opts)
  local cmd = table.concat(
    vim.tbl_map(vim.fn.expand, vim.split(user_cmd, ' ')),
    ' '
  )

  local default_opts = {
    use_stdin = false,
    schedule = true,
    split_lines = true,
    on_exit = function() end,
    on_read = function() end,
  }

  local opts = vim.tbl_extend('keep', user_opts, default_opts)

  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()
  local stdin = opts.use_stdin and uv.new_pipe() or nil
  local stdio = { stdin, stdout, stderr }

  local handle

  local function on_exit(code, signal)
    stdout:read_stop()
    stderr:read_stop()

    stdout:close()
    stderr:close()

    if stdin then
      stdin:shutdown()
    end

    handle:close()

    if type(opts.on_exist) == 'function' then
      opts.on_exit(code, signal)
    end
  end

  local function on_data(error, data)
    assert(not error, error)

    if not data then
      return
    end

    data = vim.tbl_map(vim.trim, vim.split(vim.trim(data), '\n'))

    if type(opts.on_data) == 'function' then
      opts.on_data(data)
    end
  end

  local function on_error(error, data)
    assert(not error, error)

    if not data then
      return
    end

    data = vim.tbl_map(vim.trim, vim.split(vim.trim(data), '\n'))

    if type(opts.on_error) == 'function' then
      opts.on_error(data)
    end
  end

  handle = uv.spawn(vim.o.shell, {
    args = {
      vim.o.shellcmdflag,
      cmd,
    },
    stdio = stdio,
  }, vim.schedule_wrap(on_exit))

  uv.read_start(stdout, vim.schedule_wrap(on_data))
  uv.read_start(stderr, vim.schedule_wrap(on_error))

  return handle, stdin
end

function M.bootstrap()
  local map_opts = { noremap = false, silent = true }
  local noremap_opts = tbl_extend('keep', { noremap = true }, map_opts)

  _G.G = {
    P = M.P,
    icons = M.icons,
    augroup = M.augroup,
    sign_define = M.sign_define,
    command = M.command,
    abbrev = M.abbrev,
    toggle_qf = M.toggle_qf,
    run_command = M.run_command,
    nmap = M.map('n', map_opts),
    imap = M.map('i', map_opts),
    vmap = M.map('v', map_opts),
    tmap = M.map('t', map_opts),
    xmap = M.map('x', map_opts),
    omap = M.map('o', map_opts),
    cmap = M.map('c', tbl_extend('keep', { silent = false }, map_opts)),
    nnoremap = M.map('n', noremap_opts),
    inoremap = M.map('i', noremap_opts),
    vnoremap = M.map('v', noremap_opts),
    tnoremap = M.map('t', noremap_opts),
    xnoremap = M.map('x', noremap_opts),
    onoremap = M.map('o', noremap_opts),
    cnoremap = M.map('c', tbl_extend('keep', { silent = false }, noremap_opts)),
  }
end

return M

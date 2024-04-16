local tbl_extend = vim.tbl_extend

local M = {}

function M.P(...)
  print(vim.inspect(...))

  return ...
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

    local opts = tbl_extend('keep', extra_options, default_options)

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

function M.augroup(name, commands, cfg)
  local clear = true

  if cfg and type(cfg.clear) == 'boolean' then
    clear = cfg.clear
  end

  local group = type(name) == 'number' and name
    or vim.api.nvim_create_augroup(name, { clear = clear })

  for _, c in ipairs(commands) do
    local command = c.command

    if type(command) == 'function' then
      c.command = nil
      c.callback = command
    end

    local events = c.events
    local once = c.once or false

    c['events'] = nil
    c['once'] = nil

    vim.api.nvim_create_autocmd(
      events,
      tbl_extend('keep', { group = group, once = once }, c)
    )
  end
end

function M.command(name, rhs, user_opts)
  local default_opts = { force = true }
  local opts = vim.tbl_extend('keep', user_opts or {}, default_opts)

  vim.api.nvim_create_user_command(name, rhs, opts)
end

function M.toggle_qf()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  local action = qf_winid > 0 and 'cclose' or 'copen'

  vim.cmd('botright ' .. action)
end

function M.hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

--- Returns a function which applies `specs` on args. This function produces an object having
-- the same structure than `specs` by mapping each property to the result of calling its
-- associated function with the supplied arguments
-- @name applySpec
-- @param specs a table
-- @return a function
function M.applySpec(specs)
  return function(...)
    local spec = {}
    for i, f in pairs(specs) do
      spec[i] = f(...)
    end
    return spec
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
  ['react.jsx'] = '󰜈',
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
  ['vue'] = '󰡄',
  ['elm'] = '',
  ['swift'] = '',
  ['xcplayground'] = '',
}, {
  __index = function(table, key)
    local ext = key:match '%.(.+)$'

    return ext and table[ext] or ''
  end,
})

local map_opts = { noremap = false, silent = true }
local noremap_opts = tbl_extend('keep', { noremap = true }, map_opts)

M.nmap = M.map('n', map_opts)
M.imap = M.map('i', map_opts)
M.vmap = M.map('v', map_opts)
M.tmap = M.map('t', map_opts)
M.xmap = M.map('x', map_opts)
M.omap = M.map('o', map_opts)
M.cmap = M.map('c', tbl_extend('keep', { silent = false }, map_opts))
M.nnoremap = M.map('n', noremap_opts)
M.inoremap = M.map('i', noremap_opts)
M.vnoremap = M.map('v', noremap_opts)
M.tnoremap = M.map('t', noremap_opts)
M.xnoremap = M.map('x', noremap_opts)
M.onoremap = M.map('o', noremap_opts)
M.cnoremap = M.map('c', tbl_extend('keep', { silent = false }, noremap_opts))

function M.bootstrap()
  for k, v in pairs(M) do
    G[k] = v
  end
end

M.bootstrap()

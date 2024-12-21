local fn = vim.fn
local fmt = string.format
local uv = vim.uv

--- @class PluginConfig
--- @field name string The plugin name.
--- @field build string|nil A build command to run after installation.

local M = {
  root_dir = fn.stdpath 'data', --[[@as string]]
  plugins_dir = 'site/pack/plugins/opt/',
  plugins = {},
}

--- @param xs string[]
local function git(xs)
  local base = { 'git', '-C', M.root_dir }

  return fn.system(vim.list_extend(base, xs))
end

local function commit(msg)
  git { 'add', '.' }
  git { 'commit', '-m', msg or '[update]' }
end

function M.update_luarc()
  local luarc_path = fn.expand '~/.config/nvim/.luarc.json'
  local plugin_paths = {}

  local base_plugin_dir = '$XDG_DATA_HOME/nvim/' .. M.plugins_dir
  for _, plugin in ipairs(M.plugins) do
    table.insert(plugin_paths, base_plugin_dir .. plugin.plugin .. '/lua')
  end

  local luarc_template = {
    ['$schema'] = 'https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json',
    ['hint.arrayIndex'] = 'Disable',
    ['runtime.version'] = 'LuaJIT',
    diagnostics = { disable = { 'missing-fields' } },
    hint = { setType = true, enable = true },
    telemetry = { enable = false },
    workspace = {
      library = vim.list_extend({ '$VIMRUNTIME/lua', '${3rd}/luv/library' }, plugin_paths),
      checkThirdParty = false,
    },
    ['runtime.path'] = {
      'lua',
      'lua/?.lua',
      'lua/?/init.lua',
      '?.lua',
      '?/init.lua',
      '$XDG_DATA_HOME/nvim/site',
    },
  }

  local json = vim.json.encode(luarc_template)
  fn.writefile({ json }, luarc_path)
  print 'Successfully regenerated and formatted .luarc.json with plugin paths.'
end

local function setup_git_repo()
  fn.system { 'mkdir', '-p', M.plugins_dir }

  if not uv.fs_stat(M.root_dir .. '/.git') then
    print 'Initializing Git repository...'
    git { 'init' }

    local gitignore_path = M.root_dir .. '/.gitignore'
    local gitignore_file = io.open(gitignore_path, 'w')
    if gitignore_file then
      gitignore_file:write '/*\n'
      gitignore_file:write '!/site/\n'
      gitignore_file:write '!/site/**\n'
      gitignore_file:close()
    else
      error 'Failed to create .gitignore file'
    end

    git { 'add', '.gitignore' }
    commit '[init] Initial commit with .gitignore'

    print 'Git repository initialized with .gitignore.'
  end
end

--- Use a plugin by URI or configuration table.
--- @param args string|PluginConfig The plugin URI or a configuration table.
function M.use(args)
  local uri, build

  if type(args) == 'table' then
    uri = args.name
    build = args.build
  end

  local plugin = string.match(type(args) == 'string' and args or uri, '[^/]+$')

  if not plugin then error 'Plugin name is required' end

  local plugin_names = vim.tbl_map(function(p) return p.plugin end, M.plugins)
  if vim.tbl_contains(plugin_names, plugin) then return end

  table.insert(M.plugins, { uri = uri, plugin = plugin, build = build })

  local dir = uv.fs_stat(M.root_dir .. '/' .. M.plugins_dir .. plugin)
  if not dir then return end

  vim.cmd('packadd ' .. plugin)
end

function M.install()
  setup_git_repo()

  print 'Installing packages...'

  for _, pkg in pairs(M.plugins) do
    local plugin, uri = pkg.plugin, pkg.uri
    local dir = uv.fs_stat(M.root_dir .. '/' .. M.plugins_dir .. plugin)

    if not dir then
      print('Installing ' .. uri .. '...')

      local git_uri = 'https://github.com/' .. uri

      local output = git {
        'submodule',
        'add',
        '-f',
        '--depth',
        '1',
        git_uri,
        fmt('./%s%s', M.plugins_dir, plugin),
      }

      commit('[install] ' .. plugin)

      print(output)

      if pkg.build then
        local directory = M.root_dir .. '/' .. M.plugins_dir .. plugin
        vim.cmd('cd ' .. directory)
        vim.fn.system(pkg.build)
      end
    end
  end

  vim.cmd 'helptags ALL'

  M.update_luarc()

  print 'Installing finished.'
end

function M.update()
  print 'Updating packages...'

  local output = git {
    'submodule',
    'update',
    '-f',
    '--remote',
    '--init',
    '--depth',
    '1',
    '--recursive',
  }

  for _, pkg in pairs(M.plugins) do
    if pkg.build then
      local directory = M.root_dir .. '/' .. M.plugins_dir .. pkg.plugin
      vim.cmd('cd ' .. directory)
      vim.fn.system(pkg.build)
    end
  end

  commit()

  print(output)

  print 'Updating finished.'
end

function M.clean()
  local handle = uv.fs_scandir(M.root_dir .. '/' .. M.plugins_dir)

  if not handle then return end

  local function iter() return uv.fs_scandir_next(handle) end

  for name, _ in iter do
    local exist = vim.iter(M.plugins):find(function(pkg) return pkg.plugin == name end)

    if not exist then
      local module_name = M.plugins_dir .. name
      local submodule = fmt('submodule.%s', module_name)
      local plugin_dir = fmt('%s/%s', M.root_dir, module_name)
      local submodule_dir = fmt('%s/.git/modules/%s', M.root_dir, module_name)

      print('Cleaning ' .. name .. ' package...')

      git { 'submodule', 'deinit', '-f', module_name }
      git { 'rm', '-r', '-f', '--cached', module_name }
      git { 'config', '-f', '.gitmodules', '--remove-section', submodule }

      fn.system { 'rm', '-rf', plugin_dir }
      fn.system { 'rm', '-r', submodule_dir }

      package.loaded[name] = nil

      commit('[clean] ' .. name .. ' removed')
      print('Cleaning ' .. name .. ' package done!')
    end
  end

  M.update_luarc()
end

G.command('PkgInstall', M.install)
G.command('PkgClean', M.clean)
G.command('PkgUpdate', M.update)

return M

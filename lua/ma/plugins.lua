local fn = vim.fn
local fmt = string.format
local uv = vim.uv

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

function M.use(uri)
  local plugin = string.match(uri, '[^/]+$')

  table.insert(M.plugins, { uri = uri, plugin = plugin })

  local dir = uv.fs_stat(M.root_dir .. '/' .. M.plugins_dir .. plugin)
  if not dir then
    return
  end

  vim.cmd('packadd ' .. plugin)
end

function M.install()
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
    end
  end

  vim.cmd [[so ~/.config/nvim/lua/ma/plugins.lua]]
  vim.cmd 'helptags ALL'
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

  commit()

  print(output)

  vim.cmd [[so ~/.config/nvim/lua/ma/plugins.lua]]

  print 'Updating finished.'
end

function M.clean()
  local handle = uv.fs_scandir(M.root_dir .. '/' .. M.plugins_dir)

  if not handle then
    return
  end

  local function iter()
    return uv.fs_scandir_next(handle)
  end

  for name, _ in iter do
    local exist = vim.iter(M.plugins):find(function(pkg)
      return pkg.plugin == name
    end)

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

  vim.cmd [[so ~/.config/nvim/lua/ma/plugins.lua]]
end

G.command('PkgInstall', M.install)
G.command('PkgClean', M.clean)
G.command('PkgUpdate', M.update)

function M.setup()
  -- colors
  M.use 'RRethy/nvim-base16'

  -- editor
  M.use 'tpope/vim-surround.git'
  M.use 'tpope/vim-repeat'
  M.use 'tpope/vim-commentary'

  -- lsp
  M.use 'neovim/nvim-lspconfig'
  M.use 'folke/neodev.nvim'
  M.use 'b0o/SchemaStore.nvim'

  -- treesitter
  M.use 'nvim-treesitter/nvim-treesitter'
  M.use 'JoosepAlviste/nvim-ts-context-commentstring'
  M.use 'windwp/nvim-ts-autotag'
  M.use 'nvim-treesitter/nvim-treesitter-textobjects'
end

M.setup()

return M

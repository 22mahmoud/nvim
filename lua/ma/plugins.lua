local M = {}
M.plugins = {}

M.plugins_dir = 'site/pack/plugins/opt/'
M.root_dir = vim.fn.stdpath 'data'

function M.packadd(uri)
  local plugin = string.match(uri, '[^/]+$')

  table.insert(M.plugins, {
    uri = uri,
    plugin = plugin,
  })

  local dir = vim.loop.fs_stat(M.root_dir .. '/' .. M.plugins_dir .. plugin)
  if not dir then
    return
  end

  vim.cmd('packadd ' .. plugin)
end

function M.install()
  print 'Installing packages...'

  for _, pkg in pairs(M.plugins) do
    local plugin, uri = pkg.plugin, pkg.uri
    local dir = vim.loop.fs_stat(M.root_dir .. '/' .. M.plugins_dir .. plugin)

    if not dir then
      print('Installing ' .. uri .. '...')

      local git_uri = 'https://github.com/' .. uri

      local output = vim.fn.system {
        'git',
        '-C',
        M.root_dir,
        'submodule',
        'add',
        '--depth',
        1,
        git_uri,
        string.format('./%s%s', M.plugins_dir, plugin),
      }

      print(output)
    end
  end

  vim.fn.system {
    'git',
    '-C',
    M.root_dir,
    'submodule',
    'update',
    '--init',
    '--depth',
    1,
    '--recursive',
  }

  vim.cmd [[so ~/.config/nvim/lua/ma/plugins.lua]]

  vim.cmd 'helptags ALL'

  print 'Installing finished.'
end

function M.update()
  print 'Updating packages...'

  local output = vim.fn.system {
    'git',
    '-C',
    M.root_dir,
    'submodule',
    'update',
    '--remote',
    '--init',
    '--depth',
    1,
    '--recursive',
  }

  print(output)

  vim.cmd [[so ~/.config/nvim/lua/ma/plugins.lua]]

  print 'Updating finished.'
end

function M.clean()
  local handle = vim.loop.fs_scandir(M.root_dir .. '/' .. M.plugins_dir)
  local function iter()
    return vim.loop.fs_scandir_next(handle)
  end

  for name, _ in iter do
    local exist = G.any(function(pkg)
      return pkg.plugin == name
    end, M.plugins)

    if not exist then
      local module_name = M.plugins_dir .. name
      print('Cleaning ' .. name .. ' package...')

      vim.fn.system {
        'git',
        '-C',
        M.root_dir,
        'submodule',
        'deinit',
        '-f',
        module_name,
      }

      vim.fn.system {
        'git',
        '-C',
        M.root_dir,
        'rm',
        '--cached',
        module_name,
      }

      vim.fn.system {
        'git',
        '-C',
        M.root_dir,
        'config',
        '-f',
        '.gitmodules',
        '--remove-section',
        string.format('submodule.%s', module_name),
      }

      vim.fn.system {
        'rm',
        '-rf',
        string.format('%s/%s', M.root_dir, module_name),
      }

      vim.fn.system {
        'rm',
        '-r',
        string.format('%s/.git/modules/%s', M.root_dir, module_name),
      }

      package.loaded[name] = nil

      print('Cleaning ' .. name .. ' package done!')
    end
  end

  vim.cmd [[so ~/.config/nvim/lua/ma/plugins.lua]]
end

function M.setup()
  M.packadd 'RRethy/nvim-base16'
  M.packadd 'nvim-treesitter/nvim-treesitter'
  M.packadd 'neovim/nvim-lspconfig'
  M.packadd 'github/copilot.vim'
end

M.setup()

G.command {
  'PkgInstall',
  M.install,
}

G.command {
  'PkgClean',
  M.clean,
}

G.command {
  'PkgUpdate',
  M.update,
}

return M

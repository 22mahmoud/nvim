local cmd = vim.api.nvim_create_user_command

--- @param path string
local function gh(path) return ('https://github.com/%s'):format(path) end

--- @type (string|vim.pack.Spec)[]
local plugins = {
  -- colors/ui
  gh 'RRethy/nvim-base16',
  gh 'nvim-mini/mini.icons',

  -- editor,
  gh 'nvim-mini/mini.surround',
  gh 'stevearc/oil.nvim',

  -- treesitter
  gh 'nvim-treesitter/nvim-treesitter',
  gh 'nvim-treesitter/nvim-treesitter-textobjects',
}

vim.pack.add(plugins)

cmd('PkgUpdate', function() vim.pack.update(nil, { target = 'lockfile' }) end, {})
cmd('PkgClean', function()
  vim.pack.del(
    vim
      .iter(vim.pack.get())
      :filter(function(x) return not x.active end)
      :map(function(x) return x.spec.name end)
      :totable()
  )
end, {})

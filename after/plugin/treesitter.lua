local loaded, treesitter = pcall(require, 'nvim-treesitter')
if not loaded then return end

vim.treesitter.language.register('bash', 'dotenv')

treesitter.setup {
  install_dir = vim.fn.stdpath 'data' .. '/site',
}

local languages = {
  'bash',
  'c',
  'diff',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'jsonc',
  'lua',
  'luadoc',
  'luap',
  'markdown',
  'markdown_inline',
  'printf',
  'python',
  'query',
  'regex',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

treesitter.install(languages)

vim.api.nvim_create_autocmd('FileType', {
  pattern = languages,
  callback = function()
    vim.treesitter.start()

    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

local loaded_textobjects, textobjects = pcall(require, 'nvim-treesitter-textobjects')
if loaded_textobjects then
  local select = require 'nvim-treesitter-textobjects.select'
  local keymap = function(rhs, lhs) vim.keymap.set({ 'x', 'o' }, rhs, lhs) end

  textobjects.setup {}

  keymap('af', function() select.select_textobject('@function.outer', 'textobjects') end)
  keymap('if', function() select.select_textobject('@function.inner', 'textobjects') end)
  keymap('ac', function() select.select_textobject('@class.outer', 'textobjects') end)
  keymap('ic', function() select.select_textobject('@class.inner', 'textobjects') end)
end

local loaded_ts_autotag, autotag = pcall(require, 'nvim-ts-autotag')
if loaded_ts_autotag then
  autotag.setup {
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  }
end

-- TODO: implment ts-context-commentstring

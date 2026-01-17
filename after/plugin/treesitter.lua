local loaded, ts = pcall(require, 'nvim-treesitter')
if not loaded then return end

vim.treesitter.language.register('bash', 'dotenv')

ts.setup {
  install_dir = vim.fn.stdpath 'data' .. '/site',
}

ts.install { 'stable', 'unstable' }

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ma_treesitter', { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local filetype = event.match

    local parser_name = vim.treesitter.language.get_lang(filetype)
    if not parser_name then return end

    local parser_exists = pcall(vim.treesitter.get_parser, bufnr, parser_name)
    if not parser_exists then return end

    vim.treesitter.start(bufnr, parser_name)
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

local loaded_ts_commentstring, ts_commentstring = pcall(require, 'ts_context_commentstring')
if loaded_ts_commentstring then
  ts_commentstring.setup { enable_autocmd = false }

  local get_option = vim.filetype.get_option

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.filetype.get_option = function(filetype, option)
    print 'hey'
    return option == 'commentstring'
        and require('ts_context_commentstring.internal').calculate_commentstring()
      or get_option(filetype, option)
  end
end

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

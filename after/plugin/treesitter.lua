---@diagnostic disable: missing-fields
local loaded, treesitter = pcall(require, 'nvim-treesitter.configs')

if not loaded then return end

local loaded_ts_autotag = pcall(require, 'nvim-ts-autotag')

if loaded_ts_autotag then
  require('nvim-ts-autotag').setup {
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  }
end

local loaded_ts_context_commentstring = pcall(require, 'ts_context_commentstring')

if loaded_ts_context_commentstring then
  require('ts_context_commentstring').setup {
    enable_autocmd = false,
  }

  local get_option = vim.filetype.get_option

  vim.filetype.get_option = function(filetype, option)
    return option == 'commentstring'
        and require('ts_context_commentstring.internal').calculate_commentstring()
      or get_option(filetype, option)
  end
end

treesitter.setup {
  ensure_installed = 'all',
  auto_install = true,
  sync_install = false,
  highlight = {
    enable = true,
    disable = { 'dockerfile' },
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      scope_incremental = '<TAB>',
      node_decremental = '<BS>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
        [']a'] = '@parameter.inner',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
        [']A'] = '@parameter.inner',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
        ['[a'] = '@parameter.inner',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
        ['[A'] = '@parameter.inner',
      },
    },
  },
}

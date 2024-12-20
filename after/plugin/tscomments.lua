local loaded = pcall(require, 'ts_context_commentstring')

if not loaded then return end

require('ts_context_commentstring').setup {
  enable_autocmd = false,
}

local get_option = vim.filetype.get_option

vim.filetype.get_option = function(filetype, option)
  return option == 'commentstring'
      and require('ts_context_commentstring.internal').calculate_commentstring()
    or get_option(filetype, option)
end

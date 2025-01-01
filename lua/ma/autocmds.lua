local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd({ 'TextYankPost' }, {
  group = augroup('HighlightYank', {}),
  callback = function() vim.highlight.on_yank() end,
})

autocmd({ 'BufWritePre' }, {
  group = augroup('TrimWhiteSpace', {}),
  -- Remove the white space and restore the cursor position
  -- @see https://github.com/mcauley-penney/tidy.nvim/blob/main/lua/tidy/init.lua
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)

    vim.cmd [[:keepjumps keeppatterns %s/\s\+$//e]]
    vim.cmd [[:keepjumps keeppatterns silent! 0;/^\%(\n*.\)\@!/,$d_]]

    local num_rows = vim.api.nvim_buf_line_count(0)
    if pos[1] > num_rows then pos[1] = num_rows end
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

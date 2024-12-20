G.augroup('HighlightYank', {
  {
    events = { 'TextYankPost' },
    command = function() vim.highlight.on_yank() end,
  },
})

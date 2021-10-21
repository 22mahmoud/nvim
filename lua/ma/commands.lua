G.command {
  'Term',
  function()
    vim.cmd 'new'
    vim.cmd 'term'
    vim.cmd 'startinsert'
  end,
}

G.command {
  'Vterm',
  function()
    vim.cmd 'vnew'
    vim.cmd 'term'
    vim.cmd 'startinsert'
  end,
}

G.command {
  'Tterm',
  function()
    vim.cmd 'tabnew'
    vim.cmd 'term'
    vim.cmd 'startinsert'
  end,
}

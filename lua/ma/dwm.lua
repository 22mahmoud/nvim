local M = {}

function M.new()
  M.stack()
  vim.cmd 'vert topleft new'
  M.resize()
end

function M.stack()
  vim.cmd '1wincmd w'
  vim.cmd 'wincmd K'
end

function M.resize()
  vim.cmd 'wincmd ='
end

function M.focus()
  if vim.fn.winnr '$' == 1 then
    return
  end

  local current_win = vim.fn.winnr()

  M.stack()

  vim.cmd(
    string.format('%swincmd w', current_win + (current_win == 1 and 1 or 0))
  )
  vim.cmd 'wincmd H'
  M.resize()
end

function M.grow_master()
  if vim.fn.winnr() == 1 then
    vim.cmd 'vert resize +1'
  else
    vim.cmd 'vert resize -1'
  end
end

function M.shrink_master()
  if vim.fn.winnr() == 1 then
    vim.cmd 'vert resize -1'
  else
    vim.cmd 'vert resize +1'
  end
end

function M.close()
  if vim.fn.winnr() == 1 then
    vim.cmd 'close'
    vim.cmd 'wincmd H'
    M.resize()
  else
    vim.cmd 'close'
  end
end

function M.on_entr()
  if vim.fn.winnr '$' == 1 then
    return
  end

  local ft = vim.opt_local.filetype:get()
  local buft = vim.opt_local.buftype:get()

  if (ft == '' and not buft == 'terminal') or buft == 'quickfix' then
    return
  end

  vim.cmd 'wincmd K'

  M.focus()
  M.focus()
end

function M.setup()
  G.nmap('<c-j>', '<c-w>w')
  G.nmap('<c-k>', '<c-w>w')
  G.nmap('<c-l>', M.grow_master)
  G.nmap('<c-h>', M.shrink_master)
  G.nmap('<c-n>', M.new)
  G.nmap('<c-z>', M.focus)
  G.nmap('<c-q>', M.close)

  G.augroup('DWM', {
    {
      events = { 'BufWinEnter' },
      targets = { '*' },
      command = M.on_entr,
    },
  })
end

M.setup()

return M

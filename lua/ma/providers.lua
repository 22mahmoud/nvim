-- disable python2
vim.g.python_host_skip_check = 1
vim.g.loaded_python_provider = 0

-- disable perl
vim.g.perl_host_skip_check = 1
vim.g.loaded_perl_provider = 0

-- python3
vim.g.python3_host_skip_check = 1
if vim.fn.executable 'python3' then
  vim.g.python3_host_prog = vim.fn.exepath 'python3'
else
  vim.g.loaded_python3_provider = 0
end

-- node
if vim.fn.executable 'neovim-node-host' then
  if vim.fn.executable 'volta' then
    vim.g.node_host_prog = vim.fn.trim(vim.fn.system 'volta which neovim-node-host')
  else
    vim.g.node_host_prog = vim.fn.exepath 'neovim-node-host'
  end
else
  vim.g.loaded_node_provider = 0
end

-- ruby
if vim.fn.executable 'neovim-ruby-host' then
  vim.g.ruby_host_prog = vim.fn.exepath 'neovim-ruby-host'
else
  vim.g.loaded_ruby_provider = 0
end

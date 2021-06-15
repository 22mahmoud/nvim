local fn = vim.fn
local executable = fn.executable
local exepath = fn.exepath
local trim = fn.trim
local system = fn.system

-- disable python2
vim.g.python_host_skip_check = 1
vim.g.loaded_python_provider = 0

-- disable perl
vim.g.perl_host_skip_check = 1
vim.g.loaded_perl_provider = 0

-- python3
vim.g.python3_host_skip_check = 1
if executable("python3") then
  vim.g.python3_host_prog = exepath("python3")
else
  vim.g.loaded_python3_provider = 0
end

-- node
if executable("neovim-node-host") then
  if executable("volta") then
    vim.g.node_host_prog = trim(system("volta which neovim-node-host"))
  else
    vim.g.node_host_prog = exepath("neovim-node-host")
  end
else
  vim.g.loaded_node_provider = 0
end

-- ruby
if executable("neovim-ruby-host") then
  vim.g.ruby_host_prog = exepath("neovim-ruby-host")
else
  vim.g.loaded_ruby_provider = 0
end

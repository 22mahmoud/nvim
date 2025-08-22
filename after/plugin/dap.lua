local loaded_dap, dap = pcall(require, 'dap')
if not loaded_dap then return end

local widgets = require 'dap.ui.widgets'

-- mappings
vim.keymap.set('n', '<leader>dc', dap.continue)
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
vim.keymap.set(
  'n',
  '<leader>dB',
  function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end
)
vim.keymap.set('n', '<leader>dr', dap.repl.open)
vim.keymap.set('n', '<leader>dl', dap.run_last)

vim.keymap.set('n', '<leader>dv', dap.step_over)
vim.keymap.set('n', '<leader>di', dap.step_into)
vim.keymap.set('n', '<leader>do', dap.step_out)
vim.keymap.set({ 'n', 'v' }, '<leader>dw', widgets.preview)

-- adapters
local loaded_dap_python, dap_python = pcall(require, 'dap-python')
if not loaded_dap_python then return end

dap_python.setup()

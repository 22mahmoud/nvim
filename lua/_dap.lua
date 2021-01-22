local dap = require("dap")
local map = vim.api.nvim_set_keymap

vim.g.dap_virtual_text = true

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = {os.getenv("HOME") .. "/repos/vscode-node-debug2/out/src/nodeDebug.js"}
}

dap.configurations.javascript = {
  {
    type = "node2",
    request = "launch",
    program = "${workspaceFolder}/${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal"
  }
}

dap.configurations.javascriptreact = {
  {
    type = "node2",
    request = "launch",
    -- program = "${workspaceFolder}/${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal"
  }
}

dap.configurations.typescript = {
  {
    type = "node2",
    request = "launch",
    program = "${workspaceFolder}/${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal"
  }
}

local opts = {
  noremap = true,
  silent = true
}

map("n", "<F5>", [[:lua require('dap').continue()<CR>]], opts)
map("n", "<F10>", [[:lua require('dap').step_over()<CR>]], opts)
map("n", "<F11>", [[:lua require('dap').step_into()<CR>]], opts)
map("n", "<F12>", [[:lua require('dap').step_out()<CR>]], opts)
map("n", "<leader>tb", [[:lua require('dap').toggle_breakpoint()<CR>]], opts)
map("n", "<leader>lp", [[:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]], opts)
map("n", "<leader>dr", [[:lua require('dap').repl.open()<CR>]], opts)

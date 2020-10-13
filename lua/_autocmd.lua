local command = vim.api.nvim_command

command(
  "au BufNewFile,BufRead *.svelte setf svelte"
)

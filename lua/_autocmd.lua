local command = vim.api.nvim_command

command("au BufNewFile,BufRead *.svelte setf svelte")
command("command Exec set splitright | vnew | set filetype=sh | read !sh #")

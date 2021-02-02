local map = vim.api.nvim_set_keymap

vim.cmd [[let test#strategy = "neovim"]]

map("n", "<leader>tf", ":TestFile<CR>", {noremap = true, silent = true})
map("n", "<leader>tt", ":TestNearest<CR>", {noremap = true, silent = true})
map("n", "<leader>ts", ":TestSuit<CR>", {noremap = true, silent = true})
map("n", "<leader>tl", ":TestLast<CR>", {noremap = true, silent = true})

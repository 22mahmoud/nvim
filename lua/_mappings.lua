local map = vim.api.nvim_set_keymap

-- better movement between windows
map("n", "<C-h>", "<C-w><C-h>", {noremap = true})
map("n", "<C-j>", "<C-w><C-j>", {noremap = true})
map("n", "<C-k>", "<C-w><C-k>", {noremap = true})
map("n", "<C-l>", "<C-w><C-l>", {noremap = true})

-- better yank behaviour
map("n", "Y", "y$", {noremap = true})

-- remove annoying exmode
map("n", "Q", "<Nop>", {noremap = true})
map("n", "q:", "<Nop>", {noremap = true})

-- better indenting experience
map("v", "<", "<gv", {noremap = true})
map("v", ">", ">gv", {noremap = true})

-- better command mode navigation
map("c", "<C-b>", "<Left>", {noremap = true})
map("c", "<C-f>", "<Right>", {noremap = true})
map("c", "<C-n>", "<Down>", {noremap = true})
map("c", "<C-p>", "<Up>", {noremap = true})
map("c", "<C-e>", "<End>", {noremap = true})
map("c", "<C-a>", "<Home>", {noremap = true})
map("c", "<C-d>", "<Del>", {noremap = true})
map("c", "<C-h>", "<BS>", {noremap = true})

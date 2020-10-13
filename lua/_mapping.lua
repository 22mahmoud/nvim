local map = require("utils").map

-- Better indenting
map("v", "<", "<gv", {})
map("v", ">", ">gv", {})

-- clear all the highlighted text from the previous search
map("n", "<Leader><Space>", ":noh<CR>", {silent = true})

-- Easier Moving between splits
map("n", "<C-J>", "<C-W><C-J>", {})
map("n", "<C-K>", "<C-W><C-K>", {})
map("n", "<C-L>", "<C-W><C-L>", {})
map("n", "<C-H>", "<C-W><C-H>", {})

-- Sizing window
map("n", "<A-,>", "<C-W>5<", {})
map("n", "<A-.>", "<C-W>5>", {})
map("n", "<A-t>", "<C-W>+", {})
map("n", "<A-s>", "<C-W>-", {})

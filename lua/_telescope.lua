local actions = require("telescope.actions")
local utils = require("utils")

local mappings = {
  -- horizontal split
  ["<C-x>"] = false,
  ["<C-s>"] = actions.goto_file_selection_split,
  -- next | prev
  ["j"] = false,
  ["k"] = false,
  ["<C-j>"] = actions.move_selection_next,
  ["<C-k>"] = actions.move_selection_previous
}

require("telescope").setup {
  defaults = {
    winblend = 0,
    layout_strategy = "horizontal",
    preview_cutoff = 120,
    sorting_strategy = "descending",
    prompt_position = "bottom",
    borderchars = {
      {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
      preview = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"}
    },
    mappings = {
      i = mappings,
      n = mappings
    }
  }
}

utils.map("n", "<Leader>p", [[<cmd>lua require'telescope.builtin'.git_files{}<CR>]], {})

utils.map("n", "<Leader>f", [[<cmd>lua require'telescope.builtin'.grep_string{}<CR>]], {})

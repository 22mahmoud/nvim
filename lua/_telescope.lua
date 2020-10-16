local actions = require("telescope.actions")
local utils = require("utils")

local tele = {}

local list_theme =
  require("telescope.themes").get_dropdown(
  {
    width = 0.6,
    prompt = "",
    results_height = 20,
    previewer = false
  }
)

local full_theme = {
  winblend = 10,
  preview_cutoff = 50,
  width = 0.5,
  show_line = false,
  results_title = "",
  preview_title = "",
  prompt = ""
}

local mappings = {
  -- horizontal split
  ["<C-x>"] = false,
  ["<C-s>"] = actions.goto_file_selection_split,
  -- next | prev
  ["j"] = false,
  ["k"] = false,
  ["<C-j>"] = actions.move_selection_next,
  ["<C-k>"] = actions.move_selection_previous,
  -- use esc for exit no normal mode
  ["<esc>"] = actions.close
}

require("telescope").setup {
  defaults = {
    prompt_position = "top",
    sorting_strategy = "ascending",
    mappings = {
      i = mappings,
      n = mappings
    }
  }
}

-- Current working directory files
function tele.fd()
  local opts = vim.deepcopy(list_theme)
  opts.prompt_prefix = "Files>"
  require "telescope.builtin".fd(opts)
end

-- live grep
function tele.live_grep()
  local opts = vim.deepcopy(full_theme)
  opts.prompt_prefix = 'RG>'
  require'telescope.builtin'.live_grep(opts)
end

-- live grep
function tele.grep_string()
  local opts = vim.deepcopy(full_theme)
  opts.prompt_prefix = 'RG>'
  require'telescope.builtin'.grep_string(opts)
end

utils.map("n", "<Leader>p", [[<cmd>lua require'_telescope'.fd{}<CR>]], {})

utils.map(
  "n",
  "<Leader>f",
  [[<cmd>lua require'_telescope'.grep_string{}<CR>]],
  {}
)

return tele

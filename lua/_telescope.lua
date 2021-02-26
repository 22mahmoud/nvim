local telescope = require("telescope")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")

local map = vim.api.nvim_set_keymap
local mapper = function(mode, key, result)
  map(
    mode,
    key,
    "<cmd>lua " .. result .. "<cr>",
    {noremap = true, silent = true}
  )
end

telescope.setup {
  defaults = {
    file_sorter = sorters.get_fzy_sorter,
    mappings = {
      i = {
        ["<C-x>"] = false,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<tab>"] = actions.toggle_selection
      }
    }
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true
    },
    fzf_writer = {
      use_highlighter = false,
      minimum_grep_characters = 4
    }
  }
}

telescope.load_extension("fzy_native")
telescope.load_extension('dap')

mapper(
  "n",
  "z=",
  "require('telescope.builtin').spell_suggest(require('telescope.themes').get_dropdown({previewer = false}))"
)
mapper(
  "n",
  "<leader>p",
  "require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({previewer = false}))"
)
mapper(
  "n",
  "<leader>b",
  "require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({previewer = false}))"
)
mapper(
  "n",
  "<leader>gw",
  "require('telescope.builtin').grep_string({short_path = true, word_match = '-w', only_sort_text = true})"
)
mapper(
  "n",
  "<leader>rg",
  "require('telescope.builtin').grep_string({shorten_path = true, search = vim.fn.input('Grep String > ')})"
)

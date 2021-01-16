local map = vim.api.nvim_set_keymap
local telescope = require("telescope")
local actions = require("telescope.actions")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")

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

telescope.setup {
  defaults = {
    prompt_prefix = " >",
    winblend = 0,
    preview_cutoff = 120,
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        width_padding = 0.1,
        height_padding = 0.1,
        preview_width = 0.6
      },
      vertical = {
        width_padding = 0.05,
        height_padding = 1,
        preview_height = 0.5
      }
    },
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    prompt_position = "top",
    color_devicons = true,
    borderchars = {
      {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
      preview = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"}
    },
    file_sorter = sorters.get_fzy_sorter,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    mappings = {
      i = mappings,
      n = mappings
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

local M = {}

--  ["n|<Leader>bb"]     = map_cu('Telescope buffers'):with_noremap():with_silent(),
--  ["n|<Leader>fa"]     = map_cu('DashboardFindWord'):with_noremap():with_silent(),
--  ["n|<Leader>fb"]     = map_cu('DashboardJumpMark'):with_noremap():with_silent(),
--  ["n|<Leader>ff"]     = map_cu('DashboardFindFile'):with_noremap():with_silent(),
--  ["n|<Leader>fg"]     = map_cu('Telescope git_files'):with_noremap():with_silent(),
--  ["n|<Leader>fw"]     = map_cu('Telescope grep_string'):with_noremap():with_silent(),
--  ["n|<Leader>fh"]     = map_cu('DashboardFindHistory'):with_noremap():with_silent(),
--  ["n|<Leader>fl"]     = map_cu('Telescope loclist'):with_noremap():with_silent(),
--  ["n|<Leader>fc"]     = map_cu('Telescope git_commits'):with_noremap():with_silent(),
--  ["n|<Leader>fd"]     = map_cu('Telescope dotfiles path='..os.getenv("HOME")..'/.dotfiles'):with_noremap():with_silent(),
--  ["n|<Leader>fs"]     = map_cu('Telescope gosource'):with_noremap():with_silent(),

function M.fd()
  local opts =
    themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false
  }

  require "telescope.builtin".fd(opts)
end

function M.lsp_code_actions()
  local opts =
    themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false
  }

  require("telescope.builtin").lsp_code_actions(opts)
end

function M.lsp_references()
  local opts =
    themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false
  }

  require("telescope.builtin").lsp_references(opts)
end

function M.live_grep()
  require("telescope").extensions.fzf_writer.staged_grep {
    shorten_path = true,
    previewer = false,
    fzf_separator = "|>"
  }
end

function M.grep_prompt()
  require("telescope.builtin").grep_string {
    shorten_path = true,
    search = vim.fn.input("Grep String > "),
    previewer = false
  }
end

map("n", "<leader>p", [[<cmd>lua require'_telescope'.fd{}<CR>]], {noremap = true, silent = true})
map("n", "<Leader>f", [[<cmd>lua require'_telescope'.live_grep{}<CR>]], {noremap = true, silent = true})
map("n", "<Leader>gp", [[<cmd>lua require'_telescope'.grep_prompt{}<CR>]], {noremap = true, silent = true})

return M

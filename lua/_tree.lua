local map = vim.fn.nvim_set_keymap

local g = vim.g

local function get_lua_cb(cb_name)
  return string.format(":lua require'nvim-tree'.on_keypress('%s')<CR>", cb_name)
end

g.nvim_tree_side = "left"
g.nvim_tree_width = 25
g.nvim_tree_ignore = {".git", "node_modules", ".cache"}
g.nvim_tree_auto_open = 0
g.nvim_tree_auto_close = 1
g.nvim_tree_quit_on_open = 0
g.nvim_tree_follow = 1
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_git_hl = 1
g.nvim_tree_root_folder_modifier = ":~"
g.nvim_tree_tab_open = 1
g.nvim_tree_width_allow_resize = 1
g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1
}

g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "✗",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "★"
  },
  folder = {default = "", open = " "}
}

g.nvim_tree_bindings = {
  ["<C-s>"] = get_lua_cb("split")
}

map("n", "<leader>e", ":NvimTreeToggle<CR>", {noremap = true, silent = true})

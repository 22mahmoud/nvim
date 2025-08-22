local loaded, oil = pcall(require, 'oil')
if not loaded then return end

oil.setup {
  skip_confirm_for_simple_edits = true,
  delete_to_trash = true,
  view_options = {
    show_hidden = true,
    natural_order = true,
    is_always_hidden = function(name, _) return name == '..' or name == '.git' end,
  },
  keymaps = {
    ['q'] = { 'actions.close', mode = 'n' },
    ['?'] = 'actions.preview',
  },
}

vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

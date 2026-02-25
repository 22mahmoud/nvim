local loaded, fzf = pcall(require, 'fzf-lua')
if not loaded then return end

local keymap = vim.keymap.set

fzf.setup {
  winopts = {
    split = 'botright new',
    ---@diagnostic disable-next-line: missing-fields
    preview = {
      vertical = 'down:40%',
      horizontal = 'right:50%',
    },
  },
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
}

keymap('n', '<leader>ff', fzf.files)
keymap('n', '<leader>fb', fzf.buffers)
keymap('n', '<leader>fz', fzf.builtin)
keymap('n', 'z=', fzf.spell_suggest)

fzf.register_ui_select {}

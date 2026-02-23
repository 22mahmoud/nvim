local loaded, fzf = pcall(require, 'fzf-lua')
if not loaded then return end

local keymap = vim.keymap.set

fzf.setup {
  winopts = {
    split = 'belowright new',
  },
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
}

keymap('n', '<leader>ff', fzf.files)
keymap('n', '<leader>rg', fzf.live_grep)
keymap('n', '<leader>gw', fzf.grep_cword)

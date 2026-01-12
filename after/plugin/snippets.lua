local loaded, mini_snippets = pcall(require, 'mini.snippets')
if not loaded then return end

local gen_loader = require('mini.snippets').gen_loader

mini_snippets.setup {
  snippets = {
    gen_loader.from_lang(),
  },
}

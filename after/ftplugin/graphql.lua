local gql = require 'ma.gql-fetch'

vim.keymap.set('n', ',e', gql.run, { buffer = 0 })

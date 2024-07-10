local loaded = pcall(require, 'ts-comments')

if not loaded then return end

require('ts-comments').setup()

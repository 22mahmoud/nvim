local loaded, surround = pcall(require, 'nvim-surround')
if not loaded then return end

surround.setup {}

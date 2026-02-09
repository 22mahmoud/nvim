local surround_loaded, surround = pcall(require, 'mini.surround')
if surround_loaded then surround.setup() end

local icons_loaded, icons = pcall(require, 'mini.icons')
if icons_loaded then icons.setup() end

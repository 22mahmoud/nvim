local fs = require 'efmls-configs.fs'

local formatter = 'shfmt'
local command = string.format("%s -i 2 -filename '${INPUT}' -", fs.executable(formatter))

---@type EfmLanguage
return {
  formatCommand = command,
  formatStdin = true,
}

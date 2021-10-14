local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

local modes =
  setmetatable(
  {
    ["n"] = {long = "Normal", short = "N"},
    ["v"] = {long = "Visual", short = "V"},
    ["V"] = {long = "V-Line", short = "V-L"},
    [CTRL_V] = {long = "V-Block", short = "V-B"},
    ["s"] = {long = "Select", short = "S"},
    ["S"] = {long = "S-Line", short = "S-L"},
    [CTRL_S] = {long = "S-Block", short = "S-B"},
    ["i"] = {long = "Insert", short = "I"},
    ["R"] = {long = "Replace", short = "R"},
    ["c"] = {long = "Command", short = "C"},
    ["r"] = {long = "Prompt", short = "P"},
    ["!"] = {long = "Shell", short = "Sh"},
    ["t"] = {long = "Terminal", short = "T"}
  },
  {
    __index = function()
      return {long = "Unknown", short = "U"}
    end
  }
)

local function get_mode()
  local mode = modes[vim.fn.mode()]

  return {mode.long, mode.short}
end

return {
  get_mode = get_mode
}

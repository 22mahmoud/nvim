local mode_section = require("ma.statusline.sections.mode")
local file_section = require("ma.statusline.sections.file")
local lsp_section = require("ma.statusline.sections.lsp")

return {
  get_mode = mode_section.get_mode,
  get_path = file_section.get_path,
  get_modified_icon = file_section.get_modified_icon,
  get_readonly_icon = file_section.get_readonly_icon,
  get_file_icon = file_section.get_file_icon,
  get_lsp_diagnostics = lsp_section.get_lsp_diagnostics
}

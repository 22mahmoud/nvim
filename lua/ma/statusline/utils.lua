local fmt = string.format

local function block(value, template)
  if (value == 0 or value == "" or value == nil or not value) then
    return ""
  end

  return fmt((template or "%s") .. " ", value)
end

return {
  block = block
}

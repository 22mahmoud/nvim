local loaded, presence = pcall(require, 'presence')

if not loaded then
  return
end

presence.setup {
  blacklist = { 'lynks', 'okay', 'bawales' },
  buttons = false,
}

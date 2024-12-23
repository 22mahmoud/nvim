local loaded, colorizer = pcall(require, 'colorizer')
if not loaded then return end

colorizer.setup {
  user_default_options = {
    tailwind = true,
  },
}

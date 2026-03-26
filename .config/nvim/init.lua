-- Disable netrw at the very start to prevent E117 errors
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.terminal")
require("config.netrw")

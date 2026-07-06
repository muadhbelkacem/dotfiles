local keymap = vim.keymap
local fzf = require("config.lib.fzf")
local netrw = require("config.lib.netrw")
local terminal = require("config.lib.terminal")

-- Netrw
keymap.set("n", "<leader>e", netrw.toggle)

-- FZF
keymap.set("n", "<leader>p", fzf.files)
keymap.set("n", "<leader>b", fzf.buffers)
keymap.set("n", "<leader>g", fzf.git_files)

-- Terminal
keymap.set({ "n", "t" }, "<leader><Space>", terminal.toggle_terminal)
keymap.set({ "n", "t" }, "<leader>n", terminal.new_terminal)

-- Tabs
keymap.set("n", "<leader>j", ":tabprevious<CR>")
keymap.set("n", "<leader>k", ":tabnext<CR>")
keymap.set("t", "<leader>j", [[<C-\><C-n>:tabprevious<CR>]])
keymap.set("t", "<leader>k", [[<C-\><C-n>:tabnext<CR>]])

-- Terminal escape
keymap.set("t", "<Esc>", [[<C-\><C-n>]])

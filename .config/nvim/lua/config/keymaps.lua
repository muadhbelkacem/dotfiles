-- Disable Space bar since it'll be used as the leader key
vim.keymap.set("n", "<leader>", "<nop>")

-- Redo remap
vim.keymap.set("n", "U", "<C-r>")

-- Save and quit current file quicker
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false })

-- Close currently active buffer
--vim.keymap.set("n", "<C-c>", ":bwipeout<CR>", { silent = false })

-- Map Escape to Ctrl-C in all modes
vim.keymap.set({ "n", "i", "v", "c", "t" }, "<Esc>", "<C-c>")

-- Terminal navigation
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { silent = true })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { silent = true })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { silent = true })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { silent = true })

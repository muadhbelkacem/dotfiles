-- Disable Space bar since it'll be used as the leader key
vim.keymap.set("n", "<leader>", "<nop>")

-- Redo remap
vim.keymap.set("n", "U", "<C-r>")

-- Save and quit current file quicker
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false })

-- Close currently active buffer
--vim.keymap.set("n", "<C-c>", ":bwipeout<CR>", { silent = false })

-- Map Ctrl-E to Escape in all modes
vim.keymap.set({ "n", "i", "v", "c", "t" }, "<C-/>", "<Esc>")

-- Terminal navigation
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { silent = true })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { silent = true })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { silent = true })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { silent = true })

-- LSP Navigation
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover info" })

-- Go back and forward in jump list
vim.keymap.set("n", "gb", "<C-o>", { desc = "Go back" })
vim.keymap.set("n", "gf", "<C-i>", { desc = "Go forward" })

local function custom_on_attach(bufnr)
  local api = require("nvim-tree.api")
  -- set up default mappings first
  api.config.mappings.default_on_attach(bufnr)
  -- then remove the <C-e> mapping in normal mode for this buffer
  vim.keymap.del("n", "<C-e>", { buffer = bufnr })

  -- Remove the default 'e' mapping in the nvim-tree buffer to prevent it from
  -- triggering a rename when you try to use <leader>e to toggle/close the tree.
  vim.keymap.del("n", "e", { buffer = bufnr })

  -- Explicitly map <leader>e to toggle nvim-tree when focus is in the tree
  vim.keymap.set("n", "<leader>e", api.tree.toggle, { buffer = bufnr, noremap = true, silent = true, nowait = true })
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>" },
  },
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      on_attach = custom_on_attach,
    })
  end,
}

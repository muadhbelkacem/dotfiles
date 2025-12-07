local function custom_on_attach(bufnr)
  local api = require("nvim-tree.api")
  -- set up default mappings first
  api.config.mappings.default_on_attach(bufnr)
  -- then remove the <C‑e> mapping in normal mode for this buffer
  vim.keymap.del("n", "<C-e>", { buffer = bufnr })
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  keys = {
    --    { "<leader>e", "<cmd>NvimTreeToggle<cr>" },
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

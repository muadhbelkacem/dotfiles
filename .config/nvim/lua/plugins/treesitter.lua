return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- Use lazy = false to ensure it's installed and available immediately
    lazy = false,
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      -- Use pcall to prevent the error if the plugin isn't fully cloned yet
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup(opts)
      end
    end,
  },
}

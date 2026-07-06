vim.g.mapleader = vim.api.nvim_replace_termcodes("<C-Space>", true, true, true)
vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<C-Space>", true, true, true)

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.virtualedit = "all"
opt.textwidth = 0
opt.formatoptions:remove("t")
opt.wrap = false
opt.sidescrolloff = 9999
opt.scrolloff = 9999
opt.background = "dark"
opt.cursorline = true
opt.splitbelow = true
opt.termguicolors = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

require("colors.dark-colorscheme").setup()

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
vim.g.netrw_browse_split = 4
vim.g.netrw_keepdir = 1

-- Coc
vim.g.coc_global_extensions = {
  "coc-clangd",
  "coc-tsserver",
  "coc-eslint",
  "coc-json",
  "coc-prettier",
  "coc-rust-analyzer",
}

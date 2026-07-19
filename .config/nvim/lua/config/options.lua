require("colors.dark-colorscheme").setup()
vim.g.mapleader = vim.api.nvim_replace_termcodes("<C-Space>", true, true, true)
vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<C-Space>", true, true, true)

-- Netrw
vim.g.netrw_banner = 0

-- Coc
vim.g.coc_global_extensions = {
  "coc-clangd",
  "coc-tsserver",
  "coc-eslint",
  "coc-json",
  "coc-prettier",
  "coc-rust-analyzer",
}

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
opt.mouse = "a"

-- coc.nvim compatibility
opt.backup = false
opt.writebackup = false
opt.autoread = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

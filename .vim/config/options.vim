vim9script

g:mapleader = "\<C-@>"

# Netrw
g:netrw_banner = 0

# coc.nvim
g:coc_global_extensions = ['coc-clangd', 'coc-tsserver', 'coc-eslint', 'coc-json', 'coc-prettier', 'coc-rust-analyzer']

set number
set relativenumber
set clipboard=unnamedplus
set virtualedit=all
set textwidth=0
set formatoptions-=t
set nowrap
set sidescrolloff=9999
set scrolloff=9999
set background=dark
set cursorline
set splitbelow
set termguicolors
set mouse=a

# coc.nvim compatibility
set nobackup
set nowritebackup
set autoread

# indentation
set tabstop=4
set shiftwidth=4
set expandtab

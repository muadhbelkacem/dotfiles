vim9script

# netrw
nnoremap <leader>e :Lexplore!<CR>

# tabs
nnoremap <leader>j :tabprevious<CR>
nnoremap <leader>k :tabnext<CR>
tnoremap <leader>j <C-W>:tabprevious<CR>
tnoremap <leader>k <C-W>:tabnext<CR>

# coc.nvim
nnoremap <silent> <leader>d <Plug>(coc-definition)
nnoremap <silent> <leader>f <Plug>(coc-format)

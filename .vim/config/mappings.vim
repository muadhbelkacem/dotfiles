vim9script

# netrw
nnoremap <leader>e :Lexplore!<CR>

# tabs
nnoremap <leader>j :tabprevious<CR>
nnoremap <leader>k :tabnext<CR>
tnoremap <leader>j <C-W>:tabprevious<CR>
tnoremap <leader>k <C-W>:tabnext<CR>

# terminal
nnoremap <silent> <leader><Space>    <scriptcmd>g:ToggleTerminal()<CR>
tnoremap <silent> <leader><Space>    <scriptcmd>g:ToggleTerminal()<CR>
nnoremap <silent> <leader>n           <scriptcmd>g:NewTerminal()<CR>
tnoremap <silent> <leader>n           <scriptcmd>g:NewTerminal()<CR>

# coc.nvim
nnoremap <silent> <leader>d <Plug>(coc-definition)
nnoremap <silent> <leader>r <Plug>(coc-references)
nnoremap <silent> <leader>r <Plug>(coc-rename)
nnoremap <silent> <leader>f <Plug>(coc-format)
nnoremap <silent> K :call CocAction('doHover')<CR>

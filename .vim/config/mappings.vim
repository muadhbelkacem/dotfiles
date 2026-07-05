vim9script

import autoload 'lib/netrw.vim'
import autoload 'lib/terminal.vim'
import autoload 'lib/fzf.vim'

# netrw
nnoremap <silent> <leader>e <scriptcmd>netrw.NetrwToggle()<CR>

# fzf
nnoremap <silent> <leader>p <scriptcmd>fzf.Files()<CR>
nnoremap <silent> <leader>b <scriptcmd>fzf.Buffers()<CR>
nnoremap <silent> <leader>g <scriptcmd>fzf.GitFiles()<CR>

# tabs
nnoremap <leader>j :tabprevious<CR>
nnoremap <leader>k :tabnext<CR>
tnoremap <leader>j <C-W>:tabprevious<CR>
tnoremap <leader>k <C-W>:tabnext<CR>

# terminal
nnoremap <silent> <leader><Space>    <scriptcmd>terminal.ToggleTerminal()<CR>
tnoremap <silent> <leader><Space>    <scriptcmd>terminal.ToggleTerminal()<CR>
nnoremap <silent> <leader>n           <scriptcmd>terminal.NewTerminal()<CR>
tnoremap <silent> <leader>n           <scriptcmd>terminal.NewTerminal()<CR>

# coc.nvim
nnoremap <silent> <leader>d <Plug>(coc-definition)
nnoremap <silent> <leader>r <Plug>(coc-references)
nnoremap <silent> <leader>r <Plug>(coc-rename)
nnoremap <silent> <leader>f <Plug>(coc-format)
nnoremap <silent> K :call CocAction('doHover')<CR>

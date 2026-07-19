vim9script

import autoload 'lib/netrw.vim'
import autoload 'lib/terminal.vim'
import autoload 'lib/fzf.vim'
import autoload 'lib/split.vim'

# netrw
nnoremap <silent> <leader>e <scriptcmd>netrw.NetrwToggle()<CR>

# fzf
nnoremap <silent> <leader>p <scriptcmd>fzf.Files()<CR>
nnoremap <silent> <leader>b <scriptcmd>fzf.Buffers()<CR>

# tabs
nnoremap <leader>j :tabprevious<CR>
nnoremap <leader>k :tabnext<CR>
tnoremap <leader>j <C-W>:tabprevious<CR>
tnoremap <leader>k <C-W>:tabnext<CR>

# splits
nnoremap <leader>s <scriptcmd>split.SplitMode()<CR>
nnoremap <leader>c <scriptcmd>split.SplitMoveFocusMode()<CR>
nnoremap <leader>m <scriptcmd>split.SplitMoveWindowMode()<CR>
nnoremap <leader>r <scriptcmd>split.ResizeMode()<CR>

# terminal
nnoremap <silent> <leader><Space>    <scriptcmd>terminal.ToggleTerminal()<CR>
tnoremap <silent> <leader><Space>    <scriptcmd>terminal.ToggleTerminal()<CR>
nnoremap <silent> <leader>n           <scriptcmd>terminal.NewTerminal()<CR>
tnoremap <silent> <leader>n           <scriptcmd>terminal.NewTerminal()<CR>

# coc.nvim
nnoremap <silent> <leader>d <Plug>(coc-definition)
nnoremap <silent> <leader>f <Plug>(coc-format)
nnoremap <silent> K :call CocAction('doHover')<CR>

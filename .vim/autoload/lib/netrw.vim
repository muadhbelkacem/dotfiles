vim9script

var netrw_last_dir = getcwd()

# --- TRACK DIRECTORY SAFELY ---
augroup NetRWState
    autocmd!

    autocmd FileType netrw {
        setlocal relativenumber
        netrw_last_dir = get(b:, 'netrw_curdir', getcwd())
    }

    autocmd BufLeave * {
        if &filetype ==# 'netrw'
            netrw_last_dir = get(b:, 'netrw_curdir', getcwd())
        endif
    }
augroup END


# --- FIND EXISTING NETRW WINDOW ---
def FindNetrwWin(): number
    for w in range(1, winnr('$'))
        if getbufvar(winbufnr(w), '&filetype') ==# 'netrw'
            return win_getid(w)
        endif
    endfor
    return -1
enddef


# --- TOGGLE ---
export def NetrwToggle()
    var id = FindNetrwWin()

    # If netrw is already open
    if id != -1
        if win_getid() == id
            # If we are currently in the netrw window, toggle it off
            # Try to return to the specific buffer we came from
            var prev = get(w:, 'netrw_prev_buf', -1)
            if prev != -1 && buflisted(prev) && prev != bufnr('%')
                execute 'buffer ' .. prev
                # Clean up the variable after returning
                if has_key(w:, 'netrw_prev_buf')
                    remove(w:, 'netrw_prev_buf')
                endif
            else
                try
                    execute 'buffer #'
                catch
                    # If no previous buffer, just open a new empty one
                    execute 'enew'
                endtry
            endif
        else
            # If netrw is open in another window, jump to it
            win_gotoid(id)
        endif
        return
    endif

    # If netrw is not open, open it in the current window (fullscreen)
    # Store current buffer to return to it later when toggling off
    w:netrw_prev_buf = bufnr('%')

    var dir = (netrw_last_dir != '' && isdirectory(netrw_last_dir)) ? netrw_last_dir : getcwd()
    execute 'Explore ' .. dir
enddef

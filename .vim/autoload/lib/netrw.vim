vim9script

var netrw_last_dir = ''
var netrw_winid = -1

# --- TRACK DIRECTORY SAFELY ---
augroup NetRWSidebarState
    autocmd!

    autocmd FileType netrw {
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


# --- OPEN SIDEBAR ---
def OpenSidebar(dir: string)
    # Try reuse existing sidebar
    var id = FindNetrwWin()

    if id != -1
        win_gotoid(id)
    else
        vertical botright split
        var width = &columns * 30 / 100
        execute 'vertical resize ' .. width
    endif

    if dir != '' && isdirectory(dir)
        execute 'Explore ' .. dir
    else
        execute 'Explore'
    endif

    setlocal winfixwidth
    setlocal nobuflisted
enddef


# --- CLOSE SIDEBAR ---
def CloseSidebar()
    var id = FindNetrwWin()

    if id != -1
        # Prevent E444: Cannot close last window
        if winnr('$') > 1 || tabpagenr('$') > 1
            win_execute(id, 'close')
        endif
        netrw_winid = -1
    endif
enddef


# --- TOGGLE ---
export def NetrwToggle()
    var id = FindNetrwWin()

    if id != -1
        CloseSidebar()
        return
    endif

    OpenSidebar(netrw_last_dir)
enddef
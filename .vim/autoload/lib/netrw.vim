vim9script

var netrw_last_dir = ''

export def NetrwToggle()
    var netrw_win = -1
    for w in range(1, winnr('$'))
        if getwinvar(w, '&ft') == 'netrw'
            netrw_win = w
            break
        endif
    endfor

    if netrw_win != -1
        netrw_last_dir = getbufvar(winbufnr(netrw_win), 'netrw_curdir')
        execute 'Lexplore!'
    else
        if netrw_last_dir != '' && isdirectory(netrw_last_dir)
            execute 'Lexplore! ' .. netrw_last_dir
        else
            execute 'Lexplore!'
        endif
    endif
enddef

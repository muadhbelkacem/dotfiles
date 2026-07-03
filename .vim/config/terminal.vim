vim9script

var term_count = len(term_list())

def ShowTerminals(focus_buf: number = -1)
    const term_bufs = term_list()
    for b in term_bufs
        var wins = win_findbuf(b)
        if empty(wins)
            execute 'tab sbuf ' .. b
            wins = win_findbuf(b)
        endif
        if !empty(wins)
            win_execute(wins[0], 'only')
        endif
    endfor

    if focus_buf != -1
        const wins = win_findbuf(focus_buf)
        if !empty(wins)
            win_gotoid(wins[0])
        endif
    elseif !empty(term_bufs)
        const wins = win_findbuf(term_bufs[0])
        if !empty(wins)
            win_gotoid(wins[0])
        endif
    endif
enddef

def g:NewTerminal()
    term_count += 1
    tab terminal
    execute 'file term' .. term_count
    ShowTerminals(bufnr())
enddef

def g:ToggleTerminal()
    const term_bufs = term_list()

    if empty(term_bufs)
        g:NewTerminal()
        return
    endif

    const is_focused_term = index(term_bufs, bufnr()) != -1

    if !is_focused_term
        ShowTerminals()
        return
    endif

    # Gather all terminal windows to hide them together
    var term_wids = []
    for b in term_bufs
        extend(term_wids, win_findbuf(b))
    endfor
    term_wids = uniq(sort(term_wids))

    # Hide background terminals first, then the current one to minimize jumping
    const cur_wid = win_getid()
    for wid in term_wids
        if wid != cur_wid
            win_execute(wid, 'hide')
        endif
    endfor
    hide
enddef

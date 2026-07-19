vim9script

export def SplitMode()
    redraw
    echo '-- SPLIT -- (h: left, j: down, k: up, l: right)'
    var c = getcharstr()
    if c == 'h'
        execute 'leftabove vsplit'
    elseif c == 'j'
        execute 'belowright split'
    elseif c == 'k'
        execute 'aboveleft split'
    elseif c == 'l'
        execute 'belowright vsplit'
    else
        feedkeys(c, 'n')
    endif
    echo ''
enddef

def SetFocusHighlight()
    setwinvar(0, '&wincolor', 'Visual')
enddef

def ClearFocusHighlight()
    setwinvar(0, '&wincolor', '')
enddef

export def SplitMoveFocusMode()
    SetFocusHighlight()
    try
        while true
            redraw
            echo '-- MOVE FOCUS -- (h j k l)'
            var c = getcharstr()
            ClearFocusHighlight()
            if c == 'h'
                execute 'wincmd h'
            elseif c == 'j'
                execute 'wincmd j'
            elseif c == 'k'
                execute 'wincmd k'
            elseif c == 'l'
                execute 'wincmd l'
            else
                echo ''
                feedkeys(c, 'n')
                break
            endif
            SetFocusHighlight()
        endwhile
    finally
        ClearFocusHighlight()
        redraw
    endtry
enddef

export def SplitMoveWindowMode()
    SetFocusHighlight()
    try
        while true
            redraw
            echo '-- MOVE WINDOW -- (h j k l)'
            var c = getcharstr()
            ClearFocusHighlight()
            if c == 'h'
                execute 'wincmd H'
            elseif c == 'j'
                execute 'wincmd J'
            elseif c == 'k'
                execute 'wincmd K'
            elseif c == 'l'
                execute 'wincmd L'
            else
                echo ''
                feedkeys(c, 'n')
                break
            endif
            SetFocusHighlight()
        endwhile
    finally
        ClearFocusHighlight()
        redraw
    endtry
enddef

export def ResizeMode()
    SetFocusHighlight()
    try
        while true
            redraw
            echo '-- RESIZE -- (h j k l)'
            var c = getcharstr()
            if c == 'h'
                execute 'vertical resize -5'
            elseif c == 'j'
                execute 'resize -5'
            elseif c == 'k'
                execute 'resize +5'
            elseif c == 'l'
                execute 'vertical resize +5'
            else
                echo ''
                feedkeys(c, 'n')
                break
            endif
        endwhile
    finally
        ClearFocusHighlight()
        redraw
    endtry
enddef

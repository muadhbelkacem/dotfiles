vim9script

# Minimal fzf integration using Vim9 script.
# This avoids the need for the fzf.vim plugin.

export def Run(cmd: string = 'fzf', Callback: any = null)
    const temp = tempname()
    const shell_cmd = $'({cmd}) > {temp}'

    # Save current window to return to it
    const prev_win = win_getid()

    # Open a terminal in a new split
    botright :15new

    term_start(['sh', '-c', shell_cmd], {
        curwin: true,
        term_finish: 'close',
        exit_cb: (job, status) => {
            # Close the terminal window (it might already be closed depending on term_finish)
            # but we want to make sure we are back in the previous window.
            win_gotoid(prev_win)

            if status == 0 && filereadable(temp)
                const lines = readfile(temp)
                if !empty(lines)
                    if Callback != null
                        Callback(lines)
                    else
                        for line in lines
                            if filereadable(line) || isdirectory(line)
                                execute 'edit ' .. fnameescape(line)
                            endif
                        endfor
                    endif
                endif
            endif

            if filereadable(temp)
                delete(temp)
            endif
        }
    })
enddef

const PREVIEW = executable('bat') ? '--preview "bat --style=numbers --color=always --line-range :500 {}"' : ''

export def Files()
    Run($'fzf {PREVIEW}')
enddef

export def Buffers()
    const bufs = getbufinfo({'buflisted': 1})
        ->mapnew((_, v) => v.name)
        ->filter((_, v) => !empty(v))

    if empty(bufs)
        echo "No buffers"
        return
    endif

    const temp = tempname()
    writefile(bufs, temp)

    Run($'cat {temp} | fzf {PREVIEW}', (lines) => {
        for line in lines
            execute 'buffer ' .. fnameescape(line)
        endfor
    })
enddef

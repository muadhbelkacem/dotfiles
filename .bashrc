# run first

eval "$(starship init bash)"
# PF_INFO="ascii title os kernel host shell wm uptime pkgs memory palette" pfetch

# optional: always append (don’t overwrite) when writing history

shopt -s histappend

hsr(){
    eval $(history | grep $1 | fzf | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*//')
}
hr() {
    local selected_command
    selected_command=$(history | fzf | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*//')
    if [[ -n "$selected_command" ]]; then
        echo "Command: $selected_command"
        read -rp "Do you want to execute this command? (y/N): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            # Add the selected command to history
            history -s "$selected_command"
            # Execute the command
            eval "$selected_command"
        else
            echo "Command execution canceled."
        fi
    fi
}

changeprefix(){
  local old="$1" new="$2"
  for f in "${old}"*; do
    [ -e "$f" ] || continue
    mv -- "$f" "${new}${f#${old}}"
  done
}

# aliases

alias ls='eza --icons'
alias grep='grep --color=auto'
alias lp='find . -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.avi" \)| sed "s|^\./||"| fzf | xargs -r -d "\n" mpv'

alias e='emacsclient -c -a "emacs" -nw'
alias v='nvim'
alias i='yay -S'
alias u='yay -Syu'
alias s='yay -Ss'
alias r='yay -Rns'
alias ro='yay -Yc'

alias ll='ls -lah'
alias c='clear'
alias hst='history'
alias gr='grep'
alias hstg='hst | gr'
alias pv='f=$(fzf) && mpv "$f"'

alias gts="git status"
alias gtl="git log --oneline"
alias gtc="git add .; git commit -m "
alias gtrh='f(){ if [ -z "$1" ]; then echo "Usage: gtrh <N>"; return 1; fi; git add . && git reset --hard HEAD~"$1"; }; f'
alias gtrs='f(){ if [ -z "$1" ]; then echo "Usage: gtrh <N>"; return 1; fi; git add . && git reset --soft HEAD~"$1"; }; f'

alias wfon='nmcli radio wifi on'
alias wfoff='nmcli radio wifi off'
alias wifi='nmcli device wifi'
alias wfl='wifi list'
alias wfc='wifi connect'

alias renumber='i=1; for f in $(command ls -v *.{jpg,jpeg,png,gif} 2>/dev/null); do mv -- "$f" "__tmp__$i.${f##*.}"; ((i++)); done; i=1; for f in __tmp__*; do ext="${f##*.}"; mv -- "$f" "$i.$ext"; ((i++)); done'
alias md='mkdir -p'
alias py='python'

# exports

export HYPRSHOT_DIR="$HOME/screenshots"
export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_CURRENT_DESKTOP=sway

# unlimited in‑memory history
export HISTSIZE=-1

# unlimited in‑file history
export HISTFILESIZE=-1

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/home/muadh/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/muadh/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

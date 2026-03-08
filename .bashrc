eval "$(starship init bash)"

#exports

export HYPRSHOT_DIR="$HOME/screenshots"
export QT_QPA_PLATFORMTHEME=qt5ct
# unlimited in‑memory history
export HISTSIZE=-1

# unlimited in‑file history
export HISTFILESIZE=-1

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

#aliases

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias lp='find . -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.avi" \)| sed "s|^\./||"| fzf | xargs -r -d "\n" mpv'

alias nv='nvim'
alias i='yay -S'
alias u='yay -Syy'
alias ug='yay -Syyu'
alias r='yay -Rns'
alias s='yay -Ss'
alias cln='yay -Rns $(yay -Qtdq)'

alias ll='ls -lah'
alias c='clear'
alias hst='history'
alias gr='grep'
alias hstg='hst | gr'
alias pv='f=$(fzf) && mpv "$f"'

alias wfon='nmcli radio wifi on'
alias wfoff='nmcli radio wifi off'
alias wifi='nmcli device wifi'
alias wfl='wifi list'
alias wfc='wifi connect'

alias renumber='i=1; ls -v *.{jpg,png,gif,jpeg} | while read -r f; do ext="${f##*.}"; mv "$f" "$((i++)).$ext"; done'
alias md='mkdir -p'
alias py='python'

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

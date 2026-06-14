# --- General Settings & Options ---
shopt -s histappend
# unlimited in-memory history
export HISTSIZE=-1
# unlimited in-file history
export HISTFILESIZE=-1

# Prompt
eval "$(starship init bash)"
# PF_INFO="ascii title os kernel host shell wm uptime pkgs memory palette" pfetch

# --- Environment Variables & PATH ---
export HYPRSHOT_DIR="$HOME/screenshots"
export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_CURRENT_DESKTOP=sway

# Android SDK
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Herd Lite
export PATH="/home/muadh/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/muadh/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# --- Aliases ---

# General
alias ls='eza --icons'
alias ll='ls -lah'
alias c='clear'
alias grep='grep --color=auto'
alias gr='grep'
alias hst='history'
alias hstg='hst | gr'
alias md='mkdir -p'
alias py='python'

# Editor
alias v='nvim'
alias e='emacsclient -c -a "emacs" -nw'

# Package Manager (yay)
alias i='yay -S'
alias u='yay -Syu'
alias s='yay -Ss'
alias r='yay -Rns'
alias ro='yay -Yc'

# Git
alias gts="git status"
alias gtl="git log --oneline"
alias gtc="git add .; git commit -m "
alias gtrh='f(){ if [ -z "$1" ]; then echo "Usage: gtrh <N>"; return 1; fi; git add . && git reset --hard HEAD~"$1"; }; f'
alias gtrs='f(){ if [ -z "$1" ]; then echo "Usage: gtrs <N>"; return 1; fi; git add . && git reset --soft HEAD~"$1"; }; f'

# Network (WiFi)
alias wfon='nmcli radio wifi on'
alias wfoff='nmcli radio wifi off'
alias wifi='nmcli device wifi'
alias wfl='wifi list'
alias wfc='wifi connect'

# Media & FZF
alias lp='find . -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.avi" \)| sed "s|^\./||"| fzf | xargs -r -d "\n" mpv'
alias pv='f=$(fzf) && mpv "$f"'

# Utilities
alias renumber='i=1; for f in $(command ls -v *.{jpg,jpeg,png,gif} 2>/dev/null); do mv -- "$f" "__tmp__$i.${f##*.}"; ((i++)); done; i=1; for f in __tmp__*; do ext="${f##*.}"; mv -- "$f" "$i.$ext"; ((i++)); done'

# --- Functions ---

# History search and run
hsr(){
    eval $(history | grep $1 | fzf | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*//')
}

# Interactive history selector
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

# Change prefix of files
changeprefix(){
  local old="$1" new="$2"
  for f in "${old}"*; do
    [ -e "$f" ] || continue
    mv -- "$f" "${new}${f#${old}}"
  done
}

# --- External Tool Initializations ---

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

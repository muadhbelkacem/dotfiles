picom -b &
touchegg &
watch -n 60 'feh --no-fehbg --randomize --bg-fill ~/wallpapers/*'
alacritty -e htop &
polybar &
exec qtile start

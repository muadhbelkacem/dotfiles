picom -b &
touchegg &
setxkbmap -layout us,ara,fr -option caps:escape_shifted_capslock & 
dunst &
feh --no-fehbg --randomize --bg-fill ~/wallpapers/* &
/usr/lib/xdg-desktop-portal-gtk &
emacs --daemon &
exec awesome

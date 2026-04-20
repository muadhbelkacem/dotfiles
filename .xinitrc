picom -b &
touchegg &
setxkbmap -layout us,ara,fr -option caps:escape -option ctrl:swap_lalt_lctl -option ctrl:swap_ralt_rctl &
dunst &
feh --no-fehbg --randomize --bg-fill ~/wallpapers/* &
/usr/lib/xdg-desktop-portal-gtk &
emacs --daemon &
exec awesome

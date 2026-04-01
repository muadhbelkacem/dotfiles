picom -b &
touchegg &
setxkbmap -layout us,ara,fr -option ctrl:nocaps -option ctrl:swap_lalt_lctl &
dunst &

wallpaper_loop() {
    while true; do
        feh --no-fehbg --randomize --bg-fill ~/wallpapers/*
        sleep 500
    done
}

wallpaper_loop &
rofi -show drun &
/usr/lib/xdg-desktop-portal-gtk &
exec awesome

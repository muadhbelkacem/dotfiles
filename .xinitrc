picom -b &
touchegg &
setxkbmap -layout us,ara,fr -option caps:escape_shifted_capslock &

wallpaper_loop() {
    while true; do
        feh --no-fehbg --randomize --bg-fill ~/wallpapers/*
        sleep 500
    done
}

wallpaper_loop &
rofi -show drun &
exec awesome

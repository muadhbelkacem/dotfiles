picom -b &
touchegg &
setxkbmap -layout us,ara,fr -option ctrl:nocaps &
dunst &

wallpaper_loop() {
    while true; do
        feh --no-fehbg --randomize --bg-fill ~/wallpapers/*
        sleep 500
    done
}

wallpaper_loop &
rofi -show drun &
pipewire &
wireplumber &
exec dbus-run-session awesome
exec awesome

picom -b &
touchegg &

wallpaper_loop() {
    while true; do
        feh --no-fehbg --randomize --bg-fill ~/wallpapers/*
        sleep 60
    done
}

wallpaper_loop &
alacritty -e htop &
polybar &
exec qtile start

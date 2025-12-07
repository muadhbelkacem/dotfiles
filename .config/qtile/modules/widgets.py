from libqtile import widget
from libqtile.widget import backlight
from .colors import widget_colors, border_focus_color


widgets = [
    widget.GroupBox(
        font="JetBrainsMono Nerd Font",
        margin_y=3,
        margin_x=5,
        padding_y=4,
        padding_x=6,
        borderwidth=2,
        active="#ffffff",
        inactive="#888888",
        this_current_screen_border=border_focus_color,
        other_screen_border="#444444",
        highlight_method="line",
        rounded=False,
        hide_unused=False,
        background="#1B1B1B",
    ),
    widget.Prompt(),
    widget.WindowName(),
    widget.Chord(
        chords_colors={
            "launch": ("#ff0000", "#ffffff"),
        },
        name_transform=lambda name: name.upper(),
    ),
    widget.CapsNumLockIndicator(
        fmt="\{}",
        foreground=widget_colors["CapsNumLockIndicator"],
    ),
    widget.Volume(fmt="\Vol: {}", foreground=widget_colors["Volume"]),
    widget.Net(
        interface="enp0s25",
        update_interval=1,
        format="\enp0s25 ⬇{down}",
        foreground=widget_colors["Net"],
    ),
    widget.Wlan(
        interface="wlp3s0",
        update_interval=1,
        format="{essid}",
        foreground=widget_colors["Wlan"],
    ),
    widget.Net(
        interface="wlp3s0",
        update_interval=1,
        format="⬇{down}",
        foreground=widget_colors["Net"],
    ),
    backlight.Backlight(
        backlight_name="intel_backlight",  # adjust this to your device
        format="\☀ {percent:2.0%}",  # how you want it to display
        change_command=None,  # or specify a command if you want change
        update_interval=0.2,
        foreground=widget_colors["Backlight"],
    ),
    widget.KeyboardLayout(
        configured_keyboards=["us", "ara", "fr"],
        foreground=widget_colors["KeyboardLayout"],
        fmt="\{}",
    ),
    widget.Battery(
        battery=0,
        format="\BAT1 {char}{percent:2.0%}",
        update_interval=30,
        foreground=widget_colors["Battery"],
    ),
    widget.Battery(
        battery=1,
        format="BAT2 {char}{percent:2.0%}",
        update_interval=30,
        foreground=widget_colors["Battery"],
    ),
    widget.Systray(),
    widget.Clock(format="\%Y-%m-%d %a %I:%M %p", foreground=widget_colors["Clock"]),
    widget.QuickExit(foreground=widget_colors["QuickExit"]),
]

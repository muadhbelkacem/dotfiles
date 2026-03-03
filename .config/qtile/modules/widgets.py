from libqtile import widget
from libqtile.widget import backlight
from .colors import widget_colors, border_focus_color

def separator():
    return widget.Sep(
        linewidth=0,
        padding=10,
    )

widgets = [
    separator(),
    widget.GroupBox(
        font="JetBrainsMono Nerd Font",
        fontsize=12,
        margin_y=3,
        margin_x=0,
        padding_y=5,
        padding_x=3,
        borderwidth=3,
        active="#ffffff",
        inactive="#555555",
        rounded=True,
        highlight_color="#282c34",
        highlight_method="line",
        this_current_screen_border=border_focus_color,
        this_screen_border="#353b45",
        other_current_screen_border="#282c34",
        other_screen_border="#282c34",
        foreground="#ffffff",
        background="#1B1B1B",
    ),
    separator(),
    widget.Prompt(),
    widget.WindowName(
        foreground="#bbbbbb",
        max_chars=40,
    ),
    widget.Chord(
        chords_colors={
            "launch": ("#ff0000", "#ffffff"),
        },
        name_transform=lambda name: name.upper(),
    ),
    widget.Spacer(),
    widget.Systray(
        padding=10,
    ),
    separator(),
    widget.Volume(
        fmt="󰕾 {}",
        foreground=widget_colors["Volume"],
        padding=5,
    ),
    widget.Net(
        interface="enp0s25",
        update_interval=1,
        format="󰈀 {down}",
        foreground=widget_colors["Net"],
        padding=5,
    ),
    widget.Wlan(
        interface="wlp3s0",
        update_interval=1,
        format="󰖩 {essid}",
        foreground=widget_colors["Wlan"],
        padding=5,
    ),
    backlight.Backlight(
        backlight_name="intel_backlight",
        format="󰃟 {percent:2.0%}",
        update_interval=0.2,
        foreground=widget_colors["Backlight"],
        padding=5,
    ),
    widget.Battery(
        battery=0,
        format="󰁹 {percent:2.0%}",
        update_interval=30,
        foreground=widget_colors["Battery"],
        padding=5,
    ),
    widget.KeyboardLayout(
        configured_keyboards=["us", "ara", "fr"],
        foreground=widget_colors["KeyboardLayout"],
        fmt="󰌌 {}",
        padding=5,
    ),
    widget.Clock(
        format="󰃭 %Y-%m-%d %a 󰥔 %I:%M %p",
        foreground=widget_colors["Clock"],
        padding=5,
    ),
    widget.QuickExit(
        default_next_text="󰐥",
        countdown_format="{}",
        foreground=widget_colors["QuickExit"],
        padding=10,
    ),
    separator(),
]

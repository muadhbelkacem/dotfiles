from libqtile import qtile
from libqtile.config import Key
from libqtile.lazy import lazy
from .constants import mod, terminal

keys = [
    Key([mod], "s", lazy.group["scratchpad"].dropdown_toggle("term1")),
    Key([mod, "shift"], "s", lazy.group["scratchpad"].dropdown_toggle("term2")),
    Key([mod], "n", lazy.group["scratchpad"].dropdown_toggle("note")),
    Key([mod], "m", lazy.spawn("slock"), desc="Lock screen with slock"),
    Key(
        [mod],
        "space",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout.",
    ),

    # Volume control
    Key(
        [mod],
        "o",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        desc="Increase volume",
    ),
    Key(
        [mod, "shift"],
        "o",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        desc="Decrease volume",
    ),
    # Brightness control
    Key(
        [mod],
        "p",
        lazy.spawn("brightnessctl set 5%+"),
        desc="Increase screen brightness",
    ),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn("brightnessctl set 5%-"),
        desc="Decrease screen brightness",
    ),
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    # Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod, "shift"],
        "f",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    # Rofi
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Open rofi"),
    # Qtile
    Key([mod], "x", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Shutdown Qtile"),
]
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

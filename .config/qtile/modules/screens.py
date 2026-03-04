from libqtile.config import Screen
from libqtile import bar
from .widgets import widgets
from .colors import background_color

screens = [
    Screen(
        top=bar.Bar(
            widgets,
            24,
            background=background_color,
            margin=[5, 5, 0, 5],
        ),
    ),
]

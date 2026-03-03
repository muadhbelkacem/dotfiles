from libqtile import bar
from libqtile.config import Screen
from .constants import columns_border_width, columns_margin
from .widgets import widgets
from .colors import background_color

gap = columns_border_width + columns_margin

screens = [
    Screen(
        top=bar.Bar(
            widgets,
            28, # Increased height for a modern look
            background=background_color,
            margin=[6, 10, 6, 10], # [top, right, bottom, left] - floating bar look
            opacity=0.9,
            border_width=[2, 0, 2, 0], # Optional: add top/bottom borders
            border_color="#3d4451"
        ),
    ),
]

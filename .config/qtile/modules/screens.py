from libqtile import bar
from libqtile.config import Screen
from .constants import columns_border_width, columns_margin
from .widgets import widgets

gap = columns_border_width + columns_margin

screens = [
    Screen(
        right=bar.Gap(gap),
        left=bar.Gap(gap),
        bottom=bar.Gap(gap),
        top=bar.Bar(
            widgets,
            24,
            background="#0F0F0F",
            margin=[0, 30, gap, 30],
        ),
        background="#0F0F0F",
    ),
]

from libqtile import layout
from .constants import columns_border_width, columns_margin
from .colors import border_focus_color, border_normal_color

layouts = [
    layout.Columns(
        border_on_single=True,
        border_focus=border_focus_color,
        border_normal=border_normal_color,
        border_width=columns_border_width,
        margin=columns_margin,
        margin_on_single=columns_margin,
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

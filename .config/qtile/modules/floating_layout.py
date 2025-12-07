from libqtile import layout
from libqtile.config import Match

floating_layout = layout.Floating(
    border_focus="#feed6e",
    border_normal="#0F0F0F",
    border_width=3,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ],
)

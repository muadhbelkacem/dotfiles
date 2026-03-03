from modules.keys import keys
from modules.groups import groups
from modules.layouts import layouts
from modules.screens import screens
from modules.widget_defaults import widget_defaults
from modules.floating_layout import floating_layout
from modules.mouse import mouse

keys = keys
groups = groups
layouts = layouts
extension_defaults = widget_defaults.copy()
screens = screens
mouse = mouse
floating_layout = floating_layout

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"

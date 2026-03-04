local theme_assets = require("beautiful.theme_assets")
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font          = "sans 8"

theme.bg_normal     = "#2d353b"
theme.bg_focus      = "#3d484d"
theme.bg_urgent     = "#e67e80"
theme.bg_minimize   = "#475258"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#d3c6aa"
theme.fg_focus      = "#a7c080"
theme.fg_urgent     = "#2d353b"
theme.fg_minimize   = "#859289"

theme.useless_gap   = 5
theme.border_width  = 1
theme.border_normal = "#475258"
theme.border_focus  = "#a7c080"
theme.border_marked = "#dbbc7f"

-- Generate taglist squares
local taglist_square_size = 4
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_focus
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications
theme.notification_font = "sans 12"
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_border_width = 1
theme.notification_border_color = theme.border_focus
theme.notification_margin = 10

return theme

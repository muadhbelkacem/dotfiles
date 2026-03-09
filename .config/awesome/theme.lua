local theme_assets = require("beautiful.theme_assets")
local gears = require("gears")
local gfs = require("gears.filesystem")

local theme = {}

-- Modern Font
theme.font          = "Inter SemiBold 10"
theme.icon_font     = "JetBrainsMono Nerd Font 11"

-- Color Palette (Everforest Hard)
theme.bg_normal     = "#272e33"
theme.bg_focus      = "#374148"
theme.bg_urgent     = "#e67e80"
theme.bg_minimize   = "#414b50"
theme.bg_systray    = theme.bg_focus

theme.fg_normal     = "#d3c6aa"
theme.fg_focus      = "#dbbc7f"
theme.fg_urgent     = "#272e33"
theme.fg_minimize   = "#859289"

-- Accent colors
theme.blue          = "#7fbbb3"
theme.cyan          = "#83c092"
theme.green         = "#a7c080"
theme.magenta       = "#d699b6"
theme.orange        = "#e69875"
theme.red           = "#e67e80"
theme.yellow        = "#dbbc7f"

-- Borders
theme.useless_gap   = 0
theme.border_width  = 2
theme.border_normal = "#374148"
theme.border_focus  = theme.yellow
theme.border_marked = theme.blue

-- Wibar properties
theme.wibar_height  = 27
theme.wibar_bg      = theme.bg_normal
theme.wibar_fg      = theme.fg_normal

-- Taglist styling
theme.taglist_fg_focus    = theme.bg_normal
theme.taglist_bg_focus    = theme.yellow
theme.taglist_fg_occupied = theme.green
theme.taglist_fg_empty    = "#495156"
theme.taglist_spacing     = 4

-- Tasklist styling
theme.tasklist_bg_focus    = theme.bg_focus
theme.tasklist_fg_focus    = theme.fg_focus
theme.tasklist_bg_normal   = theme.bg_normal
theme.tasklist_fg_normal   = theme.fg_normal
theme.tasklist_spacing     = 0

-- Titlebar styling
theme.titlebar_size = 28
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_fg_focus = theme.fg_focus

-- Notification styling
theme.notification_font = "Inter 11"
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_border_width = 1
theme.notification_border_color = theme.yellow
theme.notification_margin = 10

-- Wallpaper
theme.wallpaper = gfs.get_configuration_dir() .. "wallpaper.jpg"

return theme

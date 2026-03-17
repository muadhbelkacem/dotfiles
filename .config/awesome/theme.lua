local gfs = require("gears.filesystem")

local theme = {}

-- Modern Font
theme.font          = "Inter SemiBold 10"
theme.icon_font     = "JetBrainsMono Nerd Font 11"

-- Color Palette
theme.bg_normal     = "#292522"
theme.bg_focus      = "#403A36"
theme.bg_urgent     = "#BD8183"
theme.bg_minimize   = "#34302C"
theme.bg_systray    = theme.bg_focus

theme.fg_normal     = "#ECE1D7"
theme.fg_focus      = "#EBC06D"
theme.fg_urgent     = "#292522"
theme.fg_minimize   = "#867462"

-- Accent colors
theme.blue          = "#7F91B2"
theme.cyan          = "#7B9695"
theme.green         = "#78997A"
theme.magenta       = "#B3809B"
theme.orange        = "#CF9C79"
theme.red           = "#fb4934"
theme.yellow        = "#EBC06D"

-- Borders
theme.useless_gap   = 0
theme.border_width  = 1
theme.border_normal = "#34302C"
theme.border_focus  = "#EBC06D"
theme.border_marked = theme.blue

-- Wibar properties
theme.wibar_height  = 24
theme.wibar_bg      = theme.bg_normal
theme.wibar_fg      = theme.fg_normal

-- Taglist styling
theme.taglist_fg_focus    = theme.bg_normal
theme.taglist_bg_focus    = theme.yellow
theme.taglist_fg_occupied = theme.cyan
theme.taglist_fg_empty    = "#867462"
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

local gfs = require("gears.filesystem")

local theme = {}

-- Modern Font
theme.font          = "Inter SemiBold 10"
theme.icon_font     = "JetBrainsMono Nerd Font 11"

-- Color Palette
theme.bg_normal     = "#1E1E1E"
theme.bg_focus      = "#2D2D2D"
theme.bg_urgent     = "#F44747"
theme.bg_minimize   = "#323232"
theme.bg_systray    = theme.bg_focus

theme.fg_normal     = "#D4D4D4"
theme.fg_focus      = "#FFFFFF"
theme.fg_urgent     = "#1E1E1E"
theme.fg_minimize   = "#808080"

-- Accent colors (VS Code)
theme.blue          = "#569CD6"
theme.cyan          = "#4EC9B0"
theme.green         = "#6A9955"
theme.magenta       = "#C586C0"
theme.orange        = "#CE9178"
theme.red           = "#F44747"
theme.yellow        = "#DCDCAA"

-- Borders
theme.useless_gap   = 4
theme.border_width  = 1
theme.border_normal = "#333333"
theme.border_focus  = "#007ACC"
theme.border_marked = theme.blue

-- Wibar properties
theme.wibar_height  = 24
theme.wibar_bg      = "#333333"
theme.wibar_fg      = theme.fg_normal

-- Taglist styling
theme.taglist_fg_focus    = theme.fg_focus
theme.taglist_bg_focus    = "#007ACC"
theme.taglist_fg_occupied = theme.blue
theme.taglist_fg_empty    = "#808080"
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
theme.notification_border_color = "#007ACC"
theme.notification_margin = 10

-- Wallpaper
theme.wallpaper = gfs.get_configuration_dir() .. "wallpaper.jpg"

return theme

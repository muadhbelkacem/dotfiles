local theme_assets = require("beautiful.theme_assets")
local gears = require("gears")
local gfs = require("gears.filesystem")

local theme = {}

-- Modern Font
theme.font          = "Inter SemiBold 10"
theme.icon_font     = "JetBrainsMono Nerd Font 11"

-- Color Palette (Gruvbox Dark)
theme.bg_normal     = "#282828"
theme.bg_focus      = "#3c3836"
theme.bg_urgent     = "#fb4934"
theme.bg_minimize   = "#504945"
theme.bg_systray    = theme.bg_focus

theme.fg_normal     = "#ebdbb2"
theme.fg_focus      = "#fabd2f"
theme.fg_urgent     = "#282828"
theme.fg_minimize   = "#928374"

-- Accent colors
theme.blue          = "#83a598"
theme.cyan          = "#8ec07c"
theme.green         = "#b8bb26"
theme.magenta       = "#d3869b"
theme.orange        = "#fe8019"
theme.red           = "#fb4934"
theme.yellow        = "#fabd2f"

-- Borders
theme.useless_gap   = 0
theme.border_width  = 2
theme.border_normal = "#3c3836"
theme.border_focus  = theme.yellow
theme.border_marked = theme.blue

-- Wibar properties
theme.wibar_height  = 30
theme.wibar_bg      = theme.bg_normal
theme.wibar_fg      = theme.fg_normal

-- Taglist styling
theme.taglist_fg_focus    = theme.bg_normal
theme.taglist_bg_focus    = theme.yellow
theme.taglist_fg_occupied = theme.green
theme.taglist_fg_empty    = "#665c54"
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

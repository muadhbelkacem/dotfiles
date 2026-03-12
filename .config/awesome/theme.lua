local theme_assets = require("beautiful.theme_assets")
local gears = require("gears")
local gfs = require("gears.filesystem")

local theme = {}

-- Modern Font
theme.font          = "Inter SemiBold 10"
theme.icon_font     = "JetBrainsMono Nerd Font 11"

-- Color Palette
theme.bg_normal     = "#191724"
theme.bg_focus      = "#1f1d2e"
theme.bg_urgent     = "#eb6f92"
theme.bg_minimize   = "#26233a"
theme.bg_systray    = theme.bg_focus

theme.fg_normal     = "#e0def4"
theme.fg_focus      = "#ebbcba"
theme.fg_urgent     = "#191724"
theme.fg_minimize   = "#6e6a86"

-- Accent colors
theme.blue          = "#31748f"
theme.cyan          = "#9ccfd8"
theme.green         = "#31748f"
theme.magenta       = "#c4a7e7"
theme.orange        = "#f6c177"
theme.red           = "#eb6f92"
theme.yellow        = "#f6c177"

-- Borders
theme.useless_gap   = 0
theme.border_width  = 2
theme.border_normal = "#26233a"
theme.border_focus  = "#ebbcba"
theme.border_marked = theme.blue

-- Wibar properties
theme.wibar_height  = 27
theme.wibar_bg      = theme.bg_normal
theme.wibar_fg      = theme.fg_normal

-- Taglist styling
theme.taglist_fg_focus    = theme.bg_normal
theme.taglist_bg_focus    = theme.yellow
theme.taglist_fg_occupied = theme.cyan
theme.taglist_fg_empty    = "#6e6a86"
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

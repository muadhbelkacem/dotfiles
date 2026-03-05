local theme_assets = require("beautiful.theme_assets")
local gears = require("gears")
local gfs = require("gears.filesystem")

local theme = {}

-- Modern Font (Assumes Nerd Font is installed for icons)
theme.font          = "Inter SemiBold 10"
theme.icon_font     = "JetBrainsMono Nerd Font 11"

-- Color Palette (Deep Dark / Modern)
theme.bg_normal     = "#1a1b26" -- Tokyo Night inspired deep dark
theme.bg_focus      = "#24283b"
theme.bg_urgent     = "#f7768e"
theme.bg_minimize   = "#292e42"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#a9b1d6"
theme.fg_focus      = "#7aa2f7" -- Bright Blue accent
theme.fg_urgent     = "#1a1b26"
theme.fg_minimize   = "#565f89"

-- Accent colors
theme.blue          = "#7aa2f7"
theme.cyan          = "#7dcfff"
theme.green         = "#9ece6a"
theme.magenta       = "#bb9af7"
theme.orange        = "#ff9e64"
theme.red           = "#f7768e"
theme.yellow        = "#e0af68"

-- Borders (Sharp)
theme.useless_gap   = 3
theme.border_width  = 3
theme.border_normal = "#15161e"
theme.border_focus  = theme.orange
theme.border_marked = theme.blue

-- Wibar properties
theme.wibar_height  = 30
theme.wibar_bg      = theme.bg_normal
theme.wibar_fg      = theme.fg_normal

-- Taglist styling
theme.taglist_fg_focus    = theme.bg_normal
theme.taglist_bg_focus    = theme.yellow
theme.taglist_fg_occupied = theme.green
theme.taglist_fg_empty    = "#414868"
theme.taglist_spacing     = 0

-- Tasklist styling
theme.tasklist_bg_focus    = theme.bg_focus
theme.tasklist_fg_focus    = theme.fg_focus
theme.tasklist_bg_normal   = theme.bg_normal
theme.tasklist_fg_normal   = theme.fg_normal
theme.tasklist_spacing     = 0

-- Notification styling
theme.notification_font = "Inter 11"
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_border_width = 1
theme.notification_border_color = theme.blue
theme.notification_margin = 10

-- Wallpaper
theme.wallpaper = gfs.get_configuration_dir() .. "wallpaper.jpg"

return theme

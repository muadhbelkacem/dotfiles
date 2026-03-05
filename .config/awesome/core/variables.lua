local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Load the theme
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local vars = {}

vars.terminal = "alacritty"
vars.editor = os.getenv("EDITOR") or "nano"
vars.editor_cmd = vars.terminal .. " -e " .. vars.editor
vars.modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.bottom,
}

return vars

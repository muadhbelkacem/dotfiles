local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local widgets = {}

-- Unified widget foreground color
local widget_fg = beautiful.fg_normal

function widgets.create_volume_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font
    awful.widget.watch('bash -c "amixer sget Master"', 2, function(w, stdout)
        local volume = stdout:match("(%d?%d?%d)%%")
        local mute = stdout:match("%[(off)%]")
        if mute then
            w:set_markup("<span foreground='" .. beautiful.fg_minimize .. "'>󰝟  MUTE</span>")
        else
            w:set_markup("<span foreground='" .. widget_fg .. "'>󰕾  " .. (volume or "0") .. "%</span>")
        end
    end, widget)
    widget:buttons(gears.table.join(
        awful.button({ }, 1, function() awful.spawn("amixer sset Master toggle") end),
        awful.button({ }, 4, function() awful.spawn("amixer sset Master 5%+") end),
        awful.button({ }, 5, function() awful.spawn("amixer sset Master 5%-") end)
    ))
    return widget
end

function widgets.create_brightness_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font
    awful.widget.watch('bash -c "brightnessctl g && brightnessctl m"', 2, function(w, stdout)
        local current = stdout:match("(%d+)\n")
        local max = stdout:match("\n(%d+)")
        if current and max then
            local percent = math.floor((tonumber(current) / tonumber(max)) * 100)
            w:set_markup("<span foreground='" .. widget_fg .. "'>󰃠   " .. percent .. "%</span>")
        else
            w:set_markup("<span foreground='" .. beautiful.fg_minimize .. "'>󰃠  --</span>")
        end
    end, widget)
    widget:buttons(gears.table.join(
        awful.button({ }, 4, function() awful.spawn("brightnessctl set 5%+") end),
        awful.button({ }, 5, function() awful.spawn("brightnessctl set 5%-") end)
    ))
    return widget
end

function widgets.create_wifi_widget(terminal)
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font
    awful.widget.watch('bash -c "nmcli -t -f active,ssid dev wifi | grep \'^yes\' | cut -d: -f2"', 5, function(w, stdout)
        local ssid = stdout:gsub("\n", "")
        if ssid == "" then
            w:set_markup("<span foreground='" .. beautiful.fg_minimize .. "'>󰤮  OFF</span>")
        else
            w:set_markup("<span foreground='" .. widget_fg .. "'>󰤨    " .. ssid .. "</span>")
        end
    end, widget)
    widget:buttons(gears.table.join(
        awful.button({ }, 1, function() awful.spawn(terminal .. " -e nmtui") end)
    ))
    return widget
end

function widgets.create_battery_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font

    local script = [[
        for bat in /sys/class/power_supply/BAT*; do
            if [ -d "$bat" ]; then
                cat "$bat/capacity" "$bat/status"
            fi
        done
    ]]

    awful.widget.watch('bash -c "' .. script .. '"', 30, function(w, stdout)
        local lines = {}
        for line in stdout:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        local battery_info = {}
        for i = 1, #lines, 2 do
            local cap = lines[i]
            local stat = lines[i+1]
            if cap and stat then
                local icon = (stat == "Charging" or stat == "Full") and "󰂄" or "󰁹"
                table.insert(battery_info, icon .. " " .. cap .. "%")
            end
        end

        local text = table.concat(battery_info, " | ")

        if text ~= "" then
            w:set_markup("<span foreground='" .. widget_fg .. "'>" .. text .. "</span>")
        else
            w:set_markup("<span foreground='" .. beautiful.fg_minimize .. "'>󰂃  --</span>")
        end
    end, widget)
    return widget
end

function widgets.create_power_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.icon_font
    widget:set_markup("<span foreground='" .. beautiful.red .. "'> </span>")
    widget:buttons(gears.table.join(
        awful.button({ }, 1, function()
            awful.spawn(gears.filesystem.get_configuration_dir() .. "powermenu.sh")
        end)
    ))
    return widget
end

function widgets.create_layout_widget(s)
    local widget = wibox.widget.textbox()
    widget.font = beautiful.icon_font

    local layout_icons = {
        tile = "󰙀 ",
        floating = "󰉈 ",
        max = "󰁌 ",
        magnifier = "󰍉 ",
        tileleft = "󰙄 ",
        tilebottom = "󰙁 ",
        tiletop = "󰙅 ",
        fairv = "󰙆 ",
        fairh = "󰙃 ",
        spiral = "󰙇 ",
        dwindle = "󰙂 ",
    }

    local function update()
        local layout = awful.layout.get(s)
        local name = layout and layout.name or "unknown"
        local icon = layout_icons[name] or name
        widget:set_markup("<span foreground='" .. widget_fg .. "'>" .. icon .. "</span>")
    end

    awful.tag.attached_connect_signal(s, "property::selected", update)
    awful.tag.attached_connect_signal(s, "property::layout", update)
    update()

    widget:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))
    return widget
end

return widgets

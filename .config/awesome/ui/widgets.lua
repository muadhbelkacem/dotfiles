local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local widgets = {}

-- Unified widget foreground color
local widget_fg = beautiful.fg_normal

-- Notification objects to allow replacing
local volume_notification
local brightness_notification
local keyboard_notification
local layout_notification

function widgets.create_separator()
    return wibox.widget {
        widget = wibox.widget.separator,
        orientation = "vertical",
        forced_width = 8,
        thickness = 1,
        color = beautiful.fg_minimize,
        span_ratio = 0.5
    }
end

function widgets.create_volume_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font

    local function update(show_notification)
        awful.spawn.easy_async_with_shell('amixer sget Master', function(stdout)
            local volume = stdout:match("(%d?%d?%d)%%")
            local mute = stdout:match("%[(off)%]")
            local display_text
            local icon
            if mute then
                display_text = "MUTE"
                icon = "󰝟 "
                widget:set_markup("<span foreground='" .. beautiful.fg_minimize .. "'>󰝟  MUTE</span>")
            else
                display_text = (volume or "0") .. "%"
                icon = "󰕾 "
                widget:set_markup("<span foreground='" .. widget_fg .. "'>󰕾  " .. display_text .. "</span>")
            end

            if show_notification then
                volume_notification = naughty.notify({
                    title = " Volume",
                    text = "<span font='" .. beautiful.icon_font .. "'>" .. icon .. "</span> " .. display_text,
                    replaces_id = volume_notification and volume_notification.id or nil,
                    timeout = 2,
                })
            end
        end)
    end

    -- Initial update and polling
    gears.timer {
        timeout = 5,
        autostart = true,
        call_now = true,
        callback = function() update(false) end
    }

    -- Immediate update on signal
    awesome.connect_signal("widgets::volume_update", function() update(true) end)

    widget:buttons(gears.table.join(
        awful.button({ }, 1, function()
            awful.spawn.easy_async("amixer sset Master toggle", function()
                awesome.emit_signal("widgets::volume_update")
            end)
        end),
        awful.button({ }, 4, function()
            awful.spawn.easy_async("amixer sset Master 5%+", function()
                awesome.emit_signal("widgets::volume_update")
            end)
        end),
        awful.button({ }, 5, function()
            awful.spawn.easy_async("amixer sset Master 5%-", function()
                awesome.emit_signal("widgets::volume_update")
            end)
        end)
    ))
    return widget
end

function widgets.create_brightness_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font

    local function update(show_notification)
        awful.spawn.easy_async_with_shell('brightnessctl g && brightnessctl m', function(stdout)
            local current = stdout:match("(%d+)\n")
            local max = stdout:match("\n(%d+)")
            if current and max then
                local percent = math.floor((tonumber(current) / tonumber(max)) * 100)
                local display_text = percent .. "%"
                local icon = "󰃠 "
                widget:set_markup("<span foreground='" .. widget_fg .. "'>󰃠   " .. display_text .. "</span>")

                if show_notification then
                    brightness_notification = naughty.notify({
                        title = " Brightness",
                        text = "<span font='" .. beautiful.icon_font .. "'>" .. icon .. "</span> " .. display_text,
                        replaces_id = brightness_notification and brightness_notification.id or nil,
                        timeout = 2,
                    })
                end
            else
                widget:set_markup("<span foreground='" .. beautiful.fg_minimize .. "'>󰃠  --</span>")
            end
        end)
    end

    -- Initial update and polling
    gears.timer {
        timeout = 5,
        autostart = true,
        call_now = true,
        callback = function() update(false) end
    }

    -- Immediate update on signal
    awesome.connect_signal("widgets::brightness_update", function() update(true) end)

    widget:buttons(gears.table.join(
        awful.button({ }, 4, function()
            awful.spawn.easy_async("brightnessctl set 5%+", function()
                awesome.emit_signal("widgets::brightness_update")
            end)
        end),
        awful.button({ }, 5, function()
            awful.spawn.easy_async("brightnessctl set 5%-", function()
                awesome.emit_signal("widgets::brightness_update")
            end)
        end)
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

        local text = table.concat(battery_info, "  ")

        if text ~= "" then
            w:set_markup("<span foreground='" .. widget_fg .. "'>" .. text .. "</span>")
        else
            w:set_markup("<span foreground='" .. beautiful.fg_minimize .. "'>󰂃  --</span>")
        end
    end, widget)
    return widget
end

function widgets.create_keyboard_layout_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font

    local function update(show_notification)
        -- Fetch only the first layout in the current setxkbmap list
        awful.spawn.easy_async_with_shell("setxkbmap -query | grep layout | awk '{print $2}' | awk -F, '{print $1}'", function(stdout)
            local layout = stdout:gsub("\n", ""):gsub("%s+", "")
            local text = layout ~= "" and layout:upper() or "??"
            -- Shorten 'ARABIC' to 'ARA' if necessary, though 'AR' is standard
            if text == "ARA" then text = "AR" end
            widget:set_markup("<span foreground='" .. widget_fg .. "'>󰌌   " .. text .. "</span>")

            if show_notification then
                keyboard_notification = naughty.notify({
                    title = " Keyboard",
                    text = "<span font='" .. beautiful.icon_font .. "'>󰌌  </span> " .. text,
                    replaces_id = keyboard_notification and keyboard_notification.id or nil,
                    timeout = 2,
                })
            end
        end)
    end

    awesome.connect_signal("xkb::group_changed", function() update(false) end)
    awesome.connect_signal("xkb::names_changed", function() update(false) end)
    awesome.connect_signal("widgets::keyboard_update", function() update(true) end)

    update(false)

    widget:buttons(gears.table.join(
        awful.button({ }, 1, function()
            -- Rotate the layout list: moves the first layout to the end
            local script = [[
                L=$(setxkbmap -query | grep layout | awk '{print $2}')
                if echo "$L" | grep -q ','; then
                    NEW=$(echo "$L" | sed 's/\([^,]*\),\(.*\)/\2,\1/')
                    setxkbmap -layout "$NEW"
                fi
            ]]
            awful.spawn.easy_async_with_shell(script, function()
                awesome.emit_signal("widgets::keyboard_update")
            end)
        end)
    ))

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
        tile = "󰙀",
        floating = "󰉈",
        max = "󰁌",
        magnifier = "󰍉",
        tileleft = "󰙄",
        tilebottom = "󰙁",
        tiletop = "󰙅",
        fairv = "󰙆",
        fairh = "󰙃",
        spiral = "󰙇",
        dwindle = "󰙂",
    }

    local function update(show_notification)
        local layout = awful.layout.get(s)
        local name = layout and layout.name or "unknown"
        local icon = layout_icons[name] or name
        -- Add spaces for the bar display
        widget:set_markup("<span foreground='" .. widget_fg .. "'> " .. icon .. " </span>")

        if show_notification then
            local display_name = name:gsub("^%l", string.upper)
            layout_notification = naughty.notify({
                title = " Layout",
                text = "<span font='" .. beautiful.icon_font .. "'>" .. icon .. "</span> " .. display_name,
                replaces_id = layout_notification and layout_notification.id or nil,
                timeout = 2,
            })
        end
    end

    awful.tag.attached_connect_signal(s, "property::selected", function() update(false) end)
    awful.tag.attached_connect_signal(s, "property::layout", function() update(true) end)
    update(false)

    widget:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))
    return widget
end

return widgets

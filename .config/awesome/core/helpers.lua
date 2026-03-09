local awful = require("awful")
local gears = require("gears")

local helpers = {}

function helpers.toggle_scratchpad(class, cmd)
    local screen = awful.screen.focused()
    local tag = screen.selected_tag
    local scratch_client = nil
    for _, c in ipairs(client.get()) do
        if c.class == class then
            scratch_client = c
            break
        end
    end

    if scratch_client then
        if scratch_client.first_tag ~= tag then
            scratch_client:move_to_tag(tag)
            scratch_client.minimized = false
            scratch_client:raise()
            client.focus = scratch_client
        else
            scratch_client.minimized = not scratch_client.minimized
            if not scratch_client.minimized then
                scratch_client:raise()
                client.focus = scratch_client
            end
        end
    else
        awful.spawn(cmd)
    end
end

function helpers.wrap_widget(widget, bg_color)
    local wibox = require("wibox")
    -- Ensure widget is a proper widget if it's a table (layout)
    local w = widget
    if type(widget) == "table" and not widget._is_widget then
        w = wibox.widget(widget)
    end

    return wibox.container.background(
        wibox.container.margin(w, 10, 10),
        bg_color,
        gears.shape.rectangle
    )
end

-- Send notification using notify-send
function helpers.send_notification(title, message, icon)
    local icon_arg = icon and string.format("-i '%s' ", icon) or ""
    awful.spawn(string.format("notify-send %s'%s' '%s'", icon_arg, title, message))
end

return helpers

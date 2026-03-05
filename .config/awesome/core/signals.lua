local awful = require("awful")
local beautiful = require("beautiful")

-- {{{ Signals
client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end

    if not awesome.startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable maximization for every window
client.connect_signal("property::maximized", function(c)
    if c.maximized then
        c.maximized = false
    end
end)
client.connect_signal("property::maximized_vertical", function(c)
    if c.maximized_vertical then
        c.maximized_vertical = false
    end
end)
client.connect_signal("property::maximized_horizontal", function(c)
    if c.maximized_horizontal then
        c.maximized_horizontal = false
    end
end)
-- }}}

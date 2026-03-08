local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
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

-- Add titlebars
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    -- Custom close button using Nerd Font icon for better look
    local close_button = wibox.widget {
        {
            {
                markup = "<span foreground='" .. beautiful.red .. "'>󰅙 </span>",
                font = beautiful.icon_font,
                align = "center",
                valign = "center",
                widget = wibox.widget.textbox
            },
            margins = 4,
            widget = wibox.container.margin,
        },
        widget = wibox.container.background
    }
    close_button:buttons(gears.table.join(
        awful.button({ }, 1, function() c:kill() end)
    ))

    awful.titlebar(c, { size = beautiful.titlebar_size or 24 }) : setup {
        { -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                margins = 4,
                widget  = wibox.container.margin
            },
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            -- You can add other buttons here if needed (minimize, maximize, etc.)
            -- awful.titlebar.widget.floatingbutton (c),
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.minimizebutton(c),
            close_button,
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}

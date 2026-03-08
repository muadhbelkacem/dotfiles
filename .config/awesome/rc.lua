-- If LuaRocks is installed, make sure that packages installed through it are found (e.g. lgi).
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- Load modular configuration
require("core.errors")
local vars = require("core.variables")
local helpers = require("core.helpers")
local widgets = require("ui.widgets")
local keys = require("core.keys")
local rules = require("core.rules")
require("core.signals")

-- {{{ Menu
local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", vars.terminal .. " -e man awesome" },
   { "edit config", vars.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}
local mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", vars.terminal }
                                  }
                        })
-- }}}

-- {{{ Wibar
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ vars.modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ vars.modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

awful.screen.connect_for_each_screen(function(s)
    -- Using Roman numerals or just clean numbers for tags
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, s, awful.layout.layouts[1])

    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = widgets.create_layout_widget(s)

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout   = { spacing = 0, layout  = wibox.layout.fixed.horizontal },
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    valign = 'center',
                    halign = 'center',
                    widget = wibox.container.place,
                },
                id     = 'background_role',
                widget = wibox.container.background,
            },
            forced_width = beautiful.wibar_height,
            widget       = wibox.container.background, -- Placeholder to maintain square shape
        },
    }

    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = { shape = gears.shape.rectangle },
        layout   = { spacing = 4, layout  = wibox.layout.fixed.horizontal },
        widget_template = {
            {
                {
                    { id = 'icon_role', widget = wibox.widget.imagebox },
                    margins = 6,
                    widget  = wibox.container.margin,
                },
                id     = 'background_role',
                widget = wibox.container.background,
            },
            layout = wibox.layout.fixed.horizontal,
        },
    }

    s.mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.wibar_height, bg = beautiful.bg_normal })

    local clock_widget = wibox.widget.textclock("<span foreground='" .. beautiful.fg_normal .. "'>󰥔   %H:%M</span>")

    -- Systray visibility handling: hide the systray and its separator when no icons are present
    local systray = wibox.widget.systray()
    local systray_with_sep = wibox.widget {
        systray,
        widgets.create_separator(),
        layout = wibox.layout.fixed.horizontal,
    }
    systray_with_sep.visible = awesome.systray() > 0
    systray:connect_signal("widget::redraw_needed", function()
        systray_with_sep.visible = awesome.systray() > 0
    end)

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        { -- Middle widget
            layout = wibox.layout.flex.horizontal,
            s.mytasklist,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            helpers.wrap_widget({
                layout = wibox.layout.fixed.horizontal,
                systray_with_sep,
                widgets.create_wifi_widget(vars.terminal),
                widgets.create_separator(),
                widgets.create_keyboard_layout_widget(),
                widgets.create_separator(),
                widgets.create_battery_widget(),
                widgets.create_separator(),
                widgets.create_brightness_widget(),
                widgets.create_separator(),
                widgets.create_volume_widget(),
                widgets.create_separator(),
                clock_widget,
                widgets.create_separator(),
                s.mylayoutbox,
                widgets.create_separator(),
                widgets.create_power_widget(),
            }, beautiful.bg_focus),
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
root.keys(keys.get_globalkeys(vars, helpers))
-- }}}

-- {{{ Rules
awful.rules.rules = rules.get(keys.clientkeys(vars), keys.clientbuttons(vars))
-- }}}

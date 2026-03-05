-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.max,
}
-- }}}

-- {{{ Helper functions
local function create_volume_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font
    awful.widget.watch('bash -c "amixer sget Master"', 2, function(w, stdout)
        local volume = stdout:match("(%d?%d?%d)%%")
        local mute = stdout:match("%[(off)%]")
        if mute then
            w:set_markup("<span foreground='" .. beautiful.red .. "'>󰝟  MUTE</span>")
        else
            w:set_markup("<span foreground='" .. beautiful.blue .. "'>󰕾  " .. (volume or "0") .. "%</span>")
        end
    end, widget)
    widget:buttons(gears.table.join(
        awful.button({ }, 1, function() awful.spawn("amixer sset Master toggle") end),
        awful.button({ }, 4, function() awful.spawn("amixer sset Master 5%+") end),
        awful.button({ }, 5, function() awful.spawn("amixer sset Master 5%-") end)
    ))
    return widget
end

local function create_brightness_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font
    awful.widget.watch('bash -c "brightnessctl g && brightnessctl m"', 2, function(w, stdout)
        local current = stdout:match("(%d+)\n")
        local max = stdout:match("\n(%d+)")
        if current and max then
            local percent = math.floor((tonumber(current) / tonumber(max)) * 100)
            w:set_markup("<span foreground='" .. beautiful.yellow .. "'>󰃠   " .. percent .. "%</span>")
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

local function create_wifi_widget()
    local widget = wibox.widget.textbox()
    widget.font = beautiful.font
    awful.widget.watch('bash -c "nmcli -t -f active,ssid dev wifi | grep \'^yes\' | cut -d: -f2"', 5, function(w, stdout)
        local ssid = stdout:gsub("\n", "")
        if ssid == "" then
            w:set_markup("<span foreground='" .. beautiful.red .. "'>󰤮  OFF</span>")
        else
            w:set_markup("<span foreground='" .. beautiful.green .. "'>󰤨    " .. ssid .. "</span>")
        end
    end, widget)
    widget:buttons(gears.table.join(
        awful.button({ }, 1, function() awful.spawn(terminal .. " -e nmtui") end)
    ))
    return widget
end

local function wrap_widget(widget, bg_color)
    return wibox.container.background(
        wibox.container.margin(widget, 10, 10),
        bg_color,
        gears.shape.rectangle -- Explicitly no curves
    )
end

local function toggle_scratchpad(class, cmd)
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

-- }}}

-- {{{ Menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
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
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
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
                                          end))

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    -- Using Roman numerals or just clean numbers for tags
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style   = { shape = gears.shape.rectangle },
        layout   = { layout  = wibox.layout.fixed.horizontal },
        widget_template = {
            {
                {
                    { id = 'text_role', widget = wibox.widget.textbox },
                    left  = 14, right = 14, widget = wibox.container.margin,
                },
                id     = 'background_role',
                widget = wibox.container.background,
            },
            layout = wibox.layout.fixed.horizontal,
        },
    }

    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {
            shape = gears.shape.rectangle,
        },
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

    local clock_widget = wibox.widget.textclock("<span foreground='" .. beautiful.magenta .. "'>󰃭   %H:%M</span>")

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
            spacing = 0,
            wibox.container.margin(wibox.widget.systray(), 8, 8),
            wrap_widget(create_wifi_widget(), beautiful.bg_normal),
            wrap_widget(create_brightness_widget(), beautiful.bg_normal),
            wrap_widget(create_volume_widget(), beautiful.bg_normal),
            wrap_widget(clock_widget, beautiful.bg_focus),
            wrap_widget(s.mylayoutbox, beautiful.bg_minimize),
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
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "z", function () toggle_scratchpad("scratchpad", terminal .. " --class scratchpad") end,
              {description = "toggle scratchpad", group = "launcher"}),
    awful.key({ modkey,           }, "e", function () toggle_scratchpad("file-manager", terminal .. " --class file-manager -e yazi") end,
              {description = "toggle file manager scratchpad", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  if c then
                    c:emit_signal("request::activate", "key.unminimize", {raise = true})
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp", function () awful.spawn("brightnessctl set 5%+") end),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.spawn("brightnessctl set 5%-") end),

    -- Volume
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn("amixer sset Master 5%+") end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn("amixer sset Master 5%-") end),
    awful.key({ }, "XF86AudioMute", function () awful.spawn("amixer sset Master toggle") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.spawn.with_shell("rofi -show drun") end,
              {description = "toggle rofi", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey }, "p", function() awful.spawn(gears.filesystem.get_configuration_dir() .. "powermenu.sh") end,
              {description = "show power menu", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            c.minimized = true
        end ,
        {description = "minimize", group = "client"})
    -- awful.key({ modkey,           }, "m",
    --     function (c)
    --         c.maximized = not c.maximized
    --         c:raise()
    --     end ,
    --     {description = "(un)maximize", group = "client"})
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     maximized = false,
                     maximized_vertical = false,
                     maximized_horizontal = false
     }
    },
    { rule_any = {
        class = { "Arandr", "Blueman-manager", "Gpick", "Sxiv", "Wpa_gui" },
      }, properties = { floating = true }},
    { rule_any = { class = { "scratchpad", "file-manager" } },
      properties = { floating = true, placement = awful.placement.centered } },
}
-- }}}

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

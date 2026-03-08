local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local keys = {}

function keys.get_globalkeys(vars, helpers)
    local globalkeys = gears.table.join(
        awful.key({ vars.modkey,           }, "z",      hotkeys_popup.show_help,
                  {description="show help", group="awesome"}),
        awful.key({ vars.modkey,           }, "Left",   awful.tag.viewprev,
                  {description = "view previous", group = "tag"}),
        awful.key({ vars.modkey,           }, "Right",  awful.tag.viewnext,
                  {description = "view next", group = "tag"}),
        awful.key({ vars.modkey,           }, "Escape", awful.tag.history.restore,
                  {description = "go back", group = "tag"}),

        awful.key({ vars.modkey,           }, "j",
            function ()
                awful.client.focus.byidx( 1)
            end,
            {description = "focus next by index", group = "client"}
        ),
        awful.key({ vars.modkey,           }, "k",
            function ()
                awful.client.focus.byidx(-1)
            end,
            {description = "focus previous by index", group = "client"}
        ),

        -- Layout manipulation
        awful.key({ vars.modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
                  {description = "swap with next client by index", group = "client"}),
        awful.key({ vars.modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
                  {description = "swap with previous client by index", group = "client"}),
        awful.key({ vars.modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
                  {description = "focus the next screen", group = "screen"}),
        awful.key({ vars.modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
                  {description = "focus the previous screen", group = "screen"}),
        awful.key({ vars.modkey,           }, "u", awful.client.urgent.jumpto,
                  {description = "jump to urgent client", group = "client"}),
        awful.key({ vars.modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            {description = "go back", group = "client"}),

        -- Standard program
        awful.key({ vars.modkey,           }, "Return", function () awful.spawn(vars.terminal) end,
                  {description = "open a terminal", group = "launcher"}),
        awful.key({ vars.modkey,           }, "s", function () helpers.toggle_scratchpad("scratchpad", vars.terminal .. " --class scratchpad") end,
                  {description = "toggle scratchpad", group = "launcher"}),
        awful.key({ vars.modkey,           }, "e", function () helpers.toggle_scratchpad("file-manager", vars.terminal .. " --class file-manager -e yazi") end,
                  {description = "toggle file manager scratchpad", group = "launcher"}),
        awful.key({ vars.modkey, "Control" }, "r", awesome.restart,
                  {description = "reload awesome", group = "awesome"}),
        awful.key({ vars.modkey, "Shift"   }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"}),

        awful.key({ vars.modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
                  {description = "increase master width factor", group = "layout"}),
        awful.key({ vars.modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
                  {description = "decrease master width factor", group = "layout"}),
        awful.key({ vars.modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
                  {description = "increase the number of master clients", group = "layout"}),
        awful.key({ vars.modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
                  {description = "decrease the number of master clients", group = "layout"}),
        awful.key({ vars.modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
                  {description = "increase the number of columns", group = "layout"}),
        awful.key({ vars.modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
                  {description = "decrease the number of columns", group = "layout"}),

        -- Window layout change
        awful.key({ vars.modkey, "Shift"   }, "Tab",   function () awful.layout.inc( 1)                end,
                  {description = "select next layout", group = "layout"}),

        -- Keyboard layout change (Rotates through en, ara, fr)
        awful.key({ vars.modkey,           }, "space", function ()
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
        end, {description = "change keyboard layout", group = "layout"}),

        awful.key({ vars.modkey, "Control" }, "n",
                  function ()
                      local c = awful.client.restore()
                      if c then
                        c:emit_signal("request::activate", "key.unminimize", {raise = true})
                      end
                  end,
                  {description = "restore minimized", group = "client"}),

        -- Brightness
        awful.key({ }, "XF86MonBrightnessUp", function ()
            awful.spawn.easy_async("brightnessctl set 5%+", function()
                awesome.emit_signal("widgets::brightness_update")
            end)
        end, {description = "increase brightness", group = "hotkeys"}),
        awful.key({ }, "XF86MonBrightnessDown", function ()
            awful.spawn.easy_async("brightnessctl set 5%-", function()
                awesome.emit_signal("widgets::brightness_update")
            end)
        end, {description = "decrease brightness", group = "hotkeys"}),

        -- Volume
        awful.key({ }, "XF86AudioRaiseVolume", function ()
            awful.spawn.easy_async("amixer sset Master 5%+", function()
                awesome.emit_signal("widgets::volume_update")
            end)
        end, {description = "increase volume", group = "hotkeys"}),
        awful.key({ }, "XF86AudioLowerVolume", function ()
            awful.spawn.easy_async("amixer sset Master 5%-", function()
                awesome.emit_signal("widgets::volume_update")
            end)
        end, {description = "decrease volume", group = "hotkeys"}),
        awful.key({ }, "XF86AudioMute", function ()
            awful.spawn.easy_async("amixer sset Master toggle", function()
                awesome.emit_signal("widgets::volume_update")
            end)
        end, {description = "mute volume", group = "hotkeys"}),

        -- Mod + I / Mod + Shift + I for Volume
        awful.key({ vars.modkey }, "i", function ()
            awful.spawn.easy_async("amixer sset Master 5%+", function()
                awesome.emit_signal("widgets::volume_update")
            end)
        end, {description = "increase volume", group = "hotkeys"}),
        awful.key({ vars.modkey, "Shift" }, "i", function ()
            awful.spawn.easy_async("amixer sset Master 5%-", function()
                awesome.emit_signal("widgets::volume_update")
            end)
        end, {description = "decrease volume", group = "hotkeys"}),

        -- Prompt
        awful.key({ vars.modkey },            "r",     function () awful.spawn.with_shell("pkill rofi || rofi -show drun") end,
                  {description = "toggle rofi", group = "launcher"}),

        awful.key({ vars.modkey }, "x",
                  function ()
                      awful.prompt.run {
                        prompt       = "Run Lua code: ",
                        textbox      = awful.screen.focused().mypromptbox.widget,
                        exe_callback = awful.util.eval,
                        history_path = awful.util.get_cache_dir() .. "/history_eval"
                      }
                  end,
                  {description = "lua execute prompt", group = "awesome"}),

        awful.key({ vars.modkey }, "p", function() awful.spawn(gears.filesystem.get_configuration_dir() .. "powermenu.sh") end,
                  {description = "show power menu", group = "launcher"})
    )

    for i = 1, 10 do
        globalkeys = gears.table.join(globalkeys,
            awful.key({ vars.modkey }, "#" .. i + 9,
                      function ()
                            local screen = awful.screen.focused()
                            local tag = screen.tags[i]
                            if tag then
                               tag:view_only()
                            end
                      end,
                      {description = "view tag #"..i, group = "tag"}),
            awful.key({ vars.modkey, "Control" }, "#" .. i + 9,
                      function ()
                          local screen = awful.screen.focused()
                          local tag = screen.tags[i]
                          if tag then
                             awful.tag.viewtoggle(tag)
                          end
                      end,
                      {description = "toggle tag #" .. i, group = "tag"}),
            awful.key({ vars.modkey, "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus then
                              local tag = client.focus.screen.tags[i]
                              if tag then
                                  client.focus:move_to_tag(tag)
                              end
                         end
                      end,
                      {description = "move focused client to tag #"..i, group = "tag"}),
            awful.key({ vars.modkey, "Control", "Shift" }, "#" .. i + 9,
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
    return globalkeys
end

function keys.clientkeys(vars)
    return gears.table.join(
        awful.key({ vars.modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ vars.modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
                  {description = "close", group = "client"}),
        awful.key({ vars.modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                  {description = "toggle floating", group = "client"}),
        awful.key({ vars.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                  {description = "move to master", group = "client"}),
        awful.key({ vars.modkey,           }, "o",      function (c) c:move_to_screen()               end,
                  {description = "move to screen", group = "client"}),
        awful.key({ vars.modkey,           }, "t",      function (c) c.ontop = not f.ontop            end,
                  {description = "toggle keep on top", group = "client"}),
        awful.key({ vars.modkey,           }, "n",
            function (c)
                c.minimized = true
            end ,
            {description = "minimize", group = "client"})
    )
end

function keys.clientbuttons(vars)
    return gears.table.join(
        awful.button({ }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),
        awful.button({ vars.modkey }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ vars.modkey }, 3, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )
end

return keys

local awful = require("awful")
local beautiful = require("beautiful")

local rules = {}

function rules.get(clientkeys, clientbuttons)
    return {
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
                         maximized_horizontal = false,
                         titlebars_enabled = true
         }
        },
        { rule_any = {
            class = { "Arandr", "Blueman-manager", "Gpick", "Sxiv", "Wpa_gui" },
          }, properties = { floating = true }},
        { rule_any = { class = { "scratchpad", "file-manager" } },
          properties = {
              floating = true,
              placement = function(c)
                  local wa = c.screen.workarea
                  c:geometry({
                      width = wa.width * 0.95,
                      height = wa.height * 0.9
                  })
                  awful.placement.centered(c, { honor_workarea = true })
              end
          }
        },
    }
end

return rules

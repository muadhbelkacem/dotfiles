# Modern palette
colors = [
    ["#282c34", "#282c34"], # 0: background
    ["#bbc2cf", "#bbc2cf"], # 1: foreground
    ["#ff6c6b", "#ff6c6b"], # 2: red
    ["#98be65", "#98be65"], # 3: green
    ["#da8548", "#da8548"], # 4: orange
    ["#51afef", "#51afef"], # 5: blue
    ["#c678dd", "#c678dd"], # 6: magenta
    ["#46d9ff", "#46d9ff"], # 7: cyan
    ["#a9a1e1", "#a9a1e1"], # 8: violet
    ["#21242b", "#21242b"], # 9: dark background
]

widget_colors = {
    "CapsNumLockIndicator": colors[4][0],
    "Volume": colors[5][0],
    "Net": colors[3][0],
    "Wlan": colors[3][0],
    "Backlight": colors[7][0],
    "KeyboardLayout": colors[8][0],
    "Battery": colors[6][0],
    "Clock": colors[1][0],
    "QuickExit": colors[2][0],
}

border_focus_color = colors[5][0]
border_normal_color = colors[0][0]
background_color = colors[9][0]
foreground_color = colors[1][0]

from libqtile.config import Group, ScratchPad, DropDown, Key
from libqtile.lazy import lazy

from .constants import mod
from .keys import keys
from .scratchpads import scratchpads


groups = [Group(i) for i in "qwertyuiop"]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )
groups += scratchpads

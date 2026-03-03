from libqtile.config import ScratchPad, DropDown
from .constants import terminal

scratchpads = [
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term1",
                terminal,
                width=0.9,
                height=0.8,
                x=0.05,
                y=0.1,
                opacity=0.9,
            ),
            DropDown(
                "term2",
                terminal,
                width=0.9,
                height=0.8,
                x=0.05,
                y=0.1,
                opacity=0.9,
            ),
            DropDown(
                "file_manager",
                "alacritty -e yazi",
                width=0.9,
                height=0.8,
                x=0.05,
                y=0.1,
                opacity=0.9,
            ),
        ],
    )
]

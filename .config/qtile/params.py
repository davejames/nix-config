from libqtile import layout

from tools import Config, ColourScheme


colour_scheme = ColourScheme(
    "#282c34",
    "#1c1f24",
    "#dfdfdf",
    "#ff6c6b",
    "#98be65",
    "#da8548",
    "#51afef",
    "#c678dd",
    "#46d9ff",
    "#a9a1e1",
)

layout_defaults = {
    "margin": 8,
    "border_width": 2,
}

all_layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], **layout_defaults),
    layout.Max(**layout_defaults),
    # Try more layouts by unleashing below layouts.
    layout.Stack(num_stacks=2, **layout_defaults),
    layout.Bsp(**layout_defaults),
    layout.Matrix(**layout_defaults),
    layout.MonadTall(**layout_defaults),
    layout.MonadWide(**layout_defaults),
    layout.RatioTile(**layout_defaults),
    layout.Tile(**layout_defaults),
    layout.TreeTab(**layout_defaults),
    layout.VerticalTile(**layout_defaults),
    layout.Zoomy(**layout_defaults),
]

filtered_layouts = [
    layout.MonadTall(**layout_defaults),
    layout.Max(**layout_defaults),
    layout.TreeTab(**layout_defaults),
]

config = Config(
    mod="mod4",
    terminal="alacritty",
    colour_scheme=colour_scheme,
    default_margin=4,
    default_border_width=2,
    layouts=all_layouts,
)

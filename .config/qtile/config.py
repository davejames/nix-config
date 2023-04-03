# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import subprocess
import os

from libqtile import bar, layout, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.layout import RatioTile

from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration

mod = "mod4"
terminal = "kitty"


@lazy.function
def get_grow_method(direction, *args):
    current_layout = qtile.current_layout
    if isinstance(current_layout, RatioTile):
        if direction == "left":
            return current_layout.cmd_grow_left
        elif direction == "right":
            return current_layout.cmd_grow_right
        elif direction == "up":
            return current_layout.cmd_grow_up
        elif direction == "down":
            return current_layout.cmd_grow_down
    else:
        if direction == "left":
            return lazy.layout.grow_left()
        elif direction == "right":
            return lazy.layout.grow_right()
        elif direction == "up":
            return lazy.layout.grow_up()
        elif direction == "down":
            return lazy.layout.grow_down()


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    # Key([mod, "control"], "h", get_grow_method("left"), desc="Grow window to the left"),
    # Key([mod, "control"], "l", get_grow_method("right"), desc="Grow window to the right"),
    # Key([mod, "control"], "j", get_grow_method("down"), desc="Grow window down"),
    # Key([mod, "control"], "k", get_grow_method("up"), desc="Grow window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Custom keybindings
    Key([mod, "shift"], "l", lazy.spawn("betterlockscreen -l"), desc="Lock screen"),

]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

default_margin = 4
default_border_width = 2

layouts = [
    layout.Columns(
        border_focus_stack=["#d75f5f", "#8f3d3d"],
        border_width=default_border_width,
        margin=default_margin,
    ),
    layout.Max(margin=default_margin, border_width=default_border_width),
    # Try more layouts by unleashing below layouts.
    layout.Stack(num_stacks=2, border_width=default_border_width),
    layout.Bsp(margin=default_margin, border_width=default_border_width),
    layout.Matrix(margin=default_margin, border_width=default_border_width),
    layout.MonadTall(border_width=default_border_width),
    layout.MonadWide(border_width=default_border_width),
    layout.RatioTile(margin=default_margin, border_width=default_border_width),
    layout.Tile(margin=default_margin, border_width=default_border_width),
    layout.TreeTab(margin=default_margin, border_width=default_border_width),
    layout.VerticalTile(margin=default_margin, border_width=default_border_width),
    layout.Zoomy(margin=default_margin, border_width=default_border_width),
]

colours = [
    ["#282c34", "#282c34"],
    ["#1c1f24", "#1c1f24"],
    ["#dfdfdf", "#dfdfdf"],
    ["#ff6c6b", "#ff6c6b"],
    ["#98be65", "#98be65"],
    ["#da8548", "#da8548"],
    ["#51afef", "#51afef"],
    ["#c678dd", "#c678dd"],
    ["#46d9ff", "#46d9ff"],
    ["#a9a1e1", "#a9a1e1"],
]

widget_defaults = dict(
    font="Ubuntu Bold", fontsize=12, padding=3, background=colours[1]
)

extension_defaults = widget_defaults.copy()

# Use xrandr output to see what monitors are available
xrandr_output = subprocess.check_output("xrandr").decode()
connected_monitors = [
    line.split()[0] for line in xrandr_output.splitlines() if " connected" in line
]
primary_line = [line for line in xrandr_output.splitlines() if "primary" in line]
primary_monitor = primary_line and primary_line[0].split()[0]

# Add a status bar to each monitor
screens = []


def generate_bar_elements(monitor_name, show_systray):
    bar_elements = [
        widget.Image(
            filename="~/.config/qtile/icons/terminal.png",
            scale="True",
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(terminal)},
        ),
        widget.CurrentLayout(),
        widget.GroupBox(),
        widget.Prompt(),
        widget.WindowName(),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        widget.TextBox(
            monitor_name,
            name="monitor",
            foreground=colours[1],
            background=colours[7 if primary_monitor else 2],
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("arandr")},

        ),
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colours[1],
            background=colours[1],
        ),
        # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
        widget.Systray(icon_size=20)
        if show_systray
        else widget.Sep(
            linewidth=0,
            padding=0,
            foreground=colours[1],
            background=colours[1],
        ),
        # widget.Systray() if show_systray else None,
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colours[1],
            background=colours[1],
        ),
        widget.Clock(
            format="%Y-%m-%d %a %I:%M %p",
            foreground=colours[4],
            background=colours[0],
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colours[1],
            background=colours[1],
        ),
        # widget.Wlan(
        #     interface="wlo1",
        #     format="Wifi {down} ↓↑ {up}",
        #     foreground=colours[5],
        #     background=colours[0],
        #     padding=5,
        #     decorations=[
        #         BorderDecoration(
        #             colour=colours[6],
        #             border_width=[0, 0, 2, 0],
        #             padding_x=5,
        #             padding_y=None,
        #         )
        #     ],
        # ),
        widget.Net(
            interface="wlo1",
            format="Wifi {down} ↓↑ {up}",
            foreground=colours[5],
            background=colours[0],
            padding=5,
            decorations=[
                BorderDecoration(
                    colour=colours[6],
                    border_width=[0, 0, 2, 0],
                    padding_x=5,
                    padding_y=None,
                )
            ],
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colours[1],
            background=colours[1],
        ),
        widget.Battery(
            foreground=colours[6],
            background=colours[0],
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colours[1],
            background=colours[1],
        ),
        widget.QuickExit(
            foreground=colours[7],
            background=colours[0],
        ),
    ]
    # if not show_systray:
    #     bar_elements.pop(-10)
    return bar_elements


for i, connected_monitor in enumerate(connected_monitors):
    if primary_monitor:
        show_systray = connected_monitor == primary_monitor
    else:
        show_systray = i == 0
    screens.append(
        Screen(
            bottom=bar.Bar(
                generate_bar_elements(
                    monitor_name=connected_monitor, show_systray=show_systray
                ),
                24,
                monitor=connected_monitor
                # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
                # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
            ),
        ),
    )

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


@hook.subscribe.startup_once
def start_once():
    """Run after qtile is started"""

    autostart_file = os.path.expanduser("~/.config/qtile/startup.sh")
    subprocess.call([autostart_file])

import os

from libqtile import qtile
from libqtile.lazy import lazy

from qtile_extras import widget


def generate_bar_elements(
    config,
    colour_scheme,
    monitor_name,
    monitor_is_primary,
    sep_padding,
    icon_padding,
    widget_padding,
):
    col_scheme_vals = {
        "gradient": True,
        "idx": 14 if monitor_is_primary else 13,
    }

    base_colour = colour_scheme.col(1, gradient=True)

    bar_elements = [
        # Terminal Icon
        widget.Sep(
            linewidth=0,
            padding=int(sep_padding * 4.5),
            foreground=base_colour,
            background=base_colour,
        ),
        widget.Image(
            filename="~/.config/qtile/icons/robot.png",
            scale=0.7,
            padding=icon_padding,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(config.terminal)},
            foreground=base_colour,
            background=base_colour,
        ),
        widget.Sep(
            linewidth=0,
            padding=int(sep_padding * 4.5),
            foreground=base_colour,
            background=base_colour,
        ),
        # Layout switcher
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            foreground=colour_scheme.col(4, gradient=False),
            background=colour_scheme.col(0),
            padding=icon_padding,
            scale=0.7,
        ),
        widget.CurrentLayout(
            foreground=colour_scheme.col(4, gradient=False),
            background=colour_scheme.col(0),
            padding=widget_padding,
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=base_colour,
            background=base_colour,
        ),
        # Workspaces
        widget.GroupBox(
            fontsize=8,
            rounded=True,
            foreground=colour_scheme.col(4, gradient=False),
            background=base_colour,
            active=colour_scheme.col(6, gradient=False),
            inactive=colour_scheme.col(2, gradient=False),
            this_current_screen_border=colour_scheme.col(8),
            other_current_screen_border=colour_scheme.col(2),
            highlight_method="block",
        ),
        # Window Name
        widget.WindowName(
            padding=widget_padding,
            background=base_colour,
        ),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        # CPU Graph
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf2db",
            padding=icon_padding,
            foreground=colour_scheme.col(9, gradient=False),
            background=colour_scheme.col(0),
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(config.terminal + " htop")
            },
        ),
        widget.CPUGraph(
            graph_color=colour_scheme.col(9, gradient=False),
            background=colour_scheme.col(0),
            padding=widget_padding,
            border_width=0,
            line_width=1,
            mouse_callbacks={
                "Button1": lazy.group['scratchpad'].dropdown_toggle('btop')
            },
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=base_colour,
            background=base_colour,
        ),
        # Display the monitor name
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\ue163",
            padding=icon_padding,
            foreground=colour_scheme.col(7, gradient=False),
            background=colour_scheme.col(**col_scheme_vals),
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("arandr")},
        ),
        widget.TextBox(
            monitor_name,
            name="monitor",
            padding=widget_padding,
            foreground=colour_scheme.col(7, gradient=False),
            background=colour_scheme.col(**col_scheme_vals),
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("arandr")},
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=base_colour,
            background=base_colour,
        ),
        # Clock
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf017",
            padding=icon_padding,
            foreground=colour_scheme.col(7, gradient=False),
            background=colour_scheme.col(8),
        ),
        widget.Clock(
            format="%Y-%m-%d %H:%M:%S",
            padding=widget_padding,
            foreground=colour_scheme.col(7, gradient=False),
            background=colour_scheme.col(8),
            mouse_callbacks={
                "Button1": lazy.group['scratchpad'].dropdown_toggle('khal')
            },
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=base_colour,
            background=base_colour,
        ),
        # Network Speed
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf6ff",
            padding=icon_padding,
            foreground=colour_scheme.col(7, gradient=False),
            background=colour_scheme.col(13),
            # mouse_callbacks={"Button1": lambda: rotate_net_interface()},
        ),
        widget.Net(
            interface="wlo1",
            format="Wifi {down} ↓↑ {up}",
            padding=widget_padding,
            foreground=colour_scheme.col(7, gradient=False),
            background=colour_scheme.col(13),
            width=180,
            # mouse_callbacks={"Button1": lambda: rotate_net_interface()},
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=base_colour,
            background=base_colour,
        ),
        # Battery
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf5df",
            padding=icon_padding,
            foreground=colour_scheme.col(7, gradient=False),
            background=colour_scheme.col(14),
        ),
        widget.Battery(
            foreground=colour_scheme.col(7, gradient=False),
            background=colour_scheme.col(14),
            padding=widget_padding,
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=base_colour,
            background=base_colour,
        ),
        # Systray
        # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
        # Systray can only be displayed once, so it is only displayed on the primary display
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf053",
            padding=icon_padding,
            foreground=colour_scheme.col(8, gradient=False),
            background=colour_scheme.col(0),
        ),
        widget.Systray(
            icon_size=20,
            padding=widget_padding,
            foreground=colour_scheme.col(8, gradient=False),
            background=colour_scheme.col(0),
        )
        if monitor_is_primary
        else widget.Sep(
            linewidth=0,
            padding=0,
            foreground=base_colour,
            background=base_colour,
        ),
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf054",
            padding=icon_padding,
            foreground=colour_scheme.col(8, gradient=False),
            background=colour_scheme.col(0),
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=base_colour,
            background=base_colour,
        ),
        # Log off
        widget.QuickExit(
            foreground=colour_scheme.col(8, gradient=False),
            background=colour_scheme.col(0),
            padding=widget_padding,
        ),
    ]
    return bar_elements

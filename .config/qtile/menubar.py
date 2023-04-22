import os

from libqtile import qtile

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
        "gradient": False,
        "idx": 7 if monitor_is_primary else 2,
    }

    bar_elements = [
        # Terminal Icon
        widget.Sep(
            linewidth=0,
            padding=int(sep_padding * 1.5),
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        widget.Image(
            filename="~/.config/qtile/icons/robot.png",
            scale=0.7,
            padding=icon_padding,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(config.terminal)},
        ),
        widget.Sep(
            linewidth=0,
            padding=int(sep_padding * 1.5),
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        # Layout switcher
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            foreground=colour_scheme.col(2, gradient=False),
            background=colour_scheme.col(0, gradient=False),
            padding=icon_padding,
            scale=0.7,
        ),
        widget.CurrentLayout(
            foreground=colour_scheme.col(2, gradient=False),
            background=colour_scheme.col(0, gradient=False),
            padding=widget_padding,
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        # Workspaces
        widget.GroupBox(
            fontsize=8,
            rounded=True,
            this_current_screen_border=colour_scheme.col(3),
            other_current_screen_border=colour_scheme.col(5),
            highlight_method="block",
        ),
        # widget.Prompt(),
        # Window Name
        widget.WindowName(
            padding=widget_padding,
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
            background=colour_scheme.col(0, gradient=False),
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(config.terminal + " htop")
            },
        ),
        widget.CPUGraph(
            graph_color=colour_scheme.col(9, gradient=False),
            background=colour_scheme.col(0, gradient=False),
            padding=widget_padding,
            border_width=0,
            line_width=1,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(config.terminal + " htop")
            },
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        # Display the monitor name
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\ue163",
            padding=icon_padding,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(**col_scheme_vals),
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("arandr")},
        ),
        widget.TextBox(
            monitor_name,
            name="monitor",
            padding=widget_padding,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(**col_scheme_vals),
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("arandr")},
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        # Clock
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf017",
            padding=icon_padding,
            foreground=colour_scheme.col(4, gradient=False),
            background=colour_scheme.col(0, gradient=False),
        ),
        widget.Clock(
            format="%Y-%m-%d %H:%M:%S",
            padding=widget_padding,
            foreground=colour_scheme.col(4, gradient=False),
            background=colour_scheme.col(0, gradient=False),
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        # Network Speed
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf6ff",
            padding=icon_padding,
            foreground=colour_scheme.col(5, gradient=False),
            background=colour_scheme.col(0, gradient=False),
            # mouse_callbacks={"Button1": lambda: rotate_net_interface()},
        ),
        widget.Net(
            interface="wlo1",
            format="Wifi {down} ↓↑ {up}",
            padding=widget_padding,
            foreground=colour_scheme.col(5, gradient=False),
            background=colour_scheme.col(0, gradient=False),
            width=180,
            # mouse_callbacks={"Button1": lambda: rotate_net_interface()},
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        # Battery
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf5df",
            padding=icon_padding,
            foreground=colour_scheme.col(6, gradient=False),
            background=colour_scheme.col(0, gradient=False),
        ),
        widget.Battery(
            foreground=colour_scheme.col(6, gradient=False),
            background=colour_scheme.col(0, gradient=False),
            padding=widget_padding,
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        # Systray
        # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
        # Systray can only be displayed once, so it is only displayed on the primary display
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf053",
            padding=icon_padding,
            foreground=colour_scheme.col(8, gradient=False),
            background=colour_scheme.col(0, gradient=False),
        ),
        widget.Systray(
            icon_size=20,
            padding=widget_padding,
            foreground=colour_scheme.col(8, gradient=False),
            background=colour_scheme.col(0, gradient=False),
        )
        if monitor_is_primary
        else widget.Sep(
            linewidth=0,
            padding=0,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        widget.TextBox(
            font="Font Awesome 6 Free",
            text="\uf054",
            padding=icon_padding,
            foreground=colour_scheme.col(8, gradient=False),
            background=colour_scheme.col(0, gradient=False),
        ),
        widget.Sep(
            linewidth=0,
            padding=sep_padding,
            foreground=colour_scheme.col(1, gradient=False),
            background=colour_scheme.col(1, gradient=False),
        ),
        # Log off
        widget.QuickExit(
            foreground=colour_scheme.col(7, gradient=False),
            background=colour_scheme.col(0, gradient=False),
            padding=widget_padding,
        ),
    ]
    return bar_elements

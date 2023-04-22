from libqtile import extension
from libqtile.config import Key, Drag, Click
from libqtile.lazy import lazy


def init_keybindings(config):
    mod = config.mod
    terminal = config.terminal

    config.update_keybindings(
        [
            # Standard / Default keys
            # https://docs.qtile.org/en/latest/manual/config/lazy.html
            # Switch between windows
            Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
            Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
            Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
            Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
            Key(
                [mod],
                "space",
                lazy.layout.next(),
                desc="Move window focus to other window",
            ),
            # Move windows between left/right columns or move up/down in current stack.
            # Moving out of range in Columns layout will create new column.
            Key(
                [mod, "shift"],
                "h",
                lazy.layout.shuffle_left(),
                desc="Move window to the left",
            ),
            Key(
                [mod, "shift"],
                "l",
                lazy.layout.shuffle_right(),
                desc="Move window to the right",
            ),
            Key(
                [mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"
            ),
            Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
            Key([mod], "i", lazy.layout.grow()),
            Key([mod], "m", lazy.layout.shrink()),
            Key([mod], "n", lazy.layout.normalize()),
            Key([mod], "o", lazy.layout.maximize()),
            Key([mod, "shift"], "space", lazy.layout.flip()),
            Key([mod, "control"], "tab", lazy.layout.swap_main()),
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
            Key(
                [mod],
                "r",
                lazy.spawncmd(),
                desc="Spawn a command using a prompt widget",
            ),
            # Custom keybindings
            Key(
                [mod, "control"],
                "l",
                lazy.spawn("betterlockscreen -l"),
                desc="Lock screen",
            ),
            Key(
                [mod],
                "p",
                lazy.spawn("rofi -show"),
                desc="Launch Application",
            ),
            Key(
                [mod],
                "z",
                lazy.window.bring_to_front(),
            ),
            Key(
                [mod],
                "f",
                lazy.window.toggle_floating(),
                desc="Toggle floating",
            ),
        ]
    )


def init_mousebindings(config):
    mod = config.mod
    config.update_mousebindings(
        [
            Drag(
                [mod],
                "Button1",
                lazy.window.set_position_floating(),
                start=lazy.window.get_position(),
            ),
            Drag(
                [mod],
                "Button3",
                lazy.window.set_size_floating(),
                start=lazy.window.get_size(),
            ),
            Click([mod], "Button2", lazy.window.bring_to_front()),
        ]
    )

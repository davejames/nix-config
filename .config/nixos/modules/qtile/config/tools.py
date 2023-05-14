import subprocess
import codecs
import re
import random
from pathlib import Path

from libqtile import bar
from libqtile.config import Key, Screen
from libqtile.lazy import lazy

from menubar import generate_bar_elements
from bindings import init_keybindings, init_mousebindings
from groups import init_groups


class Config:
    def __init__(
        self,
        mod,
        colour_scheme,
        terminal,
        default_margin,
        default_border_width,
        layouts,
    ):
        self.mod = mod
        self.colour_scheme = colour_scheme
        self.terminal = terminal
        self.keybindings = []
        self.mousebindings = []
        self.groups = []

        init_keybindings(self)
        init_mousebindings(self)
        init_groups(self)

        self.default_margin = default_margin
        self.default_border_width = default_border_width
        self.layouts = layouts

        self.wallpapers = {}
        self.init_wallpapers()

        self.connected_monitors = {}
        self.monitor_resolutions = []
        self.screens = []
        self.get_xrandr()
        self.configure_screens()

    def update_keybindings(self, keybindings: list):
        for keybinding in keybindings:
            # TODO: implement some kind of testing
            self.keybindings.append(keybinding)

    def update_mousebindings(self, mousebindings: list):
        for mousebinding in mousebindings:
            # TODO: implement some kind of testing
            self.mousebindings.append(mousebinding)

    def update_groups(self, groups: list):
        for group in groups:
            self.groups.append(group)

        self.assign_group_hotkeys()

    def assign_group_hotkeys(self):
        """
        Assign keys 1 to 0 for groups 0-9
        Assign ~ to group 10
        """
        mod = self.mod

        for idx, group in enumerate(self.groups):
            hkey = str(idx + 1)[-1]
            if idx == 10:
                hkey = "grave"
            self.update_keybindings(
                [
                    # mod1 + letter of group = switch to group
                    Key(
                        [mod],
                        hkey,
                        lazy.group[group.name].toscreen(),
                        desc="Switch to group {}".format(group.name),
                    ),
                    # mod1 + shift + letter of group = switch to & move focused window to group
                    Key(
                        [mod, "shift"],
                        hkey,
                        lazy.window.togroup(group.name, switch_group=True),
                        desc="Switch to & move focused window to group {}".format(
                            group.name
                        ),
                    ),
                    # Or, use below if you prefer not to switch to that group.
                    # # mod1 + shift + letter of group = move focused window to group
                    # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                    #     desc="move focused window to group {}".format(i.name)),
                ]
            )

    def init_wallpapers(self):
        wallpapers = {}
        for orientation in ["portrait", "landscape"]:
            wallpaper_path = Path(f"~/.config/wallpaper/{orientation}/").expanduser()
            wallpapers[orientation] = [
                str(p) for p in wallpaper_path.iterdir() if p.is_file()
            ]
        self.wallpapers = wallpapers

    def get_random_wallpaper(self, orientation):
        wallpapers = self.wallpapers[orientation]
        chosen_wallpaper = random.choice(wallpapers)
        wallpapers.remove(chosen_wallpaper)
        return chosen_wallpaper

    def configure_screens(self):
        try:
            for monitor_name, monitor_data in self.connected_monitors.items():
                sep_padding = 10
                icon_padding = 5
                widget_padding = 10

                self.screens.append(
                    Screen(
                        wallpaper=self.get_random_wallpaper(
                            monitor_data["orientation"]
                        ),
                        wallpaper_mode="stretch",
                        top=bar.Bar(
                            generate_bar_elements(
                                monitor_name=monitor_name,
                                config=self,
                                colour_scheme=self.colour_scheme,
                                monitor_is_primary=monitor_data["primary"],
                                sep_padding=sep_padding,
                                icon_padding=icon_padding,
                                widget_padding=widget_padding,
                            ),
                            24,
                            monitor=monitor_name
                            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
                            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
                        ),
                    ),
                )
        except ValueError as e:
            raise ValueError(self.connected_monitors) from e

    def get_xrandr(self):
        # Use xrandr output to see what monitors are available
        xrandr_output = subprocess.check_output("xrandr").decode()
        connected_monitors = {}
        pattern = r"(\S+) connected.*?(\d+x\d+\+\d+\+\d+).*"
        for line in xrandr_output.splitlines():
            match = re.match(pattern, line)
            if match:
                monitor_name = match.group(1)
                resolution = match.group(2)
                width, height = map(int, resolution.split("+")[0].split("x"))
                connected_monitors[monitor_name] = {
                    "width": width,
                    "height": height,
                    "orientation": "portrait" if height > width else "landscape",
                    "primary": "primary" in line,
                }
        self.connected_monitors = connected_monitors


class ColourScheme:
    def __init__(self, *args):
        """
        Provide a list of either colours. A colour can either be:

          - (str) A hex code
          - (list) A list of 2 hex codes - for gradients
        """
        self.colours = args
        self.test_colours()

    def __len__(self):
        return len(self.colours)

    def __repr__(self):
        return self.out()

    def __str__(self):
        return ", ".join(self.colours)

    def darken_colour(self, hex_colour_code, darkening_percentage=50):
        # Remove the '#' from the beginning of the colour code if it exists
        hex_colour_code = hex_colour_code.lstrip("#")

        # Convert the hexadecimal colour code to RGB
        r, g, b = tuple(int(hex_colour_code[i : i + 2], 16) for i in (0, 2, 4))

        # Reduce each of the RGB components by the darkening percentage
        r = int(r * (1 - darkening_percentage / 100))
        g = int(g * (1 - darkening_percentage / 100))
        b = int(b * (1 - darkening_percentage / 100))

        # Ensure the values are within the allowed range
        r = max(0, min(r, 255))
        g = max(0, min(g, 255))
        b = max(0, min(b, 255))

        # Convert the RGB components back to a hexadecimal colour code
        return "#{:02x}{:02x}{:02x}".format(r, g, b)

    def test_colours(self, raise_on_error=True):
        success = True
        colours = []

        print(self.colours)
        for colour in self.colours:
            if isinstance(colour, list):
                if len(colour) != 2:
                    success = False
                    break
                colours += colour
            else:
                colours.append(colour)

        for colour in colours:
            if not success:
                break
            try:
                codecs.decode(colour[1:], "hex")
                success = len(colour) in (4, 7)
            except TypeError:
                success = False

        if raise_on_error and not success:
            raise ValueError(f"Invalid colours provided {self.colours}")
        return success

    def col(self, idx, gradient=True):
        """
        Return the colour at a given index
        """

        if gradient:
            return self.out()[idx]
        else:
            return self.colours[idx]
        # try:
        #
        #
        #
        #     return self.out()[idx] if gradient else
        #
        # except TypeError as e:
        #     raise TypeError(idx) from e

    def out(self):
        """
        return the colour list in the format expected by qtile
        """
        result = []

        for colour in self.colours:
            if isinstance(colour, list):
                result.append(colour)
            else:
                result.append([colour, self.darken_colour(colour)])

        return result


#
# @lazy.function
# def rotate_net_interface(config):
#     qtile.log.info("hello")
#     interfaces = ["wlo1", "eno2"]
#     # Get the current interface of the Net widget
#     for widget in qtile.current_screen.bar.widgets:
#         if isinstance(widget, Net):
#             current_interface = widget.interface
#             break
#     # Get the index of the current interface in the interfaces list
#     current_index = interfaces.index(current_interface)
#     # Get the next interface in the list
#     next_interface = interfaces[(current_index + 1) % len(interfaces)]
#     # Update the Net widget with the new interface
#     widget.update(
#         interface=next_interface, format=f"{next_interface} {{down}} ↓↑ {{up}}"
#     )

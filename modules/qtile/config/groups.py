from libqtile.config import Group, ScratchPad, DropDown

# from params import filtered_layouts


def init_groups(config):
    config.update_groups(
        [
            Group(
                "DEV1",
                layout="monadtall",
                # layouts=filtered_layouts,
            ),
            Group(
                "DEV2",
                layout="monadtall",
                # layouts=filtered_layouts,
            ),
            Group(
                "DEV3",
                layout="monadtall",
                # layouts=filtered_layouts,
            ),
            Group(
                "WWW4",
                layout="monadtall",
                # layouts=filtered_layouts,
            ),
            Group(
                "WWW5",
                layout="monadtall",
                # layouts=filtered_layouts,
            ),
            Group("6", layout="monadtall"),
            Group("7", layout="monadtall"),
            Group("8", layout="monadtall"),
            Group("9", layout="monadtall"),
            Group(
                "NOTES",
                layout="max",
                # layouts=filtered_layouts,
            ),
            Group(
                "COMM",
                layout="max",
                # layouts=filtered_layouts,
            ),
            ScratchPad(
                'scratchpad', [
                DropDown(
                    "khal",
                    [
                        config.terminal,
                        "-e",
                        "ikhal",
                    ],
                    x=0.6, width=0.35, height=0.4, opacity=1
                ),
                DropDown(
                    "btop",
                    [
                        config.terminal,
                        "-e",
                        "btop",
                    ],
                    x=0.1, width=0.8, height=0.8, opacity=1
                ),
            ]),
        ]
    )

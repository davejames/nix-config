from libqtile.config import Group

from params import filtered_layouts


def init_groups(config):
    config.update_groups(
        [
            Group(
                "DEV1",
                layout="monadtall",
                layouts=filtered_layouts,
            ),
            Group(
                "DEV2",
                layout="monadtall",
                layouts=filtered_layouts,
            ),
            Group(
                "DEV3",
                layout="monadtall",
                layouts=filtered_layouts,
            ),
            Group(
                "WWW4",
                layout="monadtall",
                layouts=filtered_layouts,
            ),
            Group(
                "WWW5",
                layout="monadtall",
                layouts=filtered_layouts,
            ),
            Group("6", layout="monadtall"),
            Group("7", layout="monadtall"),
            Group("8", layout="monadtall"),
            Group("9", layout="monadtall"),
            Group(
                "NOTES",
                layout="max",
                layouts=filtered_layouts,
            ),
            Group(
                "COMM",
                layout="max",
                layouts=filtered_layouts,
            ),
        ]
    )

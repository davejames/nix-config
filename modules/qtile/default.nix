{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.qtile;
  qtileConfigFiles = [
    "__init__.py"
    "bindings.py"
    "config.py"
    "groups.py"
    "menubar.py"
    "startup.sh"
    "tools.py"
    "icons/robot.png"
    "icons/terminal.png"
  ];
in {
  options.modules.qtile = {enable = mkEnableOption "qtile";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      khal
    ];
    services.betterlockscreen = {
      enable = true;
      inactiveInterval = 10;
    };
    home.file =
      builtins.listToAttrs (map (filename: {
          name = builtins.replaceStrings ["/"] ["_"] filename;
          value = {
            target = ".config/qtile/${filename}";
            source = ./config/${filename};
          };
        })
        qtileConfigFiles)
      // {
        ".config/qtile/params.py".text = ''
          from libqtile import layout

          from tools import Config, ColourScheme

          widget_defaults = dict(
              font="JetBrains Mono Bold",
              fontsize=16,
              padding=3,
              background=1,

              # Menubar elements
              sep_padding=5,
              icon_padding=10,
              widget_padding=10,
          )

          colour_scheme = ColourScheme(
              "#${config.colorScheme.palette.base00}",
              "#${config.colorScheme.palette.base01}",
              "#${config.colorScheme.palette.base02}",
              "#${config.colorScheme.palette.base03}",
              "#${config.colorScheme.palette.base04}",
              "#${config.colorScheme.palette.base05}",
              "#${config.colorScheme.palette.base06}",
              "#${config.colorScheme.palette.base07}",
              "#${config.colorScheme.palette.base08}",
              "#${config.colorScheme.palette.base09}",
              "#${config.colorScheme.palette.base0A}",
              "#${config.colorScheme.palette.base0B}",
              "#${config.colorScheme.palette.base0C}",
              "#${config.colorScheme.palette.base0D}",
              "#${config.colorScheme.palette.base0E}",
              "#${config.colorScheme.palette.base0F}",
          )

          layout_defaults = {
              "margin": 16,
              "border_width": 4,
              "border_normal": colour_scheme.col(1),
              "border_focus": colour_scheme.col(14, gradient=False),
          }

          all_layouts = [
              layout.Max(**layout_defaults),
              layout.MonadTall(**layout_defaults),
              layout.MonadWide(**layout_defaults),
              layout.TreeTab(**layout_defaults),
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
              widget_defaults=widget_defaults,
          )
        '';
      };
  };
}

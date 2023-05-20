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
              "#${config.colorScheme.colors.base00}",
              "#${config.colorScheme.colors.base01}",
              "#${config.colorScheme.colors.base02}",
              "#${config.colorScheme.colors.base03}",
              "#${config.colorScheme.colors.base04}",
              "#${config.colorScheme.colors.base05}",
              "#${config.colorScheme.colors.base06}",
              "#${config.colorScheme.colors.base07}",
              "#${config.colorScheme.colors.base08}",
              "#${config.colorScheme.colors.base09}",
              "#${config.colorScheme.colors.base0A}",
              "#${config.colorScheme.colors.base0B}",
              "#${config.colorScheme.colors.base0C}",
              "#${config.colorScheme.colors.base0D}",
              "#${config.colorScheme.colors.base0E}",
              "#${config.colorScheme.colors.base0F}",
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

{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.alacritty;
in {
  options.modules.alacritty = {enable = mkEnableOption "alacritty";};
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 5;
            y = 5;
          };
          decorations = "none";
          opacity = 1.0;
        };
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Medium";
          };
          size = 8.0;
        };
        foreground = "#${config.colorScheme.colors.base05}";
        background = "#${config.colorScheme.colors.base00}";
        cursor = {
          text = "#${config.colorScheme.colors.base00}";
          cursor = "#${config.colorScheme.colors.base05}";
        };
        colors = {
          primary = {
            background = "#${config.colorScheme.colors.base00}";
            foreground = "#${config.colorScheme.colors.base05}";
          };
          normal = {
            black = "#${config.colorScheme.colors.base00}";
            red = "#${config.colorScheme.colors.base08}";
            green = "#${config.colorScheme.colors.base0B}";
            yellow = "#${config.colorScheme.colors.base0A}";
            blue = "#${config.colorScheme.colors.base0D}";
            magenta = "#${config.colorScheme.colors.base0E}";
            cyan = "#${config.colorScheme.colors.base0C}";
            white = "#${config.colorScheme.colors.base05}";
          };
          bright = {
            black = "#${config.colorScheme.colors.base02}";
            red = "#${config.colorScheme.colors.base09}";
            green = "#${config.colorScheme.colors.base0B}";
            yellow = "#${config.colorScheme.colors.base03}";
            blue = "#${config.colorScheme.colors.base04}";
            magenta = "#${config.colorScheme.colors.base0F}";
            cyan = "#${config.colorScheme.colors.base0C}";
            white = "#${config.colorScheme.colors.base06}";
          };
        };
      };
    };
  };
}

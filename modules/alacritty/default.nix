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
        # foreground = "#${config.colorScheme.colors.base05}";
        # background = "#${config.colorScheme.colors.base00}";
        # cursor = {
        #   text = "#${config.colorScheme.colors.base00}";
        #   cursor = "#${config.colorScheme.colors.base05}";
        # };
        colors = {
          primary = {
            background = "#${config.colorScheme.palette.base00}";
            foreground = "#${config.colorScheme.palette.base05}";
          };
          normal = {
            black = "#${config.colorScheme.palette.base00}";
            red = "#${config.colorScheme.palette.base08}";
            green = "#${config.colorScheme.palette.base0B}";
            yellow = "#${config.colorScheme.palette.base0A}";
            blue = "#${config.colorScheme.palette.base0D}";
            magenta = "#${config.colorScheme.palette.base0E}";
            cyan = "#${config.colorScheme.palette.base0C}";
            white = "#${config.colorScheme.palette.base05}";
          };
          bright = {
            black = "#${config.colorScheme.palette.base02}";
            red = "#${config.colorScheme.palette.base09}";
            green = "#${config.colorScheme.palette.base0B}";
            yellow = "#${config.colorScheme.palette.base03}";
            blue = "#${config.colorScheme.palette.base04}";
            magenta = "#${config.colorScheme.palette.base0F}";
            cyan = "#${config.colorScheme.palette.base0C}";
            white = "#${config.colorScheme.palette.base06}";
          };
        };
      };
    };
  };
}

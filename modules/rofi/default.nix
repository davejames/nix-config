{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.rofi;
in {
  options.modules.rofi = {enable = mkEnableOption "rofi";};
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      extraConfig = {
        modes = ["run" "filebrowser"];
        sidebar-mode = true;
        font = "JetBrainsMono Nerd Font 14";
        show-icons = true;
        terminal = "alacritty";
      };
      theme = let inherit (config.lib.formats.rasi) mkLiteral; in
      {
        "*" = {
          bg0 = mkLiteral "#${config.colorScheme.colors.base00}";
          bg1 = mkLiteral "#${config.colorScheme.colors.base01}";
          fg0 = mkLiteral "#${config.colorScheme.colors.base02}";
          fg1 = mkLiteral "#${config.colorScheme.colors.base09}";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg0";
        };

        "element-icon, element-text, scrollbar" = {
          cursor = mkLiteral "pointer";
        };

        "window" = {
          width = mkLiteral "500px";
          padding = mkLiteral "20px";

          background-color = mkLiteral "@bg0";
          border = mkLiteral "2px";
          border-color = mkLiteral "#${config.colorScheme.colors.base08}";
        };

        "inputbar" = {
          spacing = mkLiteral "8px";
          padding = mkLiteral "4px 8px";
          # children = mkLiteral "[ icon-search, entry ]";

          background-color = mkLiteral "@bg0";
        };

        "icon-search" = {
          expand = false;
          filename = mkLiteral "[ search-symbolic ]";
          size = mkLiteral "14px";
        };

        "textbox" = {
          padding = mkLiteral "4px 8px";
          background-color = mkLiteral "@bg0";
        };

        "listview" = {
          padding = mkLiteral "4px 0px";
          lines = 12;
          columns = 1;
          scrollbar = false;
          fixed-height = true;
          dynamic = true;
        };

        "element" = {
          padding = mkLiteral "4px 8px";
          spacing = mkLiteral "8px";
        };

        "element normal urgent" = {
          text-color = mkLiteral "@fg1";
        };

        "element normal active" = {
          text-color = mkLiteral "@fg1";
        };

        "element selected" = {
          # text-color = mkLiteral "@bg0"; #1
          background-color = mkLiteral "@fg1";
        };

        "element selected urgent" = {
          background-color = mkLiteral "@fg1";
        };

        "element-icon" = {
          size = mkLiteral "0.8em";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
        };
      };

    };
  };
}

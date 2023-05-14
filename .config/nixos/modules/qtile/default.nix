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
    "params.py"
    "startup.sh"
    "tools.py"
    "icons/robot.png"
    "icons/terminal.png"
  ];
in {
  options.modules.qtile = {enable = mkEnableOption "qtile";};

  config = mkIf cfg.enable {
    home.file = builtins.listToAttrs (map (filename: {
      name = ".config/qtile/${filename}";
      value = { source = ./config/${filename}; };
    }) qtileConfigFiles);
  };
}

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

  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = true;
    windowManager.qtile = {
      enable = true;
      backend = "x11";
      extraPackages = python310Packages:
        with python310Packages; [
          qtile-extras
          psutil
          dbus-python
          pyxdg
          mpd2
          # python-wifi
          # iwlib
          dateutil
          keyring
          jsons
        ];
    };
    displayManager = {
      lightdm = {
        enable = true;
        background = "/etc/lightdm/background.jpg";
        greeters.enso = {
          enable = true;
          blur = true;
        };
      };
      defaultSession = "none+qtile";
    };
  };
  # config = mkIf cfg.enable {
  #   home.file.".config/qtile/__init__.py".source = ./config/__init__.py;
  #   home.file.".config/qtile/bindings.py".source = ./config/bindings.py;
  # };
}

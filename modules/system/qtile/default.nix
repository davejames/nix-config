{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.qtile;
in {
  options.modules.qtile = {enable = mkEnableOption "qtile";};

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        desktopManager.xterm.enable = true;
        windowManager.qtile = {
          enable = true;
          extraPackages = _:
            with pkgs.python3Packages; [
              qtile-extras
              psutil
              dbus-python
              pyxdg
              mpd2
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
    };
  };
}

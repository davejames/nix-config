{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.qtile;
  qtileServiceConfig = config.services.xserver.windowManager.qtile;

  # Qtile is currently broken on unstable due to incompatibilities with
  # some python dependencies. As a workaround, qtile and its dependencies
  # are installed from stable.
  # See: https://github.com/NixOS/nixpkgs/issues/252769
  qtilePackage = pkgs.stable.qtile;
  qtilePythonDeps = with pkgs.stable.python310Packages; [
    qtile-extras
    psutil
    dbus-python
    pyxdg
    mpd2
    dateutil
    keyring
    jsons
  ];
  pyEnv = pkgs.stable.python3.withPackages (
    p:
      [
        (qtilePackage.unwrapped or qtilePackage)
      ]
      ++ qtilePythonDeps
  );
in {
  options.modules.qtile = {enable = mkEnableOption "qtile";};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.stable; [
      (python3.withPackages (p: [
        (qtilePackage.unwrapped or qtilePackage)
      ]))
    ];
    services = {
      xserver = {
        enable = true;
        desktopManager.xterm.enable = true;
        windowManager.qtile = {
          enable = true;
          extraPackages = _: qtilePythonDeps;
          package = qtilePackage;
        };
        windowManager.session = [
          {
            name = "qtile";
            start = ''
              ${pyEnv}/bin/qtile start -b ${qtileServiceConfig.backend} \
              ${optionalString (qtileServiceConfig.configFile != null)
                "--config \"${qtileServiceConfig.configFile}\""} &
              waitPID=$!
            '';
          }
        ];
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

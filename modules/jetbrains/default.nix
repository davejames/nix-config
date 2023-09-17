{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.jetbrains;
in {
  options.modules.jetbrains = {
    pycharm = {enable = mkEnableOption "pycharm";};
    datagrip = {enable = mkEnableOption "datagrip";};
  };

  config = mkMerge [
    (mkIf
      cfg.pycharm.enable
      {
        home = {
          packages = with pkgs; [
            (
              jetbrains.plugins.addPlugins
              jetbrains.pycharm-professional
              ["github-copilot"]
            )
          ];
        };
      })

    (mkIf
      cfg.datagrip.enable
      {
        home = {
          packages = with pkgs; [
            (
              jetbrains.plugins.addPlugins
              jetbrains.datagrip
              ["github-copilot"]
            )
          ];
        };
      })
  ];
}

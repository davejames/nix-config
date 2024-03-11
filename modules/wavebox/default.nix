{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.wavebox;
in {
  options.modules.wavebox = {enable = mkEnableOption "wavebox";};
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        wavebox
      ];
    };
  };
}

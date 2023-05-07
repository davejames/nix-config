{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.jetbrains;
  pycharm-professional =
    pkgs.jetbrains.pycharm-professional.overrideAttrs
    (finalAttrs: previousAttrs: {
      buildInput = with pkgs; [glibc gcc nodejs-slim];
    });
in {
  options.modules.jetbrains.pycharm = {enable = mkEnableOption "pycharm";};
  config = mkIf cfg.pycharm.enable {
    home.packages = with pkgs; [pycharm-professional nodejs-slim glibc];
  };
}

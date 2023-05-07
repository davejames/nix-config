{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.jetbrains;

  # packageOverrides = pkgs: {
  #     pycharm-professional = jetbrains.pycharm-professional.override {
  #         buildInputs = with pkgs; [ glibc ];
  #     };
  # };

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

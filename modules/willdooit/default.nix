{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.willdooit;

in {
  options.modules.willdooit = {enable = mkEnableOption "willdooit";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gh
      inputs.willdooit-dev-cli.packages.x86_64-linux.default
      inputs.willdooit-commitizen.packages.x86_64-linux.default
      graphite-cli
      tailspin
    ];
    programs.git = {
      enable = true;
      userName = "David James";
      userEmail = "david.james@willdooit.com";
      extraConfig = {
        init = {defaultBranch = "main";};
      };
      aliases = {
        merges = "log --oneline --decorate --color=auto --merges --first-parent";
      };
    };
  };
}

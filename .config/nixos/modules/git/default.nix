{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.git;
in {
  options.modules.git = {enable = mkEnableOption "git";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [gh];
    programs.git = {
      enable = true;
      userName = "David James";
      userEmail = "davejames@gmail.com";
      extraConfig = {
        init = {defaultBranch = "main";};
        core = {excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";};
      };
    };
  };
}

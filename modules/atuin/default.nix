{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.atuin;
in {
  options.modules.atuin = {enable = mkEnableOption "atuin";};
  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = config.modules.zsh.enable;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "prefix";
      };
    };
  };
}

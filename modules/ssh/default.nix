{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.ssh;
  gitConfig = builtins.fetchGit {
    url = "ssh://git@github.com/davejames/sshconfig.git";
    rev = "7fa88993879eb381bfd1c67e01b073d8e3bf444d";
  };
in {
  options.modules.ssh = {enable = mkEnableOption "ssh";};
  config = mkIf cfg.enable {
    home.file = {
      ".ssh/config.d".source = "${gitConfig}/config.d";
    };

    programs.ssh = {
      enable = true;
      includes = [
        "config.d/*"
      ];
      extraOptionOverrides = {
        "sendEnv" = "PAGER GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL";
      };
    };
  };
}

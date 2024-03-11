{
  pkgs,
  lib,
  config,
  system,
  inputs,
  willdooit-dev-cli,
  willdooit-commitizen,
  ...
}:
with lib; let
  cfg = config.modules.willdooit;

  willdooitDevCli = builtins.fetchGit {
    url = "ssh://git@github.com/WilldooIT-Private/willdooit-dev-cli";
    rev = "dbb36e39100b2c2b0ee7e98d185bbf6931eaaa8c";
  };
  willdooitCommitizen = builtins.fetchGit {
    url = "ssh://git@github.com/WilldooIT-Private/willdooit-commitizen";
    ref = "flake-fix";
    rev = "61dc6b52705e22bb2f59b7e4c5ae782bd3c1d0b6";
  };
  # willdooitFlake = builtins.getFlake "${willdooitDevCli}/nix.flake";
  # commitizenFlake = builtins.getFlake "${willdooitCommitizen}/nix.flake";
  # #
  # willdooitFlake = builtins.getFlake "git+ssh://git@github.com/WilldooIT-Private/willdooit-dev-cli?ref=main";
  # commitizenFlake = builtins.getFlake "git+ssh://github.com/WilldooIT-Private/willdooit-commitizen?ref=flake-fix";
  #  willdooit-dev-cli.url = "git+ssh://git@github.com/WilldooIT-Private/willdooit-dev-cli?ref=main";
  #  willdooit-commitizen.url = "git+ssh://git@github.com/WilldooIT-Private/willdooit-commitizen?ref=flake-fix";
in {
  # imports = [
  #   willdooitDevCli
  #   willdooitCommitizen
  # ];
  options.modules.willdooit = {enable = mkEnableOption "willdooit";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gh
      inputs.willdooit-dev-cli.packages.x86_64-linux.default
      inputs.willdooit-commitizen.packages.x86_64-linux.default
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

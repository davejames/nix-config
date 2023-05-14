{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.jetbrains;
  # Until this PR is merged, we need to use a fork of nixpkgs
  # https://github.com/NixOS/nixpkgs/pull/223593
  pr =
    import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/pull/223593/head.tar.gz";
      sha256 = "sha256:10jhf5y261rgj8kc7sb9fmg68h2j4nnylb4ci0dxykkry4zd6r62";
    })
    {
      config = pkgs.config;
      localSystem = {system = "x86_64-linux";};
    };
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
          packages = [
            (
              pr.jetbrains.plugins.addPlugins
              pr.jetbrains.pycharm-professional
              ["github-copilot"]
            )
          ];
        };
      })

    (mkIf
      cfg.datagrip.enable
      {
        home = {
          packages = [
            (
              pr.jetbrains.plugins.addPlugins
              pr.jetbrains.datagrip
              ["github-copilot"]
            )
          ];
        };
      })
  ];
}

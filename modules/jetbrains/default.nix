{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.jetbrains;
  buildVer = pkgs.jetbrains.pycharm-professional.version;
  fsnotifier = pkgs.stdenv.mkDerivation {
    pname = "fsnotifier";
    version = buildVer;
    src = pkgs.fetchFromGitHub {
      owner = "mdelah";
      repo = "intellij-community";
      rev = "6bbf603499123e84097e7cce88659426683a6d74";
      sha256 = "sha256-UNbb2pkD8cb1+Y8otId9z8GvVpgxPIHgSlIiyPRfIjI=";
    };
    sourceRoot = "source/native/fsNotifier/linux";
    buildPhase = ''
      runHook preBuild
      cc -O2 -Wall -Wextra -Wpedantic -D "VERSION=\"${buildVer}\"" -std=c11 main.c inotify.c util.c -o fsnotifier
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mv fsnotifier $out/bin
      runHook postInstall
    '';
  };
  pycharm-professional = pkgs.jetbrains.pycharm-professional.overrideAttrs (oldAttrs: {
    installPhase = ''
      ${oldAttrs.installPhase or ""}
      rm $out/$pname/bin/fsnotifier
      cp ${fsnotifier}/bin/fsnotifier $out/$pname/bin/fsnotifier
    '';
  });
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
              pycharm-professional
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

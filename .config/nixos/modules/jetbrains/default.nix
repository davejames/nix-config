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

  copilot-agent-linux = pkgs.callPackage ../../packages/copilot-agent-linux.nix {};
in {
  options.modules.jetbrains.pycharm = {enable = mkEnableOption "pycharm";};
  config = mkIf cfg.pycharm.enable {
    home.file."${".local/share/JetBrains/PyCharm2022.3"
      + "/${copilot-agent-linux.pname}/copilot-agent/bin/${copilot-agent-linux.name}"}".source = "${copilot-agent-linux}/bin/${copilot-agent-linux.name}";

    home.file."${".local/share/JetBrains/DataGrip2022.2"
      + "/${copilot-agent-linux.pname}/copilot-agent/bin/${copilot-agent-linux.name}"}".source = "${copilot-agent-linux}/bin/${copilot-agent-linux.name}";

    home.packages = with pkgs; [pycharm-professional nodejs-slim glibc];
  };
}

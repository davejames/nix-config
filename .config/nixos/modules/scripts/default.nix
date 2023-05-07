{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.shellScripts;

in {
    options.modules.shellScripts = { enable = mkEnableOption "shellScripts"; };
    config = mkIf cfg.enable {
        home.file.".config/shellscripts/display.sh".source = ./display.sh;
        home.file.".config/shellscripts/filesearch.sh".source = ./filesearch.sh;
    };
}

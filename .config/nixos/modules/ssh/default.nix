{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.ssh;

in {
    options.modules.ssh = { enable = mkEnableOption "ssh"; };
    config = mkIf cfg.enable {

        home.file.".ssh/config.d/willdooit.conf".source = ./config/config.d/willdooit.conf;
        home.file.".ssh/config.d/djdc.conf".source = ./config/config.d/djdc.conf;
        home.file.".ssh/config.d/gitproviders.conf".source = ./config/config.d/gitproviders.conf;
        home.file.".ssh/config.d/sis.conf".source = ./config/config.d/sis.conf;

        programs.ssh = {
            enable = true;
            includes = [
                "config.d/gitproviders.conf"
                "config.d/willdooit.conf"
                "config.d/djdc.conf"
                "config.d/sis.conf"
            ];
            extraOptionOverrides = {
                "sendEnv" = "PAGER GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL";
            };
        };
    };
}

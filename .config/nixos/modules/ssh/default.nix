{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.ssh;

in {
    options.modules.ssh = { enable = mkEnableOption "ssh"; };
    config = mkIf cfg.enable {

        home.file.".ssh/config".source = ./config/config;
        home.file.".ssh/config.d/willdoo".source = ./config/config.d/willdoo;
        home.file.".ssh/config.d/djdc".source = ./config/config.d/djdc;
        home.file.".ssh/config.d/gitproviders".source = ./config/config.d/gitproviders;
        home.file.".ssh/config.d/sis".source = ./config/config.d/sis;
        
        home.packages = with pkgs; [
            ssh-ident
        ];

    };
}

{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        git.enable = true;
        # postgresql.enable = true;

        # cli
        # nvim.enable = true;

    };
}

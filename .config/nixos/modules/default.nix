{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "22.11";
    imports = [
        # gui
        # ./firefox
        # ./foot
        # ./eww
        # ./dunst
        # ./hyprland
        # ./wofi

        # cli
        ./nvim
        # ./zsh
        ./git
        ./jetbrains
        ./docker
        # ./postgresql
        # ./gpg
        # ./direnv

        # system
        # ./xdg
	    # ./packages
    ];
}

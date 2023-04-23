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
        ./alacritty
        ./nvim
        ./fish
        ./zsh
        ./git
        ./jetbrains
        ./docker
        ./tmux
        # ./postgresql
        # ./gpg
        # ./direnv

        # system
        # ./xdg
	    # ./packages
    ];
}

{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.stateVersion = "22.11";
  imports = [
    ./alacritty
    ./nvim
    ./fish
    ./zsh
    ./git
    ./jetbrains
    ./docker
    ./tmux
    ./scripts
    ./ssh
    inputs.nix-colors.homeManagerModule
  ];
  
  colorScheme = inputs.nix-colors.colorSchemes.dracula;
}

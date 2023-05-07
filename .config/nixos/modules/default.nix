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
  ];
}

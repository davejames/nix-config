{inputs, ...}: {
  home.stateVersion = "22.11";
  imports = [
    ./qtile
    ./alacritty
    ./nvim
    ./fish
    ./zsh
    ./git
    ./willdooit
    ./jetbrains
    ./docker
    ./tmux
    ./rofi
    ./scripts
    ./ssh
    inputs.nix-colors.homeManagerModule
  ];

  colorScheme = inputs.nix-colors.colorSchemes.seti;
}

{inputs, ...}: {
  home.stateVersion = "22.11";
  imports = [
    ./qtile
    ./atuin
    ./alacritty
    ./nvim
    ./fish
    ./zsh
    ./git
    ./willdooit
    ./timewarrior
    ./jetbrains
    ./vscode
    ./docker
    ./wavebox
    ./tmux
    ./rofi
    ./scripts
    ./ssh
    inputs.nix-colors.homeManagerModule
  ];

  colorScheme = inputs.nix-colors.colorSchemes.seti;
}

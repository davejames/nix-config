{
  inputs,
  ...
}: {
  home.stateVersion = "22.11";
  imports = [
    ./qtile
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
  
  colorScheme = inputs.nix-colors.colorSchemes.seti;
}

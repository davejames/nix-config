{
  pkgs,
  ...
}:
let
  timewarrior = import ./timewarrior.nix { inherit pkgs; };

in 
  pkgs.lib.recursiveUpdate timewarrior



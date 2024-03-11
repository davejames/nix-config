{pkgs, ...}: let
  packages = [
    (import ./timewarrior.nix {inherit pkgs;})
    (import ./nixd.nix {inherit pkgs;})
  ];
in
  with pkgs.lib;
    foldl' (acc: item: recursiveUpdate acc item) {} packages

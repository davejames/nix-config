{nixpkgs, ...}: final: prev: {
  customPackages = import ./packages/packages.nix {pkgs = prev;};
}

{
  pkgs,
  ...
}:
let
  nixdFlake = builtins.getFlake "github:nix-community/nixd?rev=eb40e5b315fafa1086f69be84918bbd9235e0a10";
  nixd = nixdFlake.packages.${pkgs.system}.nixd;

in {
  inherit nixd;
}

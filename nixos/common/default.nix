{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./configuration.nix
  ];
}


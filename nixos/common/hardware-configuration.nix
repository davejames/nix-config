# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
  ...
}: {
  boot.loader.systemd-boot.enable = true;

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = system;
}

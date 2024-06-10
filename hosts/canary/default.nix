{ config, pkgs, self, ... }:
let
  diskName = "sda";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disks.nix
  ];
  # disko.devices = import ../../disks/zfs.nix { inherit diskName;};
}

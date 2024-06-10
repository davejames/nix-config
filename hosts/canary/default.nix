{ inputs, config, pkgs, self, ... }:
let
  diskName = "sda";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./disks.nix
    ../../disks/zfs.nix { inherit diskName; }
    inputs.disko.nixosModules.disko
  ];
  networking.hostId = "924bfedc";
  # disko.devices = import ../../disks/zfs.nix { inherit diskName;};
}

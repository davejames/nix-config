{ inputs, config, pkgs, self, ... }:
let
  diskName = "sda";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disks.nix
    # (import ../../disks/zfs.nix { diskName = "sda"; })
    inputs.disko.nixosModules.disko
  ];
  boot.zfs.requestEncryptionCredentials = true;
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  networking.hostId = "924bfedc";
  # disko.devices = import ../../disks/zfs.nix { inherit diskName;};
}

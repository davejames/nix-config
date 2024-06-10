{ inputs, config, pkgs, self, ... }:
let
  diskName = "sda";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./disks.nix
    (import ../../disks/zfs.nix { diskName = "sda"; })
    inputs.disko.nixosModules.disko
  ];
  boot = {
    initrd.systemd.enable = true;
    zfs.requestEncryptionCredentials = true;
    supportedFilesystems = ["zfs"];
    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        editor = false;

        memtest86.enable = true;
        netbootxyz.enable = true;
      };
    };
  };
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  networking.hostId = "924bfedc";
  # disko.devices = import ../../disks/zfs.nix { inherit diskName;};
}

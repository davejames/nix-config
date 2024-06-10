{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
  ...
}: {
  boot = {
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
    # loader = {
    #   generationsDir.copyKernels = true;
    #   efi = {
    #     canTouchEfiVariables = false;
    #   };
    #   grub = {
    #     enable = true;
    #     useOSProber = true;
    #     copyKernels = true;
    #     efiSupport = true;
    #     device = "nodev";
    #     zfsSupport = true;
    #     efiInstallAsRemovable = true;
    #   };
    # };
  };
}


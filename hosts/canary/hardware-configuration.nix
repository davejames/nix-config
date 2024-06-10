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


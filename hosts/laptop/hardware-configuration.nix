{
  pkgs,
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    tmp.cleanOnBoot = true;
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [
        "i915"
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      luks.devices = {
        "luks-126431dc-7e42-4de4-8cdc-b7739d334c6a".device = "/dev/disk/by-uuid/126431dc-7e42-4de4-8cdc-b7739d334c6a";
        "luks-126431dc-7e42-4de4-8cdc-b7739d334c6a".keyFile = "/crypto_keyfile.bin";
        "luks-b4f14503-410f-48ed-9469-37ccb3d73402".device = "/dev/disk/by-uuid/b4f14503-410f-48ed-9469-37ccb3d73402";
      };
    };
    kernelModules = ["kvm-intel"];
    kernelParams = [
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
      "i915.enable_guc=2"
    ];
    extraModulePackages = [];
    loader = {
      timeout = 2;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
        enableCryptodisk = true;
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a0cd5f68-3d7e-48f9-bdb8-772b552d5bdc";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/B6E4-F68B";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/48d64171-29b6-40be-8d95-57f6053c4d16";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking = with lib; {
    useDHCP = mkDefault false;
    interfaces = {
      eno2.useDHCP = mkDefault true;
      wlo1.useDHCP = mkDefault true;
    };
    networkmanager.enable = true;
  };

  programs.nm-applet.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  sound.enable = true;
  virtualisation.docker.enable = true;

  hardware = {
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
        intel-media-driver
      ];
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
    };
    bluetooth.enable = true;
    pulseaudio.enable = false;
  };

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  services = {
    xserver.videoDrivers = ["intel" "nvidia"];
    xserver.layout = "us";
    xserver.libinput.enable = true;
    printing.enable = true;
    blueman.enable = true;

    # Enable sound with pipewire.
    # security.rtkit.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}

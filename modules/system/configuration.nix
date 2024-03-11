{pkgs, ...}: {

  programs.zsh.enable = true;
  users.users.djames = {
    isNormalUser = true;
    extraGroups = ["input" "wheel" "networkmanager" "docker" "qemu-libvirtd" "libvirtd"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      google-chrome
      brave
      nano
      navi
      libreoffice
      devbox
      zip
      unzip
      trilium-desktop
      obsidian
      vlc
      flameshot
      simplescreenrecorder
      bitwarden
      bitwarden-cli
      postman
      insomnia
      pgcli
      pspg
      imagemagick
      eza
      bat
      fselect
      nodePackages.prettier
      nodePackages.prettier-plugin-toml
      nixpkgs-fmt
      alejandra
      black
      gimp
      inkscape
      vagrant
      drawio
      mongodb-compass
    ];
  };

  environment = {
    defaultPackages = [];
    variables = {EDITOR = "nvim";};
    systemPackages = with pkgs; [
      acpi
      tlp
      killall
      wget
      screen
      dig
      kitty
      arandr
      feh
      xfce.thunar
      via
      htop
      iotop
      btop
      bandwhich
      rsync
      keepassxc
      conky
      pv
      reptyr
      comma
      nix-index
      ncdu
    ];
  };

  services = {
    dnsmasq = {
      enable = true;
      settings = {
        address = "/willdooit.local/127.0.0.1";
      };
    };
    postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "djames";
        }
      ];
      authentication = ''
        local all all trust
      '';
    };

    # Required for VIA
    udev = {
      enable = true;
      extraRules = ''
        KERNEL=="hidraw*", \
        SUBSYSTEM=="hidraw", MODE="0660", \
        GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
    };
    picom = {
      enable = true;
      activeOpacity = 1.0;
      inactiveOpacity = 0.97;
      shadowOpacity = 0.8;
      shadowOffsets = [(-8) (-8)];
      fade = true;
      shadow = true;
      opacityRules = ["100:class_g = 'i3lock'"];
    };
    passSecretService = with pkgs; {
      enable = true;
      package = keepassxc;
    };
  };

  fonts = {
    packages = with pkgs; [
      openmoji-color
      (nerdfonts.override {
        fonts = [
          "Ubuntu"
          "JetBrainsMono"
          "DroidSansMono"
          "Monofur"
          "Hermit"
          "FiraCode"
        ];
      })
      font-awesome
      symbola
      mononoki
    ];
    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {emoji = ["OpenMoji Color"];};
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = ["djames"];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://willdooit-dev.cachix.org"
      ];
      trusted-public-keys = [
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "willdooit-dev.cachix.org-1:Ls6JcovSkbkjlge0KdWMCZn32ysXnYempw9s7Ox3y5I="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 90d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs.config = {
   allowUnfree = true;
  };

  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  networking = {
    firewall = {
      enable = true;
      allowPing = false;
    };
    networkmanager.enable = true;
  };

  security = {
    sudo.enable = true;
    protectKernelImage = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  # Do not touch
  system.stateVersion = "22.11";
}

{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.users.djames = {
    isNormalUser = true;
    extraGroups = ["input" "wheel" "networkmanager" "docker"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      google-chrome
      brave
      zerotierone
      nano
      navi
      libreoffice
      devbox
      zip
      unzip
      betterlockscreen
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
      exa
      bat
      fselect
      nodePackages.prettier
      nodePackages.prettier-plugin-toml
      nixpkgs-fmt
      alejandra
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
      rofi
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
    ];
  };

  services = {
    postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "djames";
          ensurePermissions = {"ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";};
        }
      ];
      authentication = ''
        local all all trust
      '';
    };

    xserver = {
      enable = true;
      desktopManager.xterm.enable = true;
      windowManager.qtile = {
        enable = true;
        backend = "x11";
        extraPackages = python310Packages:
          with python310Packages; [
            qtile-extras
            psutil
            dbus-python
            pyxdg
            mpd2
            # python-wifi
            # iwlib
            dateutil
            keyring
            jsons
          ];
      };
      displayManager = {
        lightdm = {
          enable = true;
          background = "/etc/lightdm/background.jpg";
          greeters.enso = {
            enable = true;
            blur = true;
          };
        };
        defaultSession = "none+qtile";
      };
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
    fonts = with pkgs; [
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
    settings.auto-optimise-store = true;
    settings.allowed-users = ["djames"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_US.UTF-8";
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

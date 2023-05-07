{ config, pkgs, inputs, ... }:

let
    cachixSrc = builtins.fetchTarball {
        url = "https://github.com/cachix/devenv/archive/v0.6.2.tar.gz";
        sha256 = "sha256:12dd5g3p9azm2ns9gs9y1fmc7bd0frwwf4cz10wmnvrpvs8d4gcq";
    };
    devenv = (import cachixSrc);
in
{
    nixpkgs.config.allowUnfree = true;

    # Remove unecessary preinstalled packages
    environment.defaultPackages = [ ];
    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "djames";
          ensurePermissions = {
            "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
          };
        }
      ];
      authentication = ''
        local all all trust
      '';
    };


    services.xserver = {
      enable = true;
      desktopManager.xterm.enable = true;

      windowManager.qtile = {
        enable = true;
        backend = "x11";
        extraPackages = python310Packages: with python310Packages; [
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

    # Required for VIA, but might be causing some instability, disabled for now
    # services.udev = {
    #   enable = true;
    #   extraRules = ''
    #    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    #   '';
    # };

    services.picom = {
      enable = true;
      activeOpacity = 1.0;
      inactiveOpacity = 0.97;
      shadowOpacity = 0.8;
      shadowOffsets = [ (-8) (-8) ];
      fade = true;
      shadow = true;
      opacityRules = [
        "100:class_g = 'i3lock'"
      ];
    };

    services.passSecretService = with pkgs; {
        enable = true;
        package = keepassxc;
    };

    # Laptop-specific packages (the other ones are installed in `packages.nix`)
    environment.systemPackages = with pkgs; [
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
      rsync
      keepassxc
      conky
      # nerdfonts
      # fira-code
    ];

    # Install fonts
    fonts = {
        fonts = with pkgs; [
            # jetbrains-mono
            # roboto
            openmoji-color
            (nerdfonts.override {
                fonts = [
                    "Ubuntu"
                    "JetBrainsMono"
                    "DroidSansMono"
                    "Monofur"
                    "Hermit"
                ];
            })
            font-awesome
            symbola
            mononoki
            ubuntu_font_family
        ];

        fontconfig = {
            hinting.autohint = true;
            defaultFonts = {
              emoji = [ "OpenMoji Color" ];
            };
        };
    };

    # Enable flatpaks
    # xdg = 
    # {
    #   portal = {
    #     enable = true;
    #     extraPortals = with pkgs; [
    #       xdg-desktop-portal-gtk
    #     ];
    #   };
    # };
    # services.flatpak.enable = true;

    # Wayland stuff: enable XDG integration, allow sway to use brillo
    #xdg = {
    #    portal = {
    #        enable = true;
    #        extraPortals = with pkgs; [
    #            xdg-desktop-portal-wlr
    #            xdg-desktop-portal-gtk
    #        ];
    #        gtkUsePortal = true;
    #    };
    #};

    # Nix settings, auto cleanup and enable flakes
    nix = {
        settings.auto-optimise-store = true;
        settings.allowed-users = [ "djames" ];
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

    # Set up locales (timezone and keyboard layout)
    time.timeZone = "Australia/Melbourne";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    # Set up user and enable sudo
    # programs.fish.enable = true;
    programs.zsh.enable = true;
    users.users.djames = {
        isNormalUser = true;
        extraGroups = [ "input" "wheel" "networkmanager" "docker" ];
        shell = pkgs.zsh;
        packages = with pkgs; [
          firefox
          google-chrome
          brave
          zerotierone
          nano
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
          imagemagick
          exa
          bat
          nodePackages.prettier
          nodePackages.prettier-plugin-toml
          nixpkgs-fmt
      ];

    };

    # Set up networking and secure it
    networking = {
        firewall = {
            enable = true;
            # allowedTCPPorts = [ 443 80 ];
            # allowedUDPPorts = [ 443 80 44857 ];
            allowPing = false;
        };
        networkmanager.enable = true;
    };

    # Set environment variables
    environment.variables = {
        EDITOR = "nvim";
    };

    # Security 
    security = {
        sudo.enable = true;

        # Extra security
        protectKernelImage = true;
    };

    # Disable bluetooth, enable pulseaudio, enable opengl (for Wayland)
    hardware = {
        opengl = {
            enable = true;
            driSupport = true;
        };
    };

    # Do not touch
    system.stateVersion = "22.11";
}

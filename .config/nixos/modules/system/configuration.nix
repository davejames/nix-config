{ config, pkgs, inputs, ... }:

{
    nixpkgs.config.allowUnfree = true;

    # Remove unecessary preinstalled packages
    environment.defaultPackages = [ ];
    services.postgresql = with pkgs; {
      enable = true;
      package = postgresql_14;
      # dataDir = "/var/lib/postgresql/data";
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
      # windowManager.xmonad = {
      #   enableContribAndExtras = true;
      #   enable = true;
      #   extraPackages = haskellPackages : [
      #     haskellPackages.xmonad-contrib
      #     haskellPackages.xmonad-extras
      #     haskellPackages.xmonad
      #     haskellPackages.ghc
      #     haskellPackages.xmobar
      #   ];
      # };

      windowManager.qtile = {
        enable = true;
        backend = "x11";
        extraPackages = python3Packages: with python3Packages; [
          qtile-extras
          psutil
          dbus-python
          pyxdg
          mpd2
          # python-wifi
          # iwlib
          dateutil
          keyring
        ];
      };
      displayManager = {
        lightdm.enable = true;
        #gdm.enable = true;
        defaultSession = "none+qtile";
      };
    };

    programs.fish = {
      enable = true;
      vendor.completions.enable = true;
      shellAliases = {
        gitcfg = "/etc/profiles/per-user/djames/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME";
        ssh-willdoo = "eval \"$(ssh-agent -c)\" && ssh-add ~/.ssh/willdooit";
        ssh-djdc = "eval \"$(ssh-agent -c)\" && ssh-add ~/.ssh/djdc";
        ssh-personal = "eval \"$(ssh-agent -c)\" && ssh-add ~/.ssh/id_rsa";
        display-30hz = "./.screenlayout/home-30hz.sh";
        # wavebox = "flatpak run io.wavebox.Wavebox";
        ansible = "cd ~/.config/nixos/flakes/odoo && nix develop '.#devShells.ansible'";
        odoo16 = "cd ~/.config/nixos/flakes/odoo && nix develop '.#devShells.v16'";
        odoo15 = "cd ~/.config/nixos/flakes/odoo && nix develop '.#devShells.v15'";
        odoo14 = "cd ~/.config/nixos/flakes/odoo && nix develop '.#devShells.v14'";
        odoo13 = "cd ~/.config/nixos/flakes/odoo && nix develop '.#devShells.v13'";
        odoo12 = "cd ~/.config/nixos/flakes/odoo && nix develop '.#devShells.v12'";
        odoo11 = "cd ~/.config/nixos/flakes/odoo && nix develop '.#devShells.v11'";
        odoo10 = "NIXPKGS_ALLOW_INSECURE=1 cd ~/.config/nixos/flakes/odoo && nix develop --impure '.#devShells.v10'";
        odoo9 = "NIXPKGS_ALLOW_INSECURE=1 cd ~/.config/nixos/flakes/odoo && nix develop --impure '.#devShells.v9'";
      };
    };
    # Laptop-specific packages (the other ones are installed in `packages.nix`)
    environment.systemPackages = with pkgs; [
      acpi
      tlp

      fish
      fishPlugins.done
      fishPlugins.fzf-fish
      fishPlugins.forgit
      fishPlugins.hydro
      fzf
      #fishPlugins.grc
      #grc

      killall

      wget
      pkgs.screen

      dmenu
      fira-code

      alacritty
      kitty
      fzf
      silver-searcher

      git
      direnv

      vifm-full

      arandr
      feh

      xfce.thunar

      # haskellPackages.xmobar

      picom
      nitrogen
      pkgs.trayer

      htop
      iotop
      rsync

    ];

    # Install fonts
    fonts = {
        fonts = with pkgs; [
            jetbrains-mono
            roboto
            openmoji-color
            (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
    services.flatpak.enable = true;

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
    users.users.djames = {
        isNormalUser = true;
        extraGroups = [ "input" "wheel" "networkmanager" "docker" ];
        shell = pkgs.fish;
        packages = with pkgs; [
          #conda
          #poetry
          firefox
          google-chrome
          #kate
          jetbrains.pycharm-professional
          vscode
          nano
          # wavebox
          # teams
          # thunderbird
          neovim
          betterlockscreen
          trilium-desktop
          obsidian
          gh
          black
        ];

    };

    # Set up networking and secure it
    networking = {
        #wireless.iwd.enable = true;
        firewall = {
            enable = true;
            allowedTCPPorts = [ 443 80 ];
            allowedUDPPorts = [ 443 80 44857 ];
            allowPing = false;
        };
        networkmanager.enable = true;
    };

    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        XDG_DATA_HOME = "$HOME/.local/share";
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
        GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
        GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
        MOZ_ENABLE_WAYLAND = "1";
        ZK_NOTEBOOK_DIR = "$HOME/stuff/notes/";
        EDITOR = "nvim";
        DIRENV_LOG_FORMAT = "";
        ANKI_WAYLAND = "1";
        DISABLE_QT5_COMPAT = "0";
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

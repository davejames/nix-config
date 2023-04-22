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
            #extraConfig = ''
            #  default-wallpaper=/home/djames/.config/wallpaper/landscape/13.png
            #'';
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
      #settings = {
        #blur = {
        #  method = "gaussian";
        #  size = 3;
        #  deviation = 2.0;
        #  background = false;
        #};
        #corner.radius = 5;
        #opacity = {
        #  rule
        #fading = true;
        #active-opacity = 1;
        #inactive-ipacity = 0.9;
      #};
    };

    services.passSecretService = with pkgs; {
        enable = true;
        package = keepassxc;
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
        pre-commit = "~/dockerfiles/pre-commit.sh";
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
      rofi
      fira-code

      alacritty
      kitty
      fzf
      silver-searcher

      nnn

      git
      direnv

      vifm-full

      arandr
      feh

      xfce.thunar

      # haskellPackages.xmobar

      nitrogen
      pkgs.trayer

      via

      htop
      iotop
      rsync

      keepassxc
      libsecret

      conky

      nerdfonts
    ];

    # Install fonts
    fonts = {
        fonts = with pkgs; [
            jetbrains-mono
            roboto
            openmoji-color
            (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
            (nerdfonts.override { fonts = [ "Monofur" ]; })
            (nerdfonts.override { fonts = [ "Hermit" ]; })
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
    xdg = 
    {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };
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
          firefox
          google-chrome
          brave
          # jetbrains.pycharm-professional
          vscode
          nano
          # neovim
          libreoffice

          # Neovim plugin deps
          # ripgrep
          # fd
          # lazygit
          # vimPlugins.nvim-treesitter
          # vimPlugins.completion-treesitter
          # vimPlugins.nnn-vim
          # perl
          # xclip

          zip
          unzip
          swayimg
          betterlockscreen
          trilium-desktop
          obsidian
          gh
          black

          vlc
          flameshot
          simplescreenrecorder
          
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

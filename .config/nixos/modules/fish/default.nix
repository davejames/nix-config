{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.fish;
in {
  options.modules.fish = {enable = mkEnableOption "fish";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #fish
      grc
      awscli2
      # tide needs to be installed globally: https://github.com/NixOS/nixpkgs/pull/201646#issuecomment-1320893716
      fishPlugins.tide
      # fishPlugins.grc
    ];
    programs.fish = {
      enable = true;
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        # {
        #     name = "grc";
        #     src = pkgs.fishPlugins.grc.src;
        # }
        {
          name = "tide";
          src = pkgs.fishPlugins.tide;
        }
        # Manually packaging and enable a plugin
        {
          name = "pj";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-pj";
            rev = "43c94f24fd53a55cb6b01400b9b39eb3b6ed7e4e";
            sha256 = "sha256-bTyp5j4VcFSntJ7mJBzERgOGGgu7ub15hy/FQcffgRE=";
          };
        }
        {
          name = "aws";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-aws";
            rev = "a4cfb06627b20c9ffdc65620eb29abcedcc16340";
            sha256 = "sha256-bTyp5j4VcFSntJ7mJBzERgOGGgu7ub15hy/FQcffgRE=";
          };
        }
        {
          name = "grc";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-grc";
            rev = "61de7a8a0d7bda3234f8703d6e07c671992eb079";
            sha256 = "sha256-NQa12L0zlEz2EJjMDhWUhw5cz/zcFokjuCK5ZofTn+Q=";
          };
        }
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
            sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          };
        }
      ];
      # vendor.completions.enable = true;
      shellAliases = {
        gitcfg = "/etc/profiles/per-user/djames/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME";
        ssh-willdoo = ''eval "$(ssh-agent -c)" && ssh-add ~/.ssh/willdooit'';
        ssh-djdc = ''eval "$(ssh-agent -c)" && ssh-add ~/.ssh/djdc'';
        ssh-personal = ''eval "$(ssh-agent -c)" && ssh-add ~/.ssh/id_rsa'';
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
  };
}

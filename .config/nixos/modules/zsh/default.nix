{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.zsh;
in {
  options.modules.zsh = {enable = mkEnableOption "zsh";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [zsh fzf fd];

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.zsh = {
      enable = true;

      dotDir = ".config/zsh";

      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;

      oh-my-zsh = {
        enable = true;
        plugins = ["ssh-agent" "command-not-found" "git" "history" "sudo"];
        extraConfig = ''
          zstyle :omz:plugins:ssh-agent agent-forwarding on
          zstyle :omz:plugins:ssh-agent lazy yes
          zstyle :omz:plugins:ssh-agent lifetime 12h
        '';
      };

      localVariables = {
        ENHANCD_FILTER = "fzf --height 40% --layout=reverse --border";
        SPACESHIP_TIME_SHOW = 1;
        SPACESHIP_DIR_TRUNC_REPO = 0;
      };

      initExtra = "";

      history = {
        save = 1000;
        size = 1000;
        path = "$HOME/.cache/zsh_history";
      };

      shellAliases = {
        cgit = "/etc/profiles/per-user/djames/bin/git --git-dir=$HOME/.config/dotfiles-git/ --work-tree=$HOME";
        disp = ''
          echo 'laptop
          home
          work' | fzf --height=40% --layout=reverse --info=inline --border --margin=1 --padding=1 | xargs $HOME/.config/shellscripts/display.sh'';
        search = "$HOME/.config/shellscripts/filesearch.sh";
        pre-commit = "~/dockerfiles/pre-commit.sh";

        cat = "bat --paging=never --style=plain";
        ls = "exa --icons";
      };

      # Source all plugins, nix-style
      plugins = with pkgs; [
        {
          name = "spaceship-prompt";
          src = fetchFromGitHub {
            owner = "spaceship-prompt";
            repo = "spaceship-prompt";
            rev = "aa5887fa2c07f3beaefd52cd6004108f612d1d8d";
            sha256 = "sha256-uFmGld5paCLNnE9yWgBLtthEBfwwMzlGCJFX6KqGJdw=";
          };
          file = "spaceship.zsh";
        }
        {
          name = "zsh-vi-mode";
          src = fetchFromGitHub {
            owner = "jeffreytse";
            repo = "zsh-vi-mode";
            rev = "8cb9a68925f1ec575e5f2384ec631942b089d87c";
            sha256 = "sha256-fSM6L+fwzzzBYP2MWX7UqVzQQV1OBJsJArLmodEFnyU=";
          };
        }
        {
          name = "enhancd";
          file = "init.sh";
          src = fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "v2.5.0";
            sha256 = "sha256-6rurAVbSNqvqSaKVP1p8mHes/DK7uag+CmJmYYiKyHo=";
          };
        }
        {
          name = "nix-shell";
          src = fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.6.0";
            sha256 = "sha256-B0mdmIqefbm5H8wSG1h41c/J4shA186OyqvivmSK42Q=";
          };
        }
      ];
    };
  };
}

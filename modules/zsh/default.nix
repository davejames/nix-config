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
    home.packages = with pkgs; [
      zsh
      fzf
      fd
    ];

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
      syntaxHighlighting.enable = true;

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

      history = {
        save = 1000000;
        size = 1000000;
        path = "$HOME/.cache/zsh_history";
        ignoreSpace = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
        extended = true; # save timestamps
        share = false; # each session has it own history
      };

      shellAliases = {
        pre-commit = "~/dockerfiles/pre-commit.sh";
        cgit = "/etc/profiles/per-user/djames/bin/git --git-dir=$HOME/.config/dotfiles-git/ --work-tree=$HOME";
        disp = ''
          echo 'laptop
          home
          work' | \
          fzf --height=40% --layout=reverse --info=inline --border --margin=1 --padding=1 | \
          xargs $HOME/.config/shellscripts/display.sh
        '';
        cat = "bat --paging=never --style=plain";
        ls = "eza --icons";
        f = "nvim $(fd --type f --strip-cwd-prefix | fzf --border --preview 'bat --color=always {}')";
        s = "$HOME/.config/shellscripts/filesearch.sh";
        vt = ''
          session_name=$(basename "$(pwd)")
          tmux has-session -t "$session_name" 2>/dev/null || {
            tmux new-session -d -x "$(tput cols)" -y "$(tput lines)" -s "$session_name"
            tmux split-pane -l 90% -v -b 'nvim .'
            tmux split-pane -h -l 20%
            tmux select-pane -D
            tmux split-pane -h
          tmux select-pane -t 0
          }
          tmux attach-session -t "$session_name"
        '';
        v = "tmux attach -t `basename $PWD` || tmux new -s `basename $PWD` 'nvim .'";
        pc = "tmux attach -t pycharm || tmux new -s pycharm -d 'pycharm-professional .'";
        p = "pm go $(pm list | fzf)";
      };

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
          name = "pm";
          src = fetchFromGitHub {
            owner = "Angelmmiguel";
            repo = "pm";
            rev = "4de2ab828a90d377b34fdbde18c85f710ab28597";
            sha256 = "sha256-vFy5SRa6mO5AKonkkLeLqHd5HVC/nHf2A84D86GxO4w=";
          };
          file = "zsh/pm.zsh";
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

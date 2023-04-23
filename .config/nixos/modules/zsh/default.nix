{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.zsh;

in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
     	home.packages = with pkgs; [
            zsh
            fzf
            fd
            #pkgs.zsh-powerlevel10k
            #pkgs.spaceship-prompt
        ];

        #home.file.".config/zsh/p10k.zsh".source = ./p10k.zsh;
        programs.zsh = {
            enable = true;

            # directory to put config files in
            # dotDir = ".config/zsh";

            enableCompletion = true;
            enableAutosuggestions = true;
            enableSyntaxHighlighting = true;

            oh-my-zsh = {
                enable = true;
            #    theme = "agnoster";
        
                plugins = [ 
                    "command-not-found"
                    "git"
                    "history"
                    "sudo"
                ];
            };
            # promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            # # .zshrc
            initExtra = ''
                #source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
                #source $HOME/.config/zsh/p10k.zsh

                # Fixes rendering of the prompt when a terminal is resized
                # see: https://github.com/romkatv/powerlevel10k/issues/175
                #function p10k-on-pre-prompt() {}
                #function p10k-on-post-prompt() {}

                export ENHANCD_FILTER="fzf --height 40%:fzy"
                export ENHANCD_USE_ABBREV="true";
            '';
            # initExtra = ''
            #     PROMPT="%F{blue}%m %~%b "$'\n'"%(?.%F{green}%Bλ%b |.%F{red}?) %f"
            #
            #     export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store";
            #     export ZK_NOTEBOOK_DIR="~/stuff/notes";
            #     export DIRENV_LOG_FORMAT="";
            #     bindkey '^ ' autosuggest-accept
            #
            #     edir() { tar -cz $1 | age -p > $1.tar.gz.age && rm -rf $1 &>/dev/null && echo "$1 encrypted" }
            #     ddir() { age -d $1 | tar -xz && rm -rf $1 &>/dev/null && echo "$1 decrypted" }
            # '';
            #
            # # basically aliases for directories: 
            # # `cd ~dots` will cd into ~/.config/nixos
            # dirHashes = {
            #     dots = "$HOME/.config/nixos";
            #     stuff = "$HOME/stuff";
            #     media = "/run/media/$USER";
            #     junk = "$HOME/stuff/other";
            # };
            #
            # # Tweak settings for history
            history = {
                save = 1000;
                size = 1000;
                path = "$HOME/.cache/zsh_history";
            };
            
            shellAliases = {
                gitcfg = "/etc/profiles/per-user/djames/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME";
                ssh-willdoo = "eval \"$(ssh-agent -s)\" && ssh-add ~/.ssh/willdooit";
                ssh-djdc = "eval \"$(ssh-agent -s)\" && ssh-add ~/.ssh/djdc";
                ssh-personal = "eval \"$(ssh-agent -s)\" && ssh-add ~/.ssh/id_rsa";
                display-home = "$HOME/.screenlayout/home-auto.sh home";
                display-work = "$HOME/.screenlayout/home-auto.sh work";
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
            #
            # # Set some aliases
            # shellAliases = {
            #     c = "clear";
            #     mkdir = "mkdir -vp";
            #     rm = "rm -rifv";
            #     mv = "mv -iv";
            #     cp = "cp -riv";
            #     cat = "bat --paging=never --style=plain";
            #     ls = "exa -a --icons";
            #     tree = "exa --tree --icons";
            #     nd = "nix develop -c $SHELL";
            #     rebuild = "doas nixos-rebuild switch --flake $NIXOS_CONFIG_DIR --fast; notify-send 'Rebuild complete\!'";
            # };
            #
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
                    name = "enhancd";
                    file = "init.sh";
                    src = fetchFromGitHub {
                        owner = "b4b4r07";
                        repo = "enhancd";
                        rev = "v2.5.1";
                        sha256 = "sha256-kaintLXSfLH7zdLtcoZfVNobCJCap0S/Ldq85wd3krI=";
                    };
                }
                {
                    name = "zsh-completions";
                    src = fetchFromGitHub {
                        owner = "zsh-users";
                        repo = "zsh-completions";
                        rev = "0.34.0";
                        sha256 = "sha256-qSobM4PRXjfsvoXY6ENqJGI9NEAaFFzlij6MPeTfT0o=";
                    };
                }
                {
                    name = "zsh-history-substring-search";
                    src = fetchFromGitHub {
                        owner = "zsh-users";
                        repo = "zsh-history-substring-search";
                        rev = "400e58a87f72ecec14f783fbd29bc6be4ff1641c";
                        sha256 = "sha256-GSEvgvgWi1rrsgikTzDXokHTROoyPRlU0FVpAoEmXG4=";
                    };
                }
                {
                    name = "zsh-syntax-highlighting";
                    src = fetchFromGitHub {
                        owner = "zsh-users";
                        repo = "zsh-syntax-highlighting";
                        rev = "754cefe0181a7acd42fdcb357a67d0217291ac47";
                        sha256 = "sha256-kWgPe7QJljERzcv4bYbHteNJIxCehaTu4xU9r64gUM4=";
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

{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.tmux;
  mkTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
  treemuxCustom = mkTmuxPlugin {
    pluginName = "treemux";
    version = "unstable-2023-03-22";
    src = pkgs.fetchFromGitHub {
      owner = "kiyoon";
      repo = "treemux";
      rev = "669df7ad270a6c1fb3542ad0e404ce570aaf88d1";
      sha256 = "sha256-LErGRg9fMcQsU8EFx3QJaNnRsEZyhxyjnneJaZ4M9cs=";
    };
  };
  tmuxPlugins = pkgs.tmuxPlugins // {treemux = treemuxCustom;};
in {
  options.modules.tmux = {enable = mkEnableOption "tmux";};
  config = mkIf cfg.enable {
    programs.neovim.enable = true;
    programs.tmux = {
      enable = true;
      terminal = "screen-256color";
      extraConfig = ''
        tmux_conf_24b_colour=auto
        set-option -sa terminal-overrides ',alacritty:RGB'
        set-option -sg escape-time 10

        # remap prefix from 'C-b' to 'C-a'
        unbind C-b
        set-option -g prefix C-a
        bind-key C-a send-prefix

        # split panes using | and -
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # switch panes using Alt-arrow without prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Enable mouse control
        set -g mouse on

        # don't rename windows automatically
        set-option -g allow-rename off
      '';
      plugins = with tmuxPlugins; [
        {
          plugin = treemux;
          extraConfig = ''
            set -g @treemux-tree-nvim-init-file '${treemux}/configs/treemux_init.lua'
            set -g @plugin 'kiyoon/treemux'
          '';
        }
        {
          plugin = power-theme;
          extraConfig = "set -g @tmux_power_theme '#${config.colorScheme.colors.base0D}'";
        }
      ];
    };
  };
}

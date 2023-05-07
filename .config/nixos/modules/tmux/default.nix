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
    programs.tmux = {
      enable = true;
      terminal = "screen-256color";
      extraConfig = ''
        tmux_conf_24b_colour=auto
        set -g @plugin 'kiyoon/treemux'
      '';

      plugins = with tmuxPlugins; [treemux];
    };
  };
}

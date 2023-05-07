{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        git.enable = true;
        nvim.enable = true;
        jetbrains = {
            pycharm.enable = true;
        };
        alacritty.enable = true;
        docker.enable = true;
        tmux.enable = true;
        #fish.enable = true;
        zsh.enable = true;
        shellScripts.enable = true;
        # postgresql.enable = true;
        # cli
    };

    config.xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "firefox";
          "image/png" = "feh.desktop";
          "image/jpg" = "feh.desktop";
          "image/jpeg" = "feh.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/chrome" = "firefox.desktop";
          "text/html" = "firefox.desktop";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
          "application/schema+json" = "nvim.desktop";
      };
        associations.added = {
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/chrome" = "firefox.desktop";
          "text/html" = "firefox.desktop";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
        };
      };

}

{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.vscode;
  odoo-vscode = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "trinhanhngoc";
      name = "vscode-odoo";
      version = "0.19.3";
      sha256 = "sha256-LM4H/tQLuEpuYW3tIqUwT5SDzJFmRzBO5WZfPFI6yU0=";
      arch = "linux-x64";
    };
    buildInputs = [pkgs.nodePackages.pyright];
    meta = {
      changelog = "https://marketplace.visualstudio.com/items/trinhanhngoc.vscode-odoo/changelog";
      description = "Odoo Framework Integration for Visual Studio Code";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=trinhanhngoc.vscode-odoo";
      homepage = "https://github.com/odoo-ide/vscode-odoo";
      license = lib.licenses.unfree;
    };
  };
in {
  options.modules.vscode = {enable = mkEnableOption "vscode";};
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        odoo-vscode
        ms-python.python
        github.copilot
        github.copilot-chat
        github.vscode-github-actions
        github.vscode-pull-request-github
        genieai.chatgpt-vscode
        tamasfe.even-better-toml
      ];
    };
  };
}

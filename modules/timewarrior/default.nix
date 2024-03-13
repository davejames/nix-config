{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.timewarrior;
  timewarrior = pkgs.customPackages.timewarrior;
  timew-fzf = pkgs.customPackages.timewarriorPlugins.timew-fzf;
in {
  options.modules.timewarrior = {enable = mkEnableOption "timewarrior";};
  config = mkIf cfg.enable {
    home.packages = [
      timewarrior
    ];
    home.file.".config/timewarrior/timewarrior.cfg".text = ''
      import ${pkgs.timewarrior}/share/doc/timew/themes/dark_red.theme

      define exclusions:
        monday    = <8:00 >18:00
        tuesday   = <8:00 >18:00
        wednesday = <8:00 >18:00
        thursday  = <8:00 >18:00
        friday    = <8:00 >18:00
        saturday  = >0:00
        sunday    = >0:00
    '';
    home.file.".config/timewarrior/extensions/twfzf.py".source = "${timew-fzf}/twfzf.py";
    programs.taskwarrior.enable = true;
  };
}

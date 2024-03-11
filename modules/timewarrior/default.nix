{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.timewarrior;

  # timew-report = pkgs.python3Packages.buildPythonPackage rec {
  #   pname = "timew-report";
  #   version = "1.4.0";
  #
  #   src = pkgs.fetchPypi {
  #     inherit pname version;
  #     sha256 = "sha256-Q57E3aYiFf80eXEJXZlWZni+PJ48Xb7NuL7VH9RCL5A=";
  #   };
  #
  #   propagatedBuildInputs = with pkgs.python3Packages; [
  #     pip
  #     setuptools
  #     wheel
  #     deprecation
  #     python-dateutil
  #   ];
  #
  #   meta = with lib; {
  #     changelog = "https://github.com/lauft/timew-report/releases/tag/v${version}";
  #     description = "timew-report: An interface for Timewarrior report";
  #     homepage = "https://github.com/lauft/timew-report";
  #     license = licenses.mit;
  #   };
  # };
  # timewarrior = pkgs.timewarrior.overrideAttrs (oldAttrs: {
  #   nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];
  #   postInstall = with pkgs.python3Packages; oldAttrs.postInstall or "" + ''
  #     wrapProgram $out/bin/timew \
  #       --prefix PATH : ${lib.makeBinPath [ pkgs.python3 pyfzf plumbum timew-report ]} \
  #       --set PYTHONPATH "${pkgs.python3.pkgs.makePythonPath [ pyfzf plumbum timew-report ]}"
  #   '';
  # });
  #
  # timew-fzf = pkgs.fetchFromGitHub {
  #   owner = "oivvio";
  #   repo = "timew-fzf";
  #   rev = "69923ebb03c87f7a1cbbba79829e9b5339c0cd92";
  #   sha256 = "sha256-9tULvmp75vpwG7fvVCfsNcU+fj+hNg8gLFnVH0jX7N4=";
  # };

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

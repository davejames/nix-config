{
  pkgs,
  ...
}:
let
  pyPackages = pkgs.python3Packages;
  timew-report = pyPackages.buildPythonPackage rec {
    pname = "timew-report";
    version = "1.4.0";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-Q57E3aYiFf80eXEJXZlWZni+PJ48Xb7NuL7VH9RCL5A=";
    };

    propagatedBuildInputs = with pyPackages; [
      pip
      setuptools
      wheel
      deprecation
      python-dateutil
    ];

    meta = {
      changelog = "https://github.com/lauft/timew-report/releases/tag/v${version}";
      description = "timew-report: An interface for Timewarrior report";
      homepage = "https://github.com/lauft/timew-report";
      license = pkgs.lib.licenses.mit;
    };
  };
  timewarriorApp = pkgs.timewarrior.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];
    postInstall = with pyPackages; oldAttrs.postInstall or "" + ''
      wrapProgram $out/bin/timew \
        --prefix PATH : ${pkgs.lib.makeBinPath [ python pyfzf plumbum timew-report ]} \
        --set PYTHONPATH "${python.pkgs.makePythonPath [ pyfzf plumbum timew-report ]}"
    '';
  });

  timew-fzf = pkgs.fetchFromGitHub {
    owner = "oivvio";
    repo = "timew-fzf";
    rev = "69923ebb03c87f7a1cbbba79829e9b5339c0cd92";
    sha256 = "sha256-9tULvmp75vpwG7fvVCfsNcU+fj+hNg8gLFnVH0jX7N4=";
  };

in {
  timewarrior = timewarriorApp;
  timewarriorPlugins = {
    timew-fzf = timew-fzf;
    timewarriorPlugins.timew-report = timew-report;
  };
}

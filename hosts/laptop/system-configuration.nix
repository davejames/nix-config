{...}: {
  imports = [
    ../../modules/system/default.nix
  ];

  config.modules = {
    qtile.enable = true;
  };
}

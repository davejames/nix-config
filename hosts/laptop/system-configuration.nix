{...}: {
  imports = [
    ../../modules/system/default.nix
  ];

  config.services.zerotierone = {
    enable = true;
  };

  config.modules = {
    qtile.enable = true;
  };
}

{
  description = "NixOS configuration";

  # All inputs for the system
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    
    willdooit-dev-cli.url = "git+ssh://git@github.com/WilldooIT-Private/willdooit-dev-cli?ref=main";
    willdooit-commitizen.url = "git+ssh://git@github.com/WilldooIT-Private/willdooit-commitizen?ref=flake-fix";
    erosanix= {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # All outputs for the system (configs)
  outputs = {
    home-manager,
    nixpkgs-stable,
    ...
  } @ inputs: let
    overlay = final: prev: {
      stable = import nixpkgs-stable {
        system = prev.system;
        config.allowUnfree = true;
      };
      customPackages = import ./packages/packages.nix { pkgs = prev.pkgs; };
    };

    # This lets us reuse the code to "create" a system
    # Credits go to sioodmy on this one!
    # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
    mkSystem = pkgs: system: hostname:
    pkgs.lib.nixosSystem {
        inherit system;
        # system = system;
        modules = [
          {
            networking.hostName = hostname;
            nixpkgs.overlays = [
              overlay
              # (import ./overlay.nix { pkgs = pkgs; })
            ];
          }
          # General configuration (users, networking, sound, etc)
          ./modules/system/configuration.nix
          # Hardware config (bootloader, kernel modules, filesystems, etc)
          # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
          (./. + "/hosts/${hostname}/hardware-configuration.nix")
          (./. + "/hosts/${hostname}/system-configuration.nix")
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {inherit inputs;};
              users.djames = ./. + "/hosts/${hostname}/user.nix";
            };
          }
        ];
        specialArgs = {inherit inputs;};
      };
  in {
    nixosConfigurations = {
      # Now, defining a new system is can be done in one line
      #                                Architecture   Hostname
      laptop = mkSystem inputs.nixpkgs "x86_64-linux" "laptop";
      # desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
    };
  };
}

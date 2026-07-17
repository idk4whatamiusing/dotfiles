{
  description = "Nix + nix-darwin + home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in {
      darwinConfigurations."x" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./home-manager/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users."x" = {
                imports = [ ./home-manager/home.nix ];
                home = {
                  username = lib.mkForce "x";
                  homeDirectory = lib.mkForce "/Users/x";
                };
              };
            };
          }
        ];
      };

      # Standalone home-manager kept for reference (deprecated in favor of darwin)
      homeConfigurations."x" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-manager/home.nix ];
      };
    };
}

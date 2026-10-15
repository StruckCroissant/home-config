{
  description = "Home Manager configuration of struckcroissant";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      exports = [
        ./programs
        ./home
      ];

      homeConfigurations."struckcroissant" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
      };

      # The exported modules alone, for a generic user. See "Trying the base
      # config" in the README.
      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = self.exports ++ [
          {
            home.username = "default";
            home.homeDir = "/home/default";
          }
        ];
      };

      # `nix shell .` puts the base profile's packages on PATH.
      packages.${system}.default = pkgs.buildEnv {
        name = "home-config-base";
        paths = self.homeConfigurations.default.config.home.packages;
      };
    };
}

{
  description = "Home Manager configuration of Dakota";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;
      config = pkgs.config;
      stateVersion = "24.05";
      metadata = rec {
        userName = "Dakota Vaughn";
        username = "struckcroissant";
        homeDirectory = "/home/${username}";
        host = "Hub";
        email = "32440863+StruckCroissant@users.noreply.github.com";
      };
      home = import ./home.nix { 
        inherit metadata pkgs lib stateVersion config; 
      };
    in {
      home-manager.backupFileExtension = ".bkup";
      homeConfigurations."${metadata.username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ home ];
      };
    };
}

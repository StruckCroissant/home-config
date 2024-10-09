{
  description = "Home manager base config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;
      config = pkgs.config;
      stateVersion = "24.05";
      metadata = {
        inherit (import ./variables.nix)
	  userName
	  username
	  homeDirectory
	  host
	  email;
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

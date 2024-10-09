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
    in { 
      generate = { username, userName, host, email, homeDirectory ? "" }: 
        let
  	  metadata = {
            username = username;
            userName = userName;
	    host = host;
	    email = email;
            homeDirectory = if builtins.stringLength homeDirectory == 0 
              then "/home/${username}" 
    	      else homeDirectory;
	  };
        in {
          home-manager.backupFileExtension = ".bkup";
          homeConfigurations."${metadata.username}" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
   
            modules = [ 
  	      (import ./home.nix { 
                inherit metadata pkgs lib stateVersion config; 
              })
            ];
          };
        };
    };
}

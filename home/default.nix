{ config, pkgs, lib, ... }:
let
 cfg = config.home;
in
{
  options.home = {
    homeDir = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
    };
  };

  config = {
    home.homeDirectory = if cfg.homeDir != null 
      then cfg.homeDir 
      else "/home/${config.home.username}";
  
    home.stateVersion = "24.05"; 
  
    home.packages = with pkgs; [
      nerdfonts
      pv
      jq
      direnv
    ];
  
    home.sessionVariables = {
      EDITOR = "nvim";
    };
  
    home.shellAliases = {
      "hm" = "home-manager";
      "ls" = "ls --color=auto";
      "grep" = "grep --color=auto";
    };
  };
}

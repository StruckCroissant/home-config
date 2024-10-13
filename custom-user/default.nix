{ config, pkgs, lib, ... }:
let
 cfg = config.custom-user;
in
{
  options.custom-user = {
    username = lib.mkOption {
      type = lib.types.str;
    };
    aliases = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
    };
    packages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
    };
    homeDir = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
    };
  };

  config = {
    home.username = cfg.username;
    home.homeDirectory = if cfg.homeDir != null 
      then cfg.homeDir 
      else "/home/${cfg.username}";
  
    home.stateVersion = "24.05"; 
  
    home.packages = with pkgs; [
      nerdfonts
      pv
      jq
    ] ++ cfg.packages;
  
    home.sessionVariables = {
      EDITOR = "nvim";
    };
  
    home.shellAliases = lib.mkMerge [
      {
        "hm" = "home-manager";
        "ls" = "ls --color=auto";
        "grep" = "grep --color=auto";
      }
      cfg.aliases
    ];
  };
}
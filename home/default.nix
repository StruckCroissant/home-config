{ config, pkgs, lib, ... }:
let
 username = "struckcroissant";
 homeDir = "/home/${username}";
 projectRoot = builtins.getEnv "PWD";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${username}";
  home.homeDirectory = "${homeDir}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    nerdfonts
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "${projectRoot}/home/bin"
  ];

  home.shellAliases = {
    "hm" = "home-manager";
    "ls" = "ls --color=auto";
    "grep" = "grep --color=auto";
  };
}
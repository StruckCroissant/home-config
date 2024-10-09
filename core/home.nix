{ config, pkgs, lib, metadata, stateVersion, ... }:
let
 username = metadata.username;
 homeDir = metadata.homeDirectory;
 userName = metadata.userName;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${username}";
  home.homeDirectory = "${homeDir}";

  home.stateVersion = stateVersion;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nerdfonts
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    "hm" = "home-manager";
    "ls" = "ls --color=auto";
    "grep" = "grep --color=auto";
  };

  programs.home-manager = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
    ${homeDir}/.config/home-manager/core/config/.bashrc
    '';
    enableCompletion = true;
  };

  programs.git = {
    enable = true;
    userName = metadata.userName;
    userEmail = metadata.email;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      lightline-vim
    ];
    extraConfig = ''
      set rnu
      set number
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = lib.concatStrings [
        "[░▒▓](#a3aed2)"
        "[  ](bg:#a3aed2 fg:#090c0c)"
        "[](bg:#769ff0 fg:#a3aed2)"
        "$directory"
        "[](fg:#769ff0 bg:#394260)"
        "$git_branch"
        "$git_status"
        "[](fg:#394260 bg:#212736)"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "[](fg:#212736 bg:#1d2230)"
        "$time"
        "[ ](fg:#1d2230)"
        "\n$character"
      ];
      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      directory.substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
      };
      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };
      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };
      nodejs = {
        symbol = "";
	      style = "bg:#212736";
	      format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };
    };
  };

  programs.dircolors = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
  };
}

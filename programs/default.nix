{ config, pkgs, lib, ... }:
let
 username = "struckcroissant";
 homeDir = "/home/${username}";
in
{
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
    bashrc_files=$(find  -maxdepth 1 -regex "^\./\.bashrc\..*$")
    for file in $bashrc_files; do
      source "$file"
    done
    '';
    enableCompletion = true;
  };

  programs.git = {
    enable = true;
    userName = "StruckCroissant";
    userEmail = "32440863+StruckCroissant@users.noreply.github.com";
  };

  programs.git.delta = {
    enable = true;
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
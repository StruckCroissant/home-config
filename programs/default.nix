{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs;
  concatNewlines = lib.lists.fold (l: r: l + "\n" + r) "";
in
{
  options.programs = {
    backupExtension = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
    };
  };

  config = {
    programs.home-manager.enable = true;

    home.file.".bashinit-autoload" = {
      recursive = true;
      executable = true;
      enable = true;
      source = ./autoload-interactive;
    };
    programs.bash = {
      enable = true;
      bashrcExtra =
        let
          backupExtension = cfg.backupExtension;
        in
        concatNewlines [
          (
            if cfg.backupExtension != null then
              ''
                if [ -f "$HOME/.bashrc.${backupExtension}" ]; then
                  source "$HOME/.bashrc.${backupExtension}"
                fi
              ''
            else
              ""
          )
        ];
      initExtra = ''
        files=$(find "./.bashinit-autoload" -type f,l)
        for file in $files; do
          source "$file"
        done
      '';
      enableCompletion = true;
    };

    programs.git = {
      enable = true;
    };

    programs.git.delta = {
      enable = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        fidget-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        vim-tmux-navigator
        catppuccin-nvim
        lualine-nvim
        luasnip
        cmp_luasnip
        telescope-nvim
        plenary-nvim
        nvim-treesitter.withAllGrammars
      ];
      extraLuaConfig = (builtins.readFile ./nvim.lua);
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        format = lib.concatStrings [
          "[  $username@$hostname ](bold bg:#a3aed2 fg:#090c0c)"
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
          "[](fg:#212736)"
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
        hostname = {
          format = "$hostname";
          ssh_only = false;
        };
        username = {
          format = "$user";
          show_always = true;
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
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        catppuccin
      ];
    };
  };
}

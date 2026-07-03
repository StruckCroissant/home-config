{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs;
  concatNewlines = lib.lists.foldr (l: r: l + "\n" + r) "";
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
        files=$(find "$HOME/.bashinit-autoload" -type f,l)
        for file in $files; do
          source "$file"
        done

	export SUDO_EDITOR=$(which nvim)
      '';
      enableCompletion = true;
    };

    programs.git = {
      enable = true;

      settings = {
        rebase = {
          instructionFormat = "%s (A: %an, C: %cn)%d";
        };
        rerere.enabled = true;
        push.autoSetupRemote = true;
      };
    };

    programs.delta = {
      enable = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      # Keep the Ruby/Python3 providers on: nvim.lua sets ruby_host_prog and
      # python3_host_prog. nixpkgs 26.05 flipped these defaults to false.
      withRuby = true;
      withPython3 = true;
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
      initLua = (builtins.readFile ./nvim.lua);
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      settings = {
        # The main prompt format
        format = "[┌─](bold white)$username$directory$git_branch$git_status$cmd_duration\n$character";

        # The L-shaped connector for the multiline prompt
        character = {
          success_symbol = "[└─>](bold white)";
          error_symbol = "[└─>](bold red)";
        };

        # Command duration config ("took 8s591ms")
        cmd_duration = {
          min_time = 500;
          format = "took [$duration](bold yellow) ";
        };

        username = {
          show_always = true;
          format = "[$user](bold yellow) ";
        };

        hostname = {
          ssh_only = false;
          format = "on [$hostname](bold pink) ";
        };

        directory = {
          format = "in [$path](bold cyan) ";
        };

        git_branch = {
          symbol = "🌱 ";
          format = "on [$symbol$branch](bold purple) ";
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
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavor 'mocha' # or frappe, macchiato, latte
            set -g @catppuccin_window_status_style "rounded"
            
            # These lines are now required to actually show the modules
            set -g status-right-length 100
            set -g status-left-length 100
            set -g status-left ""
            set -g status-right "#{E:@catppuccin_status_application}"
            set -ag status-right "#{E:@catppuccin_status_session}"
            set -ag status-right "#{E:@catppuccin_status_uptime}"
          '';
        }
      ];
      extraConfig = ''
        bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
        bind -n WheelDownPane select-pane -t= \; send-keys -M
        bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
        bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
        bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
        bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
        bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down
      '';
    };
  };
}

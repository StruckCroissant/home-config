{ config, pkgs, lib, ... }:
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
  
    programs.bash = {
        enable = true;
        bashrcExtra = 
	let
	 backupExtension = cfg.backupExtension;
	in concatNewlines [ 
          (
	    if cfg.backupExtension != null 
	    then ''
              if [ -f "./.bashrc.${backupExtension}" ]; then
                source "./.bashrc.${backupExtension}"
              fi
            '' 
            else ""
	  )
	 ];
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
        lightline-vim
	fidget-nvim
	nvim-lspconfig
	nvim-cmp
	cmp-nvim-lsp
	vim-tmux-navigator
	catppuccin-nvim
      ];
      extraConfig = ''
        set rnu
        set number
      '';
      extraLuaConfig = ''
        require('fidget').setup {}
	
        local cmp = require('cmp')

        cmp.setup({
          snippet = {
            expand = function(args)
              vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
          }, {
            { name = 'buffer' },
          })
        })
        
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        require('lspconfig').nil_ls.setup {
    	  capabilities = capabilities,
          autostart = true,
          settings = {
            ['nil'] = {
              formatting = {
  	        command = { "nixfmt" },
   	      },
	    },
	  },
	}
	
	local catppuccin = require("catppuccin")
	vim.cmd[[colorscheme catppuccin]]
	vim.cmd[[let g:lightline = {'colorscheme': 'catppuccin'}]]
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
      plugins = with pkgs.tmuxPlugins; [
      	sensible
        vim-tmux-navigator
	catppuccin
      ];
    };
  };
}

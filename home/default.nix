{
  config,
  pkgs,
  lib,
  ...
}:
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
    home.homeDirectory = if cfg.homeDir != null then cfg.homeDir else "/home/${config.home.username}";

    home.stateVersion = "25.11";

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

    home.packages =
      with pkgs;
      [
        pv
        jq
        direnv
        getopt
        htop
        nil
        nixfmt
        lua-language-server
        bash-language-server
        shellcheck
        ripgrep
        fd
	      docker_29
        nerd-fonts.hack

        # CLI utilities
        bat
        less
        yq
        tree
        glow

        # JS/TS dev tooling
        typescript
        typescript-language-server
        vue-language-server
        vsce
        devcontainer

        claude-code
      ]
      ++ [ (writeShellScriptBin "hm" (with builtins; (toString (readFile ./commands/hm.sh)))) ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.shellAliases = {
      "ls" = "ls --color=auto";
      "grep" = "grep --color=auto";
    };
  };
}

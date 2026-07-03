# home-config

A reusable [Home Manager](https://github.com/nix-community/home-manager) **base
configuration**, published as flake modules so downstream machine/user configs
can inherit a common shell, editor, prompt, and tooling setup.

It is consumed by per-machine configs (e.g. a work laptop) which import these
modules and layer their own machine-specific bits on top.

## What it provides

**Programs** (`programs/default.nix`, plus `programs/nvim.lua`):
- **bash** with completion and an interactive autoload dir (`~/.bashinit-autoload`)
- **git** (+ **delta** pager); `rerere`, `push.autoSetupRemote`, a readable rebase format
- **neovim** — LSP (`nil`, `lua_ls`, bash), `nvim-cmp`, treesitter highlighting,
  telescope, catppuccin, lualine; set as the default editor
- **starship** — the multiline `┌─` prompt
- **tmux** — catppuccin (mocha), `vim-tmux-navigator` (seamless `C-h/j/k/l`),
  mouse + wheel scrolling, **tmux-fzf** (`prefix + F` menu), and a **sesh**
  session palette on **`prefix + o`**; tmuxinator support is available for
  downstream projects
- **fzf** + **zoxide** (power the sesh palette)
- **dircolors**

**Packages** (`home/default.nix`): core CLI (`ripgrep`, `fd`, `jq`, `yq`, `bat`,
`tree`, `glow`, `htop`, `direnv`, …), Nix tooling (`nil`, `nixfmt`), language
servers (`lua`, `bash`), JS/TS tooling (`typescript`, `typescript-language-server`,
`vue-language-server`, `vsce`, `devcontainer`), `docker_29`, `sesh`, `claude-code`,
the Hack Nerd Font, and the `hm` helper (below).

**Options**: `home.homeDir` (override the default `/home/<username>`) and
`programs.backupExtension`.

## Consuming this as a base

Add it as a flake input and append its exported modules:

```nix
# flake.nix
inputs.core-config.url = "github:StruckCroissant/home-config/main";

# in your homeManagerConfiguration:
modules = [ ./home.nix ] ++ inputs.core-config.exports;
```

`exports` is `[ ./programs ./home ]`. Your own `home.nix` sets machine-specific
values (`home.username`, git identity, extra packages) and can override base
values via the normal module system.

## Building this repo's own config

This flake also defines a standalone config for the maintainer:

```bash
home-manager switch --flake .#struckcroissant
```

## The `hm` helper

`hm` wraps `home-manager` and can refresh flake inputs first:

```bash
hm switch          # = home-manager switch
hm -p switch       # nix flake update core-config, then switch
hm -a switch       # update all inputs, then switch
hm edit            # open ~/.config/home-manager in vim
```

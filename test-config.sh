#!/bin/bash

set -eu;

USER="${1:-default}"
USER_HOME="${2:-/home/default}"

# A new volume starts root-owned. Single-user Nix as uid 1000 must own the
# store, and the user must own the home.
if ! docker volume inspect hm-nix hm-home >/dev/null 2>&1; then
  docker run --rm -v hm-nix:/nix -v hm-home:"$USER_HOME" nixos/nix \
    chown -R 1000:1000 /nix "$USER_HOME"
fi

docker run \
  --rm \
  -it \
  --user 1000:1000 \
  -e USER="$USER" \
  -e HOME="$USER_HOME" \
  -e NIX_CONFIG='experimental-features = nix-command flakes' \
  -v "$PWD":/src:ro \
  -v hm-nix:/nix \
  -v hm-home:"$USER_HOME" \
  -v "./:$USER_HOME/.config/home-manager" \
  nixos/nix bash -c '
    nix run path:/src#homeConfigurations.default.activationPackage && \
    PATH=~/.nix-profile/bin:$PATH exec bash -l'
    

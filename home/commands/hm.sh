#!/bin/bash

set -eu;

BASE_WORKING_DIR="$(pwd)"
HOME_CONFIG_DIR="${HOME}/.config/home-manager"

PASSTHROUGH_ARGS=()
PULL=0
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--pull)
      PULL=1
      shift
      ;;
    edit)
      vim "$HOME_CONFIG_DIR"
      exit
      ;;
    *)
      PASSTHROUGH_ARGS+=("$1")
      shift
      ;;
  esac
done

function pull() {
  cd "$HOME_CONFIG_DIR"
  echo "Pulling config file..."
  nix flake update
  cd "$BASE_WORKING_DIR"
}

if [ $PULL -eq 1 ]; then
  pull
  if [ "${#PASSTHROUGH_ARGS[@]}" -eq 0 ]; then
    exit
  fi
fi

home-manager "${PASSTHROUGH_ARGS[@]}"

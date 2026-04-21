#!/bin/bash

set -eu;

BASE_WORKING_DIR="$(pwd)"
HOME_CONFIG_DIR="${HOME}/.config/home-manager"
HOME_CONFIG_FLAKE_NAME="${HOME_CONFIG_FLAKE_NAME:-core-config}"

PASSTHROUGH_ARGS=()
PULL=0
PULL_FLAKES=()
PULL_ALL=0

while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--pull)
      PULL=1
      if [[ -n "$2" && "$2" != -* ]]; then
        PULL_FLAKES+=("${2}")
	shift 2
      else
        PULL_FLAKES+=("${HOME_CONFIG_FLAKE_NAME}")
	shift
      fi
    ;;
    -a|--pull-all)
      PULL_ALL=1
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
  FLAKES_TO_PULL=("$@")
  cd "$HOME_CONFIG_DIR"
  echo "Pulling config file..."
  nix flake update "${FLAKES_TO_PULL[@]}"
  cd "$BASE_WORKING_DIR"
}

echo "${PULL_FLAKES[@]}"

if [ $PULL_ALL -eq 1 ]; then
  pull  
elif [ $PULL -eq 1 ]; then
  pull "${PULL_FLAKES[@]}"
fi


if [ "${#PASSTHROUGH_ARGS[@]}" -eq 0 ]; then
  exit
fi

home-manager "${PASSTHROUGH_ARGS[@]}"


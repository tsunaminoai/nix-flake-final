#!/usr/bin/env bash

pushd scripts
sh ./nix-install.sh

nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake github:tsunaminoai/nix-flake-final#`hostname`

popd
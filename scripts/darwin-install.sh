#!/usr/bin/env bash

pushd scripts
sh ./nix-install.sh
popd 
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

darwin-rebuild --show-trace --flake .#$HOST switch 
#!/usr/bin/env bash
system=$(uname)
if [ ! -z $1 ]; then
	export HOST=$1
else
	export HOST=$(hostname)
fi

if [ $system != "Darwin" ]; then
	sudo nixos-rebuild --show-trace --flake .#$HOST switch |& nom
else 
    dawrin-rebuild --show-trace --flake .#$HOST switch |& nom
fi


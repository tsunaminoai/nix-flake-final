#!/usr/bin/env bash
system=$(uname)
if [ ! -z $1 ]; then
	export HOST=$1
else
	export HOST=$(hostname)
fi

if [ $system != "Darwin" ]; then
	sudo nixos-rebuild --flake .#$HOST boot
fi

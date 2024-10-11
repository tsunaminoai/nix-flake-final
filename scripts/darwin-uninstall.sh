#!/usr/bin/env bash

# Restore shells
sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc

# stop daemons
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist

# remove build group
sudo dscl . -delete /Groups/nixbld
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete /Users/$u; done

echo "Launching vifs. Remove /nix...please"
read 
sudo vifs

sudo sed -i -e "s/nix//g" /etc/synthetic.conf 

sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels 
rm -rf ~/.nix-profile ~/.nix-defexpr ~/.nix-channels

sudo diskutil apfs deleteVolume /nix
sudo security delete-generic-password  -a "Nix Store" -s "Nix Store" -l "disk3 encryption password" -D "Encrypted volume password"
diskutil list

echo "Make sure that /nix is not above."
echo "if it is, run: sudo diskutil apfs deleteVolume diskXsY"
{
  lib,
  inputs,
  ...
}: let
in {
  imports = [
    #################### Required Configs ####################
    ./common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix

    #################### Optional Configs ####################
    common/optional/neofetch
    common/optional/alacritty.nix
    common/optional/gh.nix
  ];
  # Disable impermanence
  #home.persistence = lib.mkForce { };
}

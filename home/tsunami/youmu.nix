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
    common/optional/helper-scripts
    common/optional/gh.nix
    common/optional/alacritty.nix
    common/optional/neofetch
  ];
  # Disable impermanence
  #home.persistence = lib.mkForce { };
}

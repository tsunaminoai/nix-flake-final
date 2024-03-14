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
    # common/optional/bitwarden.nix # needs more evaluation and thought before enabling
  ];
  # Disable impermanence
  #home.persistence = lib.mkForce { };
  home.homeDirectory = "/Users/tsunami";
}

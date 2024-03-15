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
  ];
  # Disable impermanence
  #home.persistence = lib.mkForce { };

  # Overrides for work
  home = {
    homeDirectory = "/Users/bcraton";
    home.username = "bcraton";
  };

  programs.git = {
    userName = "Ben Craton";
    userEmail = "bcraton@passageways.com";
  };
}

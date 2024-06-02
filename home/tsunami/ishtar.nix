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
    common/optional/dev
    common/optional/editors
    common/optional/office
  ];
  # Disable impermanence
  #home.persistence = lib.mkForce { };
}

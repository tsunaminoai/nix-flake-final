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

    common/optional/vscode-server.nix
    common/optional/dev
    common/optional/desktops
    common/optional/browsers
    common/optional/comms
  ];
  # Disable impermanence
  #home.persistence = lib.mkForce { };
}

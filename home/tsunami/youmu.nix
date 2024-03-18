{
  lib,
  inputs,
  ...
}: let
  homeDirectory = "/Users/tsunami";
in {
  imports = [
    #################### Required Configs ####################
    ./common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix
    common/optional/helper-scripts
    common/optional/neofetch
    common/optional/borg
    # common/optional/bitwarden.nix # needs more evaluation and thought before enabling
  ];
  services.borg-backup = {
    enable = true;
    repo_id = "8568dc33";
    root_directory = homeDirectory;
  };
  # Disable impermanence
  #home.persistence = lib.mkForce { };
  home.homeDirectory = homeDirectory;
}

{...}: {
  imports = [
    #################### Required Configs ####################
    ./common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix
    common/optional/dev
    common/optional/neofetch
    common/optional/media
    common/optional/office
    common/optional/editors
  ];
  # Disable impermanence
  #home.persistence = lib.mkForce { };
  home.homeDirectory = "/Users/tsunami";
}

{...}: {
  imports = [
    #################### Required Configs ####################
    ./common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix
    common/optional/helper-scripts

    common/optional/dev
    common/optional/desktops
    common/optional/browsers
    common/optional/comms
    common/optional/tools
    common/optional/office
    common/optional/editors
  ];
  services.vscode-server.enable = true;
  # Disable impermanence
  #home.persistence = lib.mkForce { };
}

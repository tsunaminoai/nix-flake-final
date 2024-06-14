{
  pkgs,
  ...
}: {
  imports = [
    #################### Required Configs ####################
    ./common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix

    #################### Optional Configs ####################
    common/optional/editors
    common/optional/dev
  ];
  # Disable impermanence
  #home.persistence = lib.mkForce { };

  # Overrides for work
  home = {
    homeDirectory = "/Users/bcraton";
    username = "bcraton";
    packages = with pkgs; [
      azure-cli
    ];
  };

  programs.git = {
    userName = "Ben Craton";
    userEmail = "bcraton@passageways.com";
  };
}

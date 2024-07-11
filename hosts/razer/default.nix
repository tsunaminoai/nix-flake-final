#############################################################
#
#  Razer - Laptop
#  NixOS running on a razer laptop
#
###############################################################
{
  config,
  inputs,
  pkgs,
  outputs,
  ...
}: let
  sops = config.sops;
  ssid = sops.secrets.wifi.ssid;
in {
  imports = [
    #################### Hardware Modules ####################
    inputs.hardware.nixosModules.common-cpu-intel
    # inputs.hardware.nixosModules.common-gpu-nvidia

    #################### Required Configs ####################
    ./bootloader.nix
    ../common/core
    ../common/users/tsunami
  ];

  tsunaminoai = {
    desktop = {
      enable = true;
      windowManager = "plasma";
      enableVNC = true;
    };
    security = {
      # gpg = {
      #   enable = true;
      #   agentTimeout = 5;
      # };
    };
  };

  powerManagement.enable = false;

  networking = {
    hostName = "razer";
    networkmanager = {
      enable = true;
    };
    enableIPv6 = false;
    # wireless = {
    #   enable = true;
    #   # # see https://search.nixos.org/options?channel=24.05&show=networking.wireless.environmentFile
    #   # environmentFile = config.sops.secrets."wifi/FalseBlue".path;
    #   # userControlled = {
    #   #   enable = true;
    #   #   group = "networkmanager";
    #   # };
    #   # networks = {
    #   #   "FalseBlue" = {
    #   #     auth = ''
    #   #       eap=PEAP
    #   #       identity="@USER@"
    #   #       password="@PASS@"
    #   #     '';
    #   #   };
    #   # };
    # };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBm4yzmOrF+MCV+w0yfd10R88iHR6QusZBCpEtPFm+f+ tsunami@mokou"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2IrKNs2BLgup7rSVt7KJqRqeSxhU+B1FUrBlHNNmSJ tsunami@youmu"
  ];

  # VirtualBox settings for Hyprland to display correctly
  #environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  #environment.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  # Fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code#Remote_SSH
  programs.nix-ld.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  # TODO: clean up the below, move to a more appropriate location

  # virtualisation.containers.cdi.dynamic.nvidia.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  # Razer stuff
  hardware.openrazer = {
    enable = true;
    syncEffectsEnabled = true;
    users = ["tsunami"];
    keyStatistics = true;
    devicesOffOnScreensaver = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Razer stuff
    razergenie
    openrazer-daemon
    polychromatic
  ];
}

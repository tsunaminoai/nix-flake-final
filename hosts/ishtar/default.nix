#############################################################
#
#  Grief - Dev Lab
#  NixOS running on VirtualBox VM
#
###############################################################
{inputs, ...}: {
  imports = [
    #################### Hardware Modules ####################
    inputs.hardware.nixosModules.common-cpu-intel
    #    inputs.hardware.nixosModules.common-gpu-intel

    #################### Required Configs ####################
    ./install-config.nix
    ../common/core

    #################### Host-specific Optional Configs ####################
    # ../common/optional/yubikey
    # ../common/optional/services/clamav.nix # depends on optional/msmtp.nix
    # ../common/optional/msmtp.nix #required for emailing clamav alerts
    ../common/optional/services/openssh.nix
    ../common/security

    #################### Users to Create ####################
    ../common/users/tsunami
  ];

  tsunaminoai = {
    tailscale.enable = true;
    
  };

  # set custom autologin options. see greetd.nix for details
  services.gnome.gnome-keyring.enable = true;
  #TODO enable and move to greetd area? may need authentication dir or something?
  #services.pam.services.greetd.enableGnomeKeyring = true;

  networking = {
    hostName = "ishtar";
    #networkmanager.enable = true;
    enableIPv6 = false;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2IrKNs2BLgup7rSVt7KJqRqeSxhU+B1FUrBlHNNmSJ tsunami@youmu"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBm4yzmOrF+MCV+w0yfd10R88iHR6QusZBCpEtPFm+f+ tsunami@mokou"
  ];

  # VirtualBox settings for Hyprland to display correctly
  #environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  #environment.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  # Fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code#Remote_SSH
  programs.nix-ld.enable = true;

  # Enable reporting to proxmox
  services.qemuGuest.enable = true;
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

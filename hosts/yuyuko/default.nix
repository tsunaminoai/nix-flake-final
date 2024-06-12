#############################################################
#
#  Yuyuko
#  NixOS running on Hosted VM
#
###############################################################
{inputs, ...}: {
  imports = [
    #################### Hardware Modules ####################
    inputs.hardware.nixosModules.common-cpu-intel

    #################### Required Configs ####################
    ./hardware-configuration.nix
    ../common/security
    ../common/core/locale.nix    
    ../common/core/nix.nix    
    ../common/core/sops.nix    
    ../common/core/services/tailscale.nix    
    ../common/core/services/auto-upgrade.nix    

    #################### Host-specific Optional Configs ####################
    # ../common/optional/yubikey
    # ../common/optional/services/clamav.nix # depends on optional/msmtp.nix
    # ../common/optional/msmtp.nix #required for emailing clamav alerts
    ../common/optional/services/openssh.nix

    #################### Users to Create ####################
    #  ../common/users/tsunami
  ];
  # set custom autologin options. see greetd.nix for details

  networking = {
    hostName = "yuyuko";
    #networkmanager.enable = true;
    enableIPv6 = false;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2IrKNs2BLgup7rSVt7KJqRqeSxhU+B1FUrBlHNNmSJ tsunami@youmu"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBm4yzmOrF+MCV+w0yfd10R88iHR6QusZBCpEtPFm+f+ tsunami@mokou"
  ];

  documentation.enable = false;
  
  # Enable reporting to proxmox
  # services.qemuGuest.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}


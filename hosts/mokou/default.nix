#############################################################
#
#  Mokou - Desktop
#  NixOS running on a Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz
#  32GB RAM, Nvidia 1080i
#
###############################################################
{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    #################### Hardware Modules ####################
    inputs.hardware.nixosModules.common-cpu-intel
    # inputs.hardware.nixosModules.common-gpu-intel

    #################### Required Configs ####################
    ./bootloader.nix
    ../common/core

    #################### Host-specific Optional Configs ####################
    ../common/optional/yubikey
    # ../common/optional/services/clamav.nix # depends on optional/msmtp.nix
    # ../common/optional/msmtp.nix #required for emailing clamav alerts
    ../common/optional/services/openssh.nix
    # ../common/optional/nvidia.nix
    ../common/optional/virtualization.nix
    ../common/optional/wayland

    #################### Users to Create ####################
    ../common/users/tsunami
  ];
  # set custom autologin options. see greetd.nix for details

  services.gnome.gnome-keyring.enable = true;
  #TODO enable and move to greetd area? may need authentication dir or something?
  #services.pam.services.greetd.enableGnomeKeyring = true;

  networking = {
    hostName = "mokou";
    networkmanager.enable = true;
    enableIPv6 = false;
  };

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
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session.command = ''
  #       ${pkgs.greetd.tuigreet}/bin/tuigreet \
  #         --time \
  #         --asterisks \
  #         --user-menu \
  #         --cmd sway
  #     '';
  #   };
  # };

  # Razer stuff
  hardware.openrazer = {
    enable = true;
    syncEffectsEnabled = true;
    users = ["tsunami"];
    keyStatistics = true;
    devicesOffOnScreensaver = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

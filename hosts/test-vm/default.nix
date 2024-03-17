# configuration.nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/core
    ../common/optional/services/openssh.nix
    ../common/optional/services/smbclient.nix
    ../common/optional/services/kavita.nix
  ];
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [22];
  environment.systemPackages = with pkgs; [
    htop
  ];

  system.stateVersion = "23.05";
}

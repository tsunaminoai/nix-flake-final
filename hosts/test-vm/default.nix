# configuration.nix
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./install-config.nix
    ../common/core/sops.nix

    ../common/optional/services/openssh.nix
    ../common/optional/smbclient.nix
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

  users.users.test = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    password = "demo";
  };

  networking.firewall.allowedTCPPorts = [22];
  environment.systemPackages = with pkgs; [
    htop
  ];

  system.stateVersion = "23.05";
}

{
  pkgs,
  lib,
  config,
  ...
}: {
  boot.kernelModules = ["kvm-intel"];
  environment.systemPackages = with pkgs; [
    podman-compose
  ];
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };
}

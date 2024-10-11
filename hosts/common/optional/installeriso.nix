{modulesPath, ...}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ../core/nix.nix
    ../core/sops.nix
    ../core/fish.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}

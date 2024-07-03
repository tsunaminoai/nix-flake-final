{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: let
  pkgs = inputs.nixpkgs.legacyPackages.;
  isLinux = stdenv.isLinux;
  isDarwin = stdenv.isDarwin;
  linuxOnlyImports =
    if isLinux
    then [./locale.nix]
    else [];
  darwinOnlyImports =
    if isDarwin
    then [./darwin.nix]
    else [];
in {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ../security # security settings
      ./direnv.nix # direnv
      ./locale.nix # loclalization settings
      ./sops.nix # secrets management
      ./fish.nix # fish shell
      ./services/tailscale.nix # tailscale
      ./services/auto-upgrade.nix # auto-upgrade service
      ./tools.nix # tools for system administration
    ]
    ++ (builtins.attrValues outputs.nixosModules)
    ++ linuxOnlyImports
    ++ darwinOnlyImports;

  config = lib.mkMerge [
    {
      home-manager.extraSpecialArgs = {inherit inputs outputs;};
    }
    (lib.mkIf isLinux {inuputs.hardware.enableRedistributableFirmware = true;})
  ];
}

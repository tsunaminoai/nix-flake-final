{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: let
  linuxOnlyImports = [
    ./locale.nix
    ./services/tailscale.nix # tailscale
    ./services/auto-upgrade.nix # auto-upgrade service
  ];
  darwinOnlyImports = [./darwin.nix];
in {
  imports =
    [
      ../security # security settings
      ./direnv.nix # direnv
      ./locale.nix # loclalization settings
      ./sops.nix # secrets management
      ./fish.nix # fish shell
      ./tools.nix # tools for system administration
    ]
    ++ (lib.optionals
      pkgs.stdenv.isLinux
      linuxOnlyImports)
    ++ (lib.optionals
      pkgs.stdenv.isDarwin
      darwinOnlyImports)
    ++ (builtins.attrValues outputs.nixosModules);

  config = lib.mkMerge [
    {
      home-manager.extraSpecialArgs = {inherit inputs outputs;};
    }
    (lib.mkIf pkgs.stdenv.isLinux {inuputs.hardware.enableRedistributableFirmware = true;})
  ];
}

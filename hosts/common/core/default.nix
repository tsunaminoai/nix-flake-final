{
  inputs,
  outputs,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ../security # security settings
      ./direnv.nix # direnv
      ./locale.nix # loclalization settings
      ./nix.nix # nix settings and garbage collection
      ./sops.nix # secrets management
      ./fish.nix # fish shell
      ./services/tailscale.nix # tailscale
      ./services/auto-upgrade.nix # auto-upgrade service
      ./tools.nix # tools for system administration
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = {inherit inputs outputs;};

  nixpkgs = {
    # you can add global overlays here
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
}

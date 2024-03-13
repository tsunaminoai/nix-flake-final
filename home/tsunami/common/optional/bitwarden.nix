{
  pkgs,
  config,
  inputs,
  ...
}: let
  secretspath = builtins.toString inputs.mysecrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  home.packages = with pkgs; [
    bitwarden-cli
  ];
  programs.fish.interactiveShellInit = ''
    set -x BW_CLIENTID (cat ${config.sops.secrets."bitwarden/client-id".path})
    set -x BW_CLIENTSECRET (cat ${config.sops.secrets."bitwarden/client-secret".path})
    set -x BW_SESSION (bw unlock --raw --passwordfile ${config.sops.secrets."bitwarden/topsecret".path})
  '';

  sops.secrets = {
    "bitwarden/client-id" = {
      path = "/Users/tsunami/.config/bitwarden/client-id";
      mode = "0400";
    };
    "bitwarden/client-secret" = {
      path = "/Users/tsunami/.config/bitwarden/client-secret";
      mode = "0400";
    };
    "bitwarden/topsecret" = {
      path = "/Users/tsunami/.config/bitwarden/topsecret";
      mode = "0400";
    };
  };
}

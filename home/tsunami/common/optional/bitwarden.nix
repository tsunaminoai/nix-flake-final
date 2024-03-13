{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    bitwarden-cli
  ];
  programs.fish.interactiveShellInit = ''
    set -x BW_CLIENTID (cat ${config.sops.secrets."bitwarden/client-id".path})
    set -x BW_CLIENTSECRET (cat ${config.sops.secrets."bitwarden/client-secret".path})
    set -x BW_SESSION (bw unlock --raw --passwordfile ${config.sops.secrets."bitwarden/topsecret".path})
  '';
}

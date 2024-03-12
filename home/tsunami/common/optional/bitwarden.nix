{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    bitwarden-cli
  ];
  programs.fish.interactiveShellInit = ''
    set -x BW_CLIENTID ${config.sops.secrets."bitwarden/client-id".text}
    set -x BW_CLIENTSECRET ${config.sops.secrets."bitwarden/client-secret".text}
  '';
}

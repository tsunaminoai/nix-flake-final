{pkgs, ...}: {
  environment.packages = with pkgs; [
    bitwarden-cli
  ];
  programs.fish.interactiveShellInit = ''
    set -x BW_CLIENTID ${config.sops.secrets."bitwarden/client-id"}
    set -x BW_CLIENTSECRET ${config.sops.secrets."bitwarden/client-secret"}
  '';
}

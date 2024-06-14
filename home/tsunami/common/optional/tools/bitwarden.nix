{
  pkgs,
  inputs,
  home,
  ...
}: {
  imports = [
    #    inputs.sops-nix.homeManagerModules.sops
  ];
  home.packages = with pkgs; [
    bitwarden-cli
    bitwarden
  ];
  #  programs.fish.interactiveShellInit = ''
  #    set -x BW_CLIENTID (cat ${config.sops.secrets."bitwarden/client-id".path})
  #    set -x BW_CLIENTSECRET (cat ${config.sops.secrets."bitwarden/client-secret".path})
  #    set -x BW_SESSION (bw unlock --raw --passwordfile ${config.sops.secrets."bitwarden/topsecret".path})
  #  '';

  #  sops.secrets =  {
  #    "bitwarden/client-id" = {
  #      path = "${home.homeDirectory}/.config/bitwarden/client-id";
  #      mode = "0400";
  #    };
  #    "bitwarden/client-secret" = {
  #      path = "${home.homeDirectory}/.config/bitwarden/client-secret";
  #      mode = "0400";
  #    };
  #    "bitwarden/topsecret" = {
  #      path = "${home.homeDirectory}/.config/bitwarden/topsecret";
  #      mode = "0400";
  #    };
  #  };
}

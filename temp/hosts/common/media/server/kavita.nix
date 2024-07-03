{
  pkgs,
  config,
  ...
}: let
  sops = config.sops;
in {
  # environment.systemPackages = with pkgs; [
  #   kavita
  # ];
  # setup the required secrets
  sops.secrets.kavita-token-key = {
    mode = "0400";
  };
  services.kavita = {
    enable = true;
    port = 3000;
    tokenKeyFile = config.sops.secrets."kavita-token-key".path;
  };

  networking.firewall.allowedTCPPorts = [3000];
}

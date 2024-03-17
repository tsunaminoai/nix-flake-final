{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kavita
  ];
  services.kavita = {
    enable = true;
    port = 3000;
    tokenKeyFile = "/var/lib/kavita/key.key";
    dataDir = "/var/lib/kavita";
  };
  
  networking.firewall.allowedTCPPorts = [3000];
}

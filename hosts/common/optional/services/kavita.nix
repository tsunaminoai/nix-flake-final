{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kavita
  ];
  services.kavita = {
    enable = true;
    port = 3000;
    dataDir = "/var/lib/kavita";
  };
}

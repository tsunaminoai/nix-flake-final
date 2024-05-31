{pkgs, ...}: {
  home.packages = with pkgs; [
    netscanner
    wakeonlan
    nload
    nmap
  ];
}

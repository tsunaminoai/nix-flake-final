{pkgs, ...}: {
  home.packages = with pkgs; [
    # netscanner
    wakeonlan
    # nload
    nmap
    iperf3
    # ipmiutil
    dhcping
  ];
}

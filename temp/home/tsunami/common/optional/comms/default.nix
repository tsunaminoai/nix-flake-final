#
# TODO stage 4: this is a placeholder list for now
#
# signal-desktop
# telegram-desktop
# discord
# slack
{pkgs, ...}: {
  home.packages = with pkgs; [
    discord
    signal-desktop
    slack
  ];
}

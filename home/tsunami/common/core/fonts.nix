{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.noto-fonts
    (pkgs.nerdfonts.override {fonts = ["DejaVuSansMono" "Iosevka" "JetBrainsMono"];})
    pkgs.meslo-lgs-nf
  ];
}

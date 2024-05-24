{
  config,
  pkgs,
  lib,
  ...
}: {
  gtk = lib.mkDefault {
    enable = true;
    #font.name =  TODO see misterio https://github.com/Misterio77/nix-config/blob/f4368087b0fd0bf4a41bdbf8c0d7292309436bb0/home/misterio/features/desktop/common/gtk.nix   he has a custom config for managing fonts, colorsheme etc.

    theme = {
      name = "adwaita-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "elementary-Xfce-dark";
      package = pkgs.elementary-xfce-icon-theme;
    };
    cursorTheme = lib.mkDefault {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 22;
    };
    font = lib.mkDefault {
      name = "DejaVu Sans";
      size = 16;
    };

    #TODO add ascendancy cursor pack
    #cursortTheme.name = "";
    #cursortTheme.package = ;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}

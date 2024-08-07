{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.tsunaminoai.fonts;
in {
  options.tsunaminoai.fonts = with types; {
    enable = lib.mkEnableOption "Enable font configuration";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      fonts = {
        packages = with pkgs; [
          material-icons
          material-design-icons
          roboto
          work-sans
          comic-neue
          source-sans
          twemoji-color-font
          comfortaa
          inter
          lato
          lexend
          jost
          dejavu_fonts
          iosevka-bin
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          jetbrains-mono
          (nerdfonts.override {fonts = ["DejaVuSansMono" "Iosevka" "JetBrainsMono"];})
        ];

        enableDefaultPackages = false;

        # this fixes emoji stuff
        fontconfig = {
          defaultFonts = {
            monospace = [
              "Iosevka Term"
              "Iosevka Term Nerd Font Complete Mono"
              "Iosevka Nerd Font"
              "Noto Color Emoji"
            ];
            sansSerif = ["Lexend" "Noto Color Emoji"];
            serif = ["Noto Serif" "Noto Color Emoji"];
            emoji = ["Noto Color Emoji"];
          };
        };
      };
    })
  ];
}

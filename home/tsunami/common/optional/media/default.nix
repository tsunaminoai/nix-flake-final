{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg
    imagemagic
    fluid-synth
    lame
    mpg123
    sox
    vlc
    youtube-dl
  ];
}

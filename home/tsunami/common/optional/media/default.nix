{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg
    fluidsynth
    imagemagick
    lame
    mangal
    mpg123
    sox
    youtube-dl
  ];
}

{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg
    imagemagick
    fluidsynth
    lame
    mpg123
    sox
    youtube-dl
  ];
}

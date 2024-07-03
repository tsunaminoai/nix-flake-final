{
  home,
  pkgs,
  ...
}: {
  # importing a file directly
  home.file.".config/neofetch/neofetch.conf".source = ./neofetch.conf;

  home.packages = with pkgs; [
    neofetch
  ];
}

{pkgs, ...}: {
  programs.dienv = {
    enable = true;
    package = pkgs.dienv;
    silent = true;
  };
}

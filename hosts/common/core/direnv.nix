{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = true;
  };
}

{
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    silent = true;
    nix-direnv.enable = true; # better than native direnv nix functionality - https://github.com/nix-community/nix-direnv
  };
}

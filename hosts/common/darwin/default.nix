{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    # ../core/nix.nix # nix settings and garbage collection
    ../core/zsh.nix # load a basic shell just incase we need it without home-manager
  ];

  home-manager.extraSpecialArgs = {inherit inputs outputs;};
  time.timeZone = lib.mkDefault "America/Indiana/Indianapolis";

  nixpkgs = {
    # you can add global overlays here
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  programs.fish.enable = true;
  environment = {
    shells = with pkgs; [bash fish];
    loginShell = pkgs.fish;
    systemPackages = [pkgs.coreutils];
    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  # fonts.fontDir.enable = true; # DANGER

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    # dock.autohide = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 25;
    NSGlobalDomain.KeyRepeat = 25;
  };
  # backwards compat; don't change
  system.stateVersion = 4;
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
  };

  nix.package = pkgs.nix;
}

{
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}: let
  cfg = config.${namespace}.environment;
in {
  options.tsunaminoai.environment = with lib.types;
  with lib; {
    loginShell = mkOption {
      type = str;
      default = "fish";
      description = "The default login shell";
    };
    # systemPackages = mkOption {
    #   type = with pkgs; listOf pkgs;
    #   default = [pkgs.coreutils];
    #   description = "Packages to install globally";
    # };
    systemPath = mkOption {
      type = listOf str;
      default = ["/opt/homebrew/bin"];
      description = "Paths to add to the system PATH";
    };
    pathsToLink = mkOption {
      type = listOf str;
      default = ["/Applications"];
      description = "Paths to link to the user's home directory";
    };
  };
  config = lib.mkMerge [
    {
      environment = {
        shells = with pkgs; [
          bash
          zsh
          fish
        ];
        loginShell = cfg.loginShell;
        # systemPackages = cfg.systemPackages;
        systemPath = cfg.systemPath;
        pathsToLink = cfg.pathsToLink;
      };
    }
  ];
}

{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
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
  cfg = config.${namespace}.security;
in {
  options.tsunaminoai.security = with lib.types; {
    GuestEnabled = lib.mkEnableOption "Enable guest account";
    LoginWindowText = lib.mkOption {
      type = str;
      default = "Welcome to ${config.networking.hostName}!";
      description = "The text displayed on the login window";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.GuestEnabled {
      system.defaults.loginwindow.GuestEnabled = true;
    })
    {
      security.pam.enableSudoTouchIdAuth = true;
      system.defaults = {
        loginwindow = {
          LoginwindowText = cfg.LoginWindowText;
        };

        screensaver = {
          askForPassword = true;
          askForPasswordDelay = 15;
        };
      };
    }
  ];
}

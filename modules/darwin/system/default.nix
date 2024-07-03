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
  cfg = config.${namespace}.system;
in {
  options.tsunaminoai.system = with lib.types; {
    input = lib.mkEnableOption "Enable input remapping";
    ui = lib.mkEnableOption "Enable UI configuration";
    localize = lib.mkEnableOption "Enable localization configuration";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.input {
      system = {
        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToEscape = true;
        };
        defaults = {
          NSGlobalDomain = {
            AppleEnableSwipeNavigateWithScrolls = true;
            ApplePressAndHoldEnabled = false;
            AppleScrollerPagingBehavior = true;
            InitialKeyRepeat = 15;
            KeyRepeat = 2;
            "com.apple.keyboard.fnState" = true;
            "com.apple.mouse.tapBehavior" = 1;
            "com.apple.swipescrolldirection" = false;
            "com.apple.trackpad.enableSecondaryClick" = true;
            "com.apple.trackpad.scaling" = null;
          };
        };
      };
    })
    (lib.mkIf cfg.ui {
      system = {
        defaults = {
          NSGlobalDomain = {
            AppleFontSmoothing = 2;

            NSAutomaticCapitalizationEnabled = true;
            NSAutomaticDashSubstitutionEnabled = true;
            NSAutomaticPeriodSubstitutionEnabled = true;
            NSAutomaticQuoteSubstitutionEnabled = true;
            NSAutomaticWindowAnimationsEnabled = true;
            NSDocumentSaveNewDocumentsToCloud = false;
            NSNavPanelExpandedStateForSaveMode = true;
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            AppleInterfaceStyle = null; # auto
            AppleInterfaceStyleSwitchesAutomatically = true;
          };
          finder = {
            _FXShowPosixPathInTitle = true;
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            CreateDesktop = false;
            FXDefaultSearchScope = "SCcf"; # Search current folder instead of the entire computer
            FXEnableExtensionChangeWarning = false;
            FXPreferredViewStyle = "Nlsv"; # List view
            ShowPathbar = true;
            ShowStatusBar = true;
          };
        };
      };
    })

    (lib.mkIf cfg.localize {
      time.timeZone = lib.mkDefault "America/Indiana/Indianapolis";

      system = {
        defaults = {
          NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            AppleMeasurementUnits = "Inches";

            AppleShowScrollBars = "Automatic";
            AppleTemperatureUnit = "Fahrenheit";
          };
          menuExtraClock = {
            Show24Hour = true;
            ShowDate = 0;
          };
        };
      };
    })
  ];
}

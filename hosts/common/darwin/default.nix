{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../core/direnv.nix # direnv settings
    ../core/fish.nix # direnv settings
    # ../core/nix.nix # nix settings and garbage collection
    # ../core/zsh.nix # load a basic shell just incase we need it without home-manager
    ../security
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

  security = {
    pam.enableSudoTouchIdAuth = true;
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
  system = {
    defaults = {
      CustomSystemPreferences = {};
      CustomUserPreferences = {};
      NSGlobalDomain = {
        AppleEnableSwipeNavigateWithScrolls = true;
        AppleFontSmoothing = 2;
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = null; # auto
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleMeasurementUnits = "Inches";
        ApplePressAndHoldEnabled = false;
        AppleScrollerPagingBehavior = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleShowScrollBars = "Automatic";
        AppleTemperatureUnit = "Fahrenheit";
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
        NSAutomaticCapitalizationEnabled = true;
        NSAutomaticDashSubstitutionEnabled = true;
        NSAutomaticPeriodSubstitutionEnabled = true;
        NSAutomaticQuoteSubstitutionEnabled = true;
        NSAutomaticWindowAnimationsEnabled = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        "com.apple.keyboard.fnState" = true;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.swipescrolldirection" = false;
        "com.apple.trackpad.enableSecondaryClick" = true;
        "com.apple.trackpad.scaling" = 1;
        SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
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
          LoginwindowText = "Welcome to Mac";
        };
        loginwindow = {
          GuestEnabled = false;
        };
        menuExtraClock = {
          Show24Hour = true;
          showDate = true;
        };
        screensaver = {
          askForPassword = true;
          askForPasswordDelay = 15;
        };
        universalaccess.reduceTransparency = true;
        keyboard = {
          enableKeyMapping = true;
          emapCapsLockToEscape = true;
        };
      };
    };
  };
  # fonts.fontDir.enable = true; # DANGER

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    gc = {
      auotmatic = true;
      interval = "1d";
    };
    linux-builder = {
      enable = true;
      ephemeral = false;
    };
    setttings = {
      allowed-users = ["@admin"];
      auto-optimise-store = true;
      cores = 4;
      sandbox = true;
      trusted-users = ["@admin"];
    };
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

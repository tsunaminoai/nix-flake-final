{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  # See: https://daiderd.com/nix-darwin/manual/index.html

  home-manager.extraSpecialArgs = {inherit inputs outputs;};
  time.timeZone = lib.mkDefault "America/Indiana/Indianapolis";

  security = {
    pam.enableSudoTouchIdAuth = true;
  };

  environment = {
    shells = with pkgs; [bash fish];
    loginShell = pkgs.fish;
    systemPackages = [pkgs.coreutils];
    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
  };

  system = {
    defaults = {
      CustomSystemPreferences = {};
      CustomUserPreferences = {};
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
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
        InitialKeyRepeat = 15;
        KeyRepeat = 2;

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
        "com.apple.trackpad.scaling" = null;
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
      loginwindow = {
        LoginwindowText = "Welcome to Mac";
        GuestEnabled = false;
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 0;
      };
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 15;
      };
      # universalaccess.reduceTransparency = true;
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
  # fonts.fontDir.enable = true; # DANGER

  # backwards compat; don't change
  system.stateVersion = 4;
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    brews = [];
    casks = [
    ];
  };

  # nix.package = pkgs.nix;
}

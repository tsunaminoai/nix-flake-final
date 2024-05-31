{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  # See: https://daiderd.com/nix-darwin/manual/index.html
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../core/direnv.nix # direnv settings
    ../core/fish.nix # fish shell
    # sops nix does not work on darwin. do not import it
    # tailscale should only be imported on darwin using home-manager
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

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    nixPath = ["$HOME/.nix-defexpr/darwin"];
    gc = {
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 15;
      };
    };
    linux-builder = {
      enable = true;
      ephemeral = false;
    };
    settings = {
      allowed-users = ["@admin"];
      auto-optimise-store = false;
      cores = 4;
      sandbox = true;
      trusted-users = ["@admin"];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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

  nix.package = pkgs.nix;
}

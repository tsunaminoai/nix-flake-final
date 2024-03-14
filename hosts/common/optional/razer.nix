{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Razer stuff
    razergenie
    openrazer-daemon
    polychromatic
  ];
  # Razer stuff
  hardware.openrazer = {
    enable = true;
    syncEffectsEnabled = true;
    users = ["tsunami"];
    keyStatistics = true;
    devicesOffOnScreensaver = true;
  };
}

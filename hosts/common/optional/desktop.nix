/*
This module contains options required only for systems with a graphical desktop.
*/
{
  pkgs,
  lib,
  config,
  ...
}: {
  services = {
    # audio & video server, replaces PulseAudio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # login manager
    greetd = {
      enable = true;
      settings = rec {
        initial_session = default_session;
        default_session = {
          command = let
            timeFormat = "%Y-%m-%d | %H:%M:%S";
            greeting = "Welcome! Access is restricted.";
          in "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '${timeFormat}' --greeting '${greeting}' --cmd sway";
          user = "greeter";
        };
      };
    };

    # the languagetool extension for code needs a server running
    languagetool.enable = true;
  };

  programs = {
    dconf.enable = true;
    noisetorch.enable = true;
  };

  xdg.portal = {
    enable = true;
    # there is some weirdness happening here
    # https://github.com/NixOS/nixpkgs/issues/160923
    #xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["gtk"];
  };

  security = {
    polkit.enable = true;

    # this is necessary for PipeWire
    rtkit.enable = true;

    /*
    this is required for swaylock to be able to verify credentials
    without this swaylock will always complain about a wrong password
    */
    pam.services.swaylock = {};
  };

  fonts.fontconfig.defaultFonts = {
    monospace = ["Iosevka Funke"];
    serif = ["Libertinus Serif"];
    sansSerif = ["Source Sans 3"];
    emoji = ["Noto Color Emoji"];
  };
}

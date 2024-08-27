{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.tsunaminoai.desktop;
in {
  options.tsunaminoai.desktop = with types; {
    enable = lib.mkEnableOption "Enable desktop configuration";
    windowManager = lib.mkOption {
      type = types.enum ["sway" "plasma"];
      default = "plasma";
      description = ''
        The window manager to use.
      '';
    };
    enableVNC = mkEnableOption "Enable VNC server";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      tsunaminoai.fonts.enable = true;

      services = {
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
        # the languagetool extension for code needs a server running
        languagetool.enable = true;
      };
    })
    (
      lib.mkIf (cfg.enable && cfg.windowManager == "plasma") {
        services.xserver.enable = true;

        # Enable the KDE Plasma Desktop Environment.
        services.displayManager.sddm.enable = true;
        services.desktopManager.plasma6.enable = true;
        services.xrdp = {
          enable = true;
          openFirewall = true;
          defaultWindowManager = "startplasma-x11";
        };
        # Configure keymap in X11
        services.xserver.xkb = {
          layout = "us";
          variant = "";
        };
      }
    )
    #FIXME: This needs to be in home-manager
    (lib.mkIf (cfg.enable && cfg.enableVNC) {
      environment.systemPackages = with pkgs; [
        turbovnc
      ];
      networking.firewall.allowedTCPPorts = [8000 5901];
      services.xserver.displayManager.sessionCommands = ''
        vncserver -wm /run/current-system/sw/bin/startplasma-x11
      '';
    })
    (lib.mkIf (cfg.enable && cfg.windowManager == "sway") {
      programs = {
        dconf.enable = true;
        noisetorch.enable = true;
      };
      services = {
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
    })
  ];
}

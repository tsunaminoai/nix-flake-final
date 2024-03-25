{pkgs, ...}: {
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };
  systemd.services = {
    seatd = {
      enable = true;
      description = "Seat management daemon";
      script = "${pkgs.seatd}/bin/seatd -g wheel";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
      };
      wantedBy = ["multi-user.target"];
    };
    configure-appcenter-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo
      '';
    };
  };

  services = {
    flatpak.enable = true;

    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --time \
              --asterisks \
              --user-menu \
              --cmd sway
          '';
          user = "tsunami";
        };
        default_session = initial_session;
      };
    };

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
      extraConfig = ''
        HandlePowerKey=suspend
        HibernateDelaySec=3600
      '';
    };

    lorri.enable = true;
    udisks2.enable = true;
    printing.enable = true;
    fstrim.enable = true;
  };
}

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.tsunaminoai.media-acquisition;
in {
  options.tsunaminoai.media-acquisition = with types; {
    enable = lib.mkEnableOption "enables media pipeline";

    appDataDir = mkOption {
      type = types.str;
      default = "/var/lib/mediaserver";
      description = "Directory to store application data";
    };

    mediaDir = mkOption {
      type = types.str;
      default = "/var/lib/media";
      description = "Directory to store and serve media data";
    };

    user = mkOption {
      type = types.str;
      default = "mediaserver";
      description = "User account under which services will run";
    };

    group = mkOption {
      type = types.str;
      default = "mediaserver";
      description = "Group under which services will run";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      # Create user and group
      users.users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
      };
      users.groups.${cfg.group} = {};

      # Sonarr
      services.sonarr = {
        enable = true;
        user = cfg.user;
        group = cfg.group;
        dataDir = "${cfg.appDataDir}/sonarr";
      };

      # Radarr
      services.radarr = {
        enable = true;
        user = cfg.user;
        group = cfg.group;
        dataDir = "${cfg.appDataDir}/radarr";
      };

      # Deluge
      services.deluge = {
        enable = true;
        user = cfg.user;
        group = cfg.group;
        dataDir = "${cfg.appDataDir}/deluge";
        web.enable = true;
        declarative = true;
        config = {
          download_location = "${cfg.dataDir}/downloads";
          allow_remote = true;
          daemon_port = 58846;
          listen_ports = [6881 6889];
        };
      };

      # Prowlarr
      services.prowlarr = {
        enable = true;
        user = cfg.user;
        group = cfg.group;
        dataDir = "${cfg.appDataDir}/prowlarr";
      };

      # Open firewall ports
      networking.firewall = {
        allowedTCPPorts = [
          8989 # Sonarr
          7878 # Radarr
          8112 # Deluge Web UI
          9696 # Prowlarr
        ];
      };

      # Tailscale
      config.tsunaminoai.tailscaleAutoconnect = {
        enable = true;
      };

      # Ensure data directory exists and has correct permissions
      system.activationScripts.mediaServerDataDir = ''
        mkdir -p ${cfg.appDataDir}
        chown ${cfg.user}:${cfg.group} ${cfg.appDataDir}
        chmod 755 ${cfg.appDataDir}
      '';
    })
  ];
}

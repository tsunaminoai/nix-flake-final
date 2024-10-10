{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.tsunaminoai.tailscaleAutoconnect;
in {
  options.services.tailscaleAutoconnect = {
    enable = mkEnableOption "Tailscale autoconnect";

    authKeyFile = mkOption {
      type = types.str;
      default = config.sops.secrets."tailscale/auth-key".path;
      description = "The path to the sops-encrypted file containing the Tailscale auth key";
    };

    extraUpFlags = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra flags to pass to 'tailscale up'";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraUpFlags = [
        "--ssh"
        cfg.extraUpFlags
      ];
      useRoutingFeatures = "client";
    };

    sops.secrets.tailscale_authkey = {
      sopsFile = cfg.authKeyFile;
    };

    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";
      after = ["network-pre.target" "tailscale.service"];
      wants = ["network-pre.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        # Wait for tailscaled to settle
        sleep 2

        # Check if we are already authenticated to Tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then
          # Already authenticated, exit
          exit 0
        fi

        # Otherwise, authenticate with Tailscale
        ${tailscale}/bin/tailscale up -authkey "$(cat ${config.sops.secrets.tailscale_authkey.path})" ${toString cfg.extraUpFlags}
      '';
    };

    networking.firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
      allowPing = true;
      logReversePathDrops = true;
    };
  };
}

{
  pkgs,
  lib,
  config,
  ...
}: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--ssh"
    ];
    useRoutingFeatures = "client";
    authKeyFile = config.sops.secrets."tailscale/auth-key".path;
  };
  firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
    allowPing = false;
    logReversePathDrops = true;
  };
}

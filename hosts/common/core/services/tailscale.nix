{config, ...}: {
  services.tailscale = {
    enable = true;
    services.tailscale.authKeyFile = config.sops.secrets."tailscale/auth-key".path;
  };
}

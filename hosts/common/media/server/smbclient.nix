# create a systemd service to automatically mount the ghost mediashare at boot
{
  pkgs,
  config,
  ...
}: let
  sops = config.sops;
  mkVoileMount = mount: {
    device = "//192.168.0.25/${mount}";
    fsType = "cifs";
    options = let
      # separate options to prevent hanging on network split
      # 'noauto'= do not mount via fstab. Will be automounted by systemd
      separate_options = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${separate_options},credentials=/etc/nixos/smb-secrets"];
  };
in {
  # required to mount cifs using domain name
  environment.systemPackages = [pkgs.cifs-utils];

  # setup the required secrets
  sops.secrets.nix-media-sops = {
    path = "/etc/nixos/smb-secrets";
  };
  fileSystems."/mnt/voile/Inaba" = mkVoileMount "Inaba";
}

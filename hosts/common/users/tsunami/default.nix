{
  pkgs,
  inputs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # Decrypt tsunami-password to /run/secrets-for-users/ so it can be used to create the user
  sops.secrets.tsunami-password.neededForUsers = true;
  users.mutableUsers = false; # Required for password to be set via sops during system activation!

  users.users.tsunami = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.tsunami-password.path;
    shell = pkgs.zsh; #default shell
    extraGroups =
      [
        "wheel"
        "audio"
        "video"
      ]
      ++ ifTheyExist [
        "docker"
        "git"
        "mysql"
        "network"
      ];

    openssh.authorizedKeys.keys = [
      (builtins.readFile ./keys/id_ed25519.pub)
      (builtins.readFile ./keys/id_rsa_yubikey.nano5c.nist256.pub)
      (builtins.readFile ./keys/id_rsa_yubikey.nano5c.ec25519.pub)
    ];

    packages = [pkgs.home-manager];
  };

  # FIXME This should probably be host specific. Also need to confirm that this is the correct place to do this.
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=120 # only ask for password every 120 minutes
  '';

  # Import this user's personal/home configurations
  home-manager.users.tsunami = import ../../../../home/tsunami/${config.networking.hostName}.nix;
}

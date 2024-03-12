{
  pkgs,
  inputs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = true; # Required for password to be set via sops during system activation!

  users.users.bcraton = {
    homeDirectory = "/Users/bcraton";
    isNormalUser = true;
    shell = pkgs.fish; #default shell
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
      (builtins.readFile ../tsunami/keys/id_mokou_ed25519.pub)
      (builtins.readFile ../tsunami/keys/id_youmu_ed25519.pub)
      (builtins.readFile ../tsunami/keys/id_rsa_yubikey.nano5c.nist256.pub)
      (builtins.readFile ../tsunami/keys/id_rsa_yubikey.nano5c.ec25519.pub)
    ];

    packages = [pkgs.home-manager];
  };

  # FIXME This should probably be host specific. Also need to confirm that this is the correct place to do this.
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=120 # only ask for password every 120 minutes
  '';

  # Import this user's personal/home configurations
  home-manager.users.bcraton = import ../../../../home/bcraton/work-laptop.nix;
}

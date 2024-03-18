{
  pkgs,
  inputs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.bcraton = {
    home = "/Users/bcraton";
    shell = pkgs.fish; #default shell

    openssh.authorizedKeys.keys = [
      (builtins.readFile ../tsunami/keys/id_mokou_ed25519.pub)
      (builtins.readFile ../tsunami/keys/id_youmu_ed25519.pub)
      (builtins.readFile ../tsunami/keys/id_5cNFC.pub)
      (builtins.readFile ../tsunami/keys/id_nano5c.pub)
    ];

    packages = [pkgs.home-manager];
  };

  # FIXME This should probably be host specific. Also need to confirm that this is the correct place to do this.
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=120 # only ask for password every 120 minutes
  '';

  # Import this user's personal/home configurations
  home-manager.users.bcraton = import ../../../../home/tsunami/work-laptop.nix;
}

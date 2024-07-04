{
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}: let
  cfg = config.${namespace}.sops;
  secretspath = builtins.toString inputs.mysecrets;
  homeDir = config.snowfall.users.home;
  keyLocation =
    if (lib.snowfall.system.is-darwin)
    then builtins.toPath "${homeDir}/Library/Application Support/sops/age/keys.txt"
    else builtins.toPath "${homeDir}/.config/sops/age/keys.txt";

  secretOption = with lib.types; {
    options = {
      name = lib.mkOption {
        type = str;
        # description = "The name/id of the secret";
      };
      path = lib.mkOption {
        type = str;
        # description = "The path to write the secret to relative to ~/";
      };

      mode = lib.mkOption {
        type = str;
        default = "0400";
        # description = "The mode to set on the secret file";
      };
    };
  };
in {
  options.tsunaminoai.sops = with lib.types; {
    enable = lib.mkEnableOption "Enable sops";
    secrets = lib.mkOption {
      type = listOf (submodule secretOption);
      default = [];
      description = "List of secrets to manage with sops";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      sops = {
        # gnupg = {
        #   home = "/var/lib/sops";
        #   sshKeyPaths = [ ];
        # }

        # This is the key and needs to have been copied to this location on the host
        age.keyFile = keyLocation;

        defaultSopsFile = "${secretspath}/secrets.yaml";
        validateSopsFiles = true;

        secrets = builtins.listToAttrs (map (item: {
            name = item.name;
            value = removeAttrs item ["name"];
          })
          cfg.secrets);
      };
    })
  ];
}
# "github/ssh-pub" = {
#   path = "${homeDir}/.ssh/github.pub";
#   mode = "0400";
# };
# "github/ssh-key" = {
#   path = "${homeDir}/.ssh/github";
#   mode = "0400";
# };


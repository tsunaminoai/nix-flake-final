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
  buildSecrets = l:
    builtins.listToAttrs
    (map (s: {
        name = s.name;
        value = builtins.removeAttrs s ["name"];
      })
      l);

  secretspath = builtins.toString inputs.mysecrets;
  homeDir = config.snowfall.users.home;
  # secretOption = with lib.types; {
  #   options = {
  #     name = lib.mkOption {
  #       type = str;
  #       description = lib.mdDoc "The name/id of the secret";
  #     };
  #     # path = lib.mkOption {
  #     #   type = str;
  #     #   description = lib.mdDoc "The path to write the secret to relative to ~/";
  #     # };

  #     # mode = lib.mkOption {
  #     #   type = nullOr str;
  #     #   default = "0400";
  #     #   description = lib.mdDoc "The mode to set on the secret file";
  #     # };
  #   };
  # };
  keyLocation =
    if (lib.snowfall.system.is-darwin)
    then builtins.toPath "${homeDir}/Library/Application Support/sops/age/keys.txt"
    else builtins.toPath "${homeDir}/.config/sops/age/keys.txt";
in {
  options.tsunaminoai.sops = with lib.types; {
    enable = lib.mkEnableOption "Enable sops";
    secrets = lib.mkOption {
      description = "List of secrets to manage with sops";
      type = anything;
      default = {};
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      sops = {
        # This is the key and needs to have been copied to this location on the host
        age.keyFile = keyLocation;

        defaultSopsFile = "${secretspath}/secrets.yaml";
        validateSopsFiles = true;

        secrets = cfg.secrets;
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


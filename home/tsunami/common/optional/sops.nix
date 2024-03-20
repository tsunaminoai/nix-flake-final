# home level sops. see hosts/common/optional/sops.nix for hosts level
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  secretspath = builtins.toString inputs.mysecrets;
  homeDir = config.home.homeDirectory;
  keyLocation =
    if (pkgs.stdenv.hostPlatform.isDarwin)
    then builtins.toPath "${homeDir}/Library/Application Support/sops/age/keys.txt"
    else builtins.toPath "${homeDir}/.config/sops/age/keys.txt";
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # gnupg = {
    #   home = "/var/lib/sops";
    #   sshKeyPaths = [ ];
    # }

    # This is the key and needs to have been copied to this location on the host
    age.keyFile = keyLocation;

    defaultSopsFile = "${secretspath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "taskwarrior/user-cert" = {
        path = "${homeDir}/.task/cert.pem";
        mode = "0400";
      };
      "taskwarrior/user-key" = {
        path = "${homeDir}/.task/key.pem";
        mode = "0400";
      };
      "github/ssh-pub" = {
        path = "${homeDir}/.ssh/github.pub";
        mode = "0400";
      };
      "github/ssh-key" = {
        path = "${homeDir}/.ssh/github";
        mode = "0400";
      };
      "obsidian/api-key" = {
        path = "${homeDir}/.obsidian/api-key";
        mode = "0400";
      };
    };
  };
}

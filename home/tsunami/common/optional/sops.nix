# home level sops. see hosts/common/optional/sops.nix for hosts level
# TODO should I split secrtets.yaml into a home level and a hosts level or move to a single sops.nix entirely?
{
  inputs,
  pkgs,
  ...
}: let
  secretspath = builtins.toString inputs.mysecrets;
  homeDir =
    if pkgs.system == "x86_64-darwin"
    then "/Users/tsunami"
    else "/home/tsunami";
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
    age.keyFile =
      if pkgs.system == "x86_64-darwin"
      then builtins.toPath "/Users/tsunami/Library/Application Support/sops/age/keys.txt"
      else builtins.toPath "/home/tsunami/.config/sops/age/keys.txt";

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

      # "private_keys/id_ed25519" = {
      #   path = "/home/tsunami/.ssh/id_ed25519";
      # };
      # "private_keys/id_rsa_yubikey.nano5c" = {
      #   path = "/home/tsunami/.ssh/id_rsa_yubikey.nano5c.ec25519";
      # };
    };
  };
}
